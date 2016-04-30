package cland.membership

import grails.plugin.springsecurity.annotation.*

class HomeController {
	def cbcApiService
	static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]
	def index = {
		
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
