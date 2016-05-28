package cland.membership

import grails.plugin.springsecurity.annotation.*

class HomeController {
	def cbcApiService
	def groupManagerService
	static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]
	def index = {
		if(groupManagerService.currentUser.toString().equalsIgnoreCase("Self Register")){			
			redirect (url:cbcApiService.getBasePath(request) + "selfregister", permanent:true)
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
