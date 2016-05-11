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
		OfficeSummaryStats ostats = new OfficeSummaryStats()
		ostats.startdate=new Date()
		ostats.enddate = new Date()
		ostats.office_name = o?.name
		ostats.office_id = o?.id
		ostats.statsdata.num_new_clients = 1
		ostats.statsdata.num_clients = 3
		ostats.statsdata.num_new_children = 2
		ostats.statsdata.num_children = 5
		ostats.statsdata.num_new_visits = 8
		ostats.statsdata.num_visits = 33
		render ostats as JSON
	}
	def export(params){
		def startdate = params?.startDate_open
		def enddate = params?.endDate_open
		
		if(startdate != null & startdate != "") startdate = parseDate(startdate) else startdate = new DateTime().minusMonths(24).toDate()
		if(enddate != null  & startdate != "") enddate = parseDate(enddate) else enddate = (new Date())
		
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
				fillHeader(clientHeaders)
				add(visitList*.toMap(), withCaseProperties)
			}
			sheet('Child List').with{
				fillHeader(visitHeaders)
				add(childList,withVisitProperties)
			}
			sheet('Clients').with{
				fillHeader(clientHeaders)
				add(clientList,withClientProperties)
			}			
			save(response.outputStream)
		}
	} //
	
	private parseDate(date) {
		SimpleDateFormat df = new SimpleDateFormat("dd-MMM-yyyy");
		return (!date) ? new Date() : df.parse(date)
   }
} //end of class
