package cland.membership.security
import static org.springframework.http.HttpStatus.*
import cland.membership.Office
import grails.converters.JSON
class AclController {
	def springSecurityService
	def groupManagerService
	
    def index() { }
	
	def office_groups(){
		Office office = Office.get(params?.id)
		if(office == null) return []
		
		render groupManagerService.getOfficeGroups(office) as JSON
	}
	def grouplist(){
		render groupManagerService.listGroups(params) as JSON
	}
		
} //end class
