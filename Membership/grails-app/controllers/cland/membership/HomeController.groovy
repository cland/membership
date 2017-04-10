package cland.membership

import grails.plugin.springsecurity.annotation.*
import org.joda.time.DateTime
import java.text.SimpleDateFormat

class HomeController {
	def cbcApiService
	def groupManagerService
	static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]
	def index = {
		def officeInstance = cbcApiService.getOfficeContext()
		DateTime today = new DateTime()
		if(groupManagerService.currentUser.toString().equalsIgnoreCase("Self Register")
			|| groupManagerService.currentUser.toString().equalsIgnoreCase("Self Register02")){			
			redirect (url:cbcApiService.getBasePath(request) + "selfregister", permanent:true)
		}
		if(groupManagerService.isStaff(null,null)){
			params.max = 50
			if(!params?.sort) params.sort = "bookingDate"
			if(!params?.order) params.order = "asc"
						
			def bookings = VisitBooking.createCriteria().list(params){
			//	office{
			//		idEq(officeInstance?.id)
			//	}
				ge("bookingDate",today.minusHours(1).toDate())
				le("bookingDate",today.plusHours((24-today.getHourOfDay())).toDate())
				eq("status","new")
				order('bookingDate','asc')
			}
			
			respond bookings, model:[visitBookingInstanceCount:bookings.size()]
			
		}
	}
	def index1 = {}
	
	def htown = {
		render (view:"index")
	}
	def aboutus = {
		render (view:"aboutus")
	}
	def contactus = {
		render (view:"aboutus")
	}
	def news = {
		render (view:"news")
	}
	def cbc = {
		//determine who is currently logged in and redirect them to the appropriate section:
		//admin: to the admin section
		String link = cbcApiService.getHomeLink()
		redirect(uri:link)
	}
	
} //end of class
