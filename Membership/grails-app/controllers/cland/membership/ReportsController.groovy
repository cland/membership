package cland.membership

import cland.membership.reports.OfficeSummaryStats
import grails.converters.JSON
import grails.plugin.springsecurity.annotation.*
import java.text.SimpleDateFormat
import org.joda.time.DateTime
import pl.touk.excel.export.WebXlsxExporter

class ReportsController {
	static allowedMethods = [officeSummaryStats: "POST", export: "POST"]
	def index = {

	}		
	def officeSummaryStats(){
		Office o = Office.list().first()
	
		//clients created this month
		DateTime today = new DateTime()
		Date startdate = parseDate(today.getMonthOfYear() + "/1/" + today.getYear(),"M/d/yyyy")
		
		def newclients = Parent.createCriteria().list  {
			between('dateCreated',startdate, today.toDate() )
		}

		def newchildren = Child.createCriteria().list {
			between('dateCreated',startdate, today.toDate() )
		}
		Settings settings = Settings.list().first()
		/*
		def promokids = Child.findAll {
			(visits?.size() >= settings?.visitcount)
		}
		*/

		def visitsData =  Visit.createCriteria().list {
				createAlias('child','c')
				createAlias('c.person','p')
				createAlias('c.parent','par')
				projections {
					groupProperty('c.id')
				    property('p.firstName')
				    property('p.lastName')				    
				    countDistinct('id', 'idDistinct')					
				}
				eq("status","Complete")
				order('idDistinct','desc')				
			 } //
		
		def visitsDailyReport =  Visit.createCriteria().list {
				
				projections {
					groupProperty('startyear')
					groupProperty('startmonth')
				    property('starttime')					
				    countDistinct('id', 'idDistinct')
					// sum("totalMinutes")					
				} 
				eq("status","Complete")
				order('starttime','desc')				
			 }
		println (visitsDailyReport)
		def promokids = visitsData.findAll{(it[3] % settings?.visitcount)==0}
		
		def newvisits = Visit.createCriteria().list {
			between('dateCreated',startdate, today.toDate() )
			eq("status", "Complete")
		}
		
		def notifications = Notification.createCriteria().list {
			between('dateCreated',startdate, today.toDate() )
		}
		
		def new_coupons = Coupon.createCriteria().list{
			between('dateCreated',startdate, today.toDate() )
		}
		OfficeSummaryStats ostats = new OfficeSummaryStats()
		ostats.startdate=new Date()
		ostats.enddate = new Date()
		ostats.promokids = promokids
		ostats.office_name = o?.name
		ostats.office_id = o?.id
		ostats.statsdata.num_new_clients = newclients?.size()
		ostats.statsdata.num_clients = Parent?.list()?.size()
		ostats.statsdata.num_new_children = newchildren?.size()
		ostats.statsdata.num_children = Child?.list().size()
		ostats.statsdata.num_new_visits = newvisits?.size()
		ostats.statsdata.num_visits = Visit?.createCriteria().list {eq("status", "Complete")}?.size()
		ostats.statsdata.num_notifications = notifications?.size()
		ostats.statsdata.num_promo_children = promokids?.size()
		ostats.statsdata.num_coupons = Coupon.list().size()
		ostats.statsdata.num_new_coupons = new_coupons?.size()
		
		render ostats as JSON
	}
	
	def export(params){
		def startdate = params?.startDate_open
		def enddate = params?.endDate_open
		
		if(startdate != null & startdate != "") startdate = parseDate(startdate,"dd-MMM-yyyy") else startdate = new DateTime().minusMonths(24).toDate()
		if(enddate != null  & startdate != "") enddate = parseDate(enddate,"dd-MMM-yyyy") else enddate = (new Date())
		
		// ** VISITS
		def visitList = Visit.createCriteria().list(params){
			if(startdate != null & enddate != null){
				between('starttime', startdate, enddate)
			}
		}
				
		def visitHeaders = ['Child Name','Duration','Check-In','Check-Out','Age','Date of Birth','Gender','Status','Visit Contact No.',
			'Parent Name','Mobile No.','Membership No.','Parent Email','Access Number',
			'Emergency Contact','Emergency Contact No.',
			'Item Id','Child Id', 'Parent Id']
		def withVisitProperties = ['child.person.fullname','duration.businesshours','starttime','endtime','child.person.age','child.person.birthdate','child.person.gender','status','contactno',
			'child.parent.person1.fullname','child.parent.person1.mobileno','child.parent.membershipno','child.parent.person1.email','child.fullaccessnumber',
			'child.parent.person2.fullname','child.parent.person2.mobileno',
			'id','child.id','child.parent.id']		
		
		// ** COUPONS
		def couponsList = Coupon.list()		
		def couponsHeaders = ['Client Name','Membership No.',
			'Coupon No.',
			'Max Visit Hours',
			'Visits Left','Visit Count','Date Activated','Expiry Date',
			'Item Id']
		def withCouponsProperties = ['parentname','membershipno',
			'refno',
			'maxvisits',
			'balance',
			'visitcount',
			'startdate','expirydate',
			'id'
			]
		
		//** CHILD LIST
		def childList = []
		/* visitList?.each {thisvisit ->
			childList.add(thisvisit?.child)
			//clientList.add(thisvisit?.child?.parent)
		} */
		def childHeaders = ['Name','Age','Date Of Birth','Gender','Total Visits','Access Number','Parent Name','Mobile No.','Membership No.','Parent Email','Date Created','Item Id','Parent Id']
		def withChildProperties = ['child.person.fullname','child.person.age','child.person.birthdate','child.person.gender','visitcount','fullaccessnumber','parent.person1.fullname','parent.person1.mobileno','parent.membershipno','parent.person1.email','dateCreated','id','child.parent.id']
		
		//** PARENT/CLIENT LIST
		//def clientList = Parent.list()
		def clientHeaders = ['Client Name',
			'Mobile No.',
			'Membership No',
			'Emergency Contact','Emergency Contact No.',
			'Item Id']
		def withClientProperties = ['person1.fullname',
			'person1.mobileNo',
			'membershipNo',
			'person1.email',
			'person2.fullname','person2.mobileNo',
			'id'
			]
		
		//Build the export report
		println(">> Exporting report...")
		new WebXlsxExporter().with {
			setResponseHeaders(response)
			sheet('Visits').with {
				fillHeader(visitHeaders)
				add(visitList*.toMap(), withVisitProperties)
			}
			sheet('Coupons').with {
				fillHeader(couponsHeaders)
				add(couponsList*.toMap(), withCouponsProperties)
			}
		/*	sheet('Child List').with{
				fillHeader(childHeaders)
				add(childList*.toMap(),withChildProperties)
			}
			sheet('Clients').with{
				fillHeader(clientHeaders)
				add(clientList,withClientProperties)
			} */			
			save(response.outputStream)
		}
	} //
	
	private parseDate(date,fmt) {
		SimpleDateFormat df = new SimpleDateFormat(fmt);
		return (!date) ? new Date() : df.parse(date)
   }
} //end of class
