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
		Date startdate = parseDate("1-" + today.getMonthOfYear() + "-" + today.getYear(),"d-m-yyyy")
		
		def newclients = Parent.createCriteria().list  {
			between('dateCreated',startdate, today.toDate() )
		}

		def newchildren = Child.createCriteria().list {
			between('dateCreated',startdate, today.toDate() )
		}
		def newvisits = Visit.createCriteria().list {
			between('dateCreated',startdate, today.toDate() )
		}
		def notifications = Notification.createCriteria().list {
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
		ostats.statsdata.num_visits = Visit?.list().size()
		ostats.statsdata.num_notifications = notifications?.size()
		render ostats as JSON
	}
	
	def export(params){
		def startdate = params?.startDate_open
		def enddate = params?.endDate_open
		
		if(startdate != null & startdate != "") startdate = parseDate(startdate,"dd-MMM-yyyy") else startdate = new DateTime().minusMonths(24).toDate()
		if(enddate != null  & startdate != "") enddate = parseDate(enddate,"dd-MMM-yyyy") else enddate = (new Date())
		
		def visitList = Visit.createCriteria().list(params){
			if(startdate != null & enddate != null){
				between('starttime', startdate, enddate)
			}
		}
		
		def childList = []
		def clientList = []
	
		visitList?.each {thisvisit ->
			
			childList.add(thisvisit?.child)					
			clientList.add(thisvisit?.child?.parent)
		}


		def clientHeaders = ['Name',
			'Tel',
			'Membership No',			
			'Item Id']
		
		
		def withClientProperties = ['person.fullname',
			'person.mobileNo',
			'membershipNo',			
			'id'
			]
		def visitHeaders = ['Check-In','Check-Out','Child Name','Item Id','Child Id']
		def withVisitProperties = ['starttime','endtime','child.person.fullname','id','child.id']
		
		def childHeaders = ['Name','Age','Date Created','Item Id','Parent Id']
		def withChildProperties = ['child.person.fullname','child.person.age','datecreated','id','child.parent.id']
		
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
