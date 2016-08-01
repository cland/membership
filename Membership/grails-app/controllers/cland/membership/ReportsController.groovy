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
				projections {
				   property('p.firstName')
				   property('p.lastName')
				   groupProperty('c.id')
				   countDistinct('id', 'idDistinct')
				}
				eq("status","Complete")
				order('idDistinct','desc')				
			 }
		
		def promokids = visitsData.count { 
			it[3] >= settings?.visitcount
		}
		
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
		ostats.office_name = o?.name
		ostats.office_id = o?.id
		ostats.statsdata.num_new_clients = newclients?.size()
		ostats.statsdata.num_clients = Parent?.list()?.size()
		ostats.statsdata.num_new_children = newchildren?.size()
		ostats.statsdata.num_children = Child?.list().size()
		ostats.statsdata.num_new_visits = newvisits?.size()
		ostats.statsdata.num_visits = Visit?.createCriteria().list {eq("status", "Complete")}?.size()
		ostats.statsdata.num_notifications = notifications?.size()
		ostats.statsdata.num_promo_children = promokids
		ostats.statsdata.num_coupons = Coupon.list().size();
		ostats.statsdata.num_new_coupons = new_coupons?.size();
		render ostats as JSON
	}
	
	def export(params){
		def startdate = params?.startDate_open
		def enddate = params?.endDate_open
		
		if(startdate != null & startdate != "") startdate = parseDate(startdate,"dd-MMM-yyyy") else startdate = new DateTime().minusMonths(24).toDate()
		if(enddate != null  & startdate != "") enddate = parseDate(enddate,"dd-MMM-yyyy") else enddate = (new Date())
		
		def visitList = Visit.createCriteria().list(params){
			//if(startdate != null & enddate != null){
			//	between('starttime', startdate, enddate)
			//}
		}
		
		def childList = []
		def clientList = Parent.list()
	
		visitList?.each {thisvisit ->
			
			childList.add(thisvisit?.child)					
			//clientList.add(thisvisit?.child?.parent)
		}
		def visitHeaders = ['Child Name','Duration','Check-In','Check-Out','Age','Date of Birth','Gender','Status','Visit Contact No.',
			'Selected Hours','Parent Name','Mobile No.','Membership No.','Parent Email','Current Total Visits','Access Number',
			'Emergency Contact','Emergency Contact No.',
			'Item Id','Child Id', 'Parent Id']
		def withVisitProperties = ['child.person.fullname','durationText','starttime','endtime','child.person.age','child.person.dateOfBirth','child.person.gender','status','contactNo',
			'selectedHours','child.parent.person1.fullname','child.parent.person1.mobileNo','child.parent.membershipNo','child.parent.person1.email','child.visitCount','child.fullAccessNumber',
			'child.parent.person2.fullname','child.parent.person2.mobileNo',
			'id','child.id','child.parent.id']

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
		
		
		def childHeaders = ['Name','Age','Date Of Birth','Gender','Total Visits','Access Number','Date Created','Parent Name','Mobile No.','Membership No.','Parent Email','Item Id','Parent Id']
		def withChildProperties = ['child.person.fullname','child.person.age','child.person.dateOfBirth','child.person.gender','Current Total Visits','Access Number','parent.person1.fullname','parent.person1.mobileNo','parent.membershipNo','parent.person1.email','dateCreated','id','child.parent.id']
		
		new WebXlsxExporter().with {
			setResponseHeaders(response)
			sheet('Visits').with {
				fillHeader(visitHeaders)
				add(visitList*.toMap(), withVisitProperties)
			}
			sheet('Child List').with{
				fillHeader(childHeaders)
				add(childList,withChildProperties)
			}
			sheet('Clients').with{
				fillHeader(clientHeaders)
				add(clientList,withClientProperties)
			}			
			save(response.outputStream)
		}
	} //
	
	private parseDate(date,fmt) {
		SimpleDateFormat df = new SimpleDateFormat(fmt);
		return (!date) ? new Date() : df.parse(date)
   }
} //end of class
