package cland.membership

import javax.servlet.http.HttpServletRequest;

import javassist.expr.Instanceof;
import grails.plugin.springsecurity.*

import org.codehaus.groovy.grails.web.servlet.mvc.GrailsParameterMap;
//import org.codehaus.groovy.grails.plugins.springsecurity.*
import org.grails.datastore.gorm.finders.MethodExpression.IsEmpty;

import cland.membership.location.*
import cland.membership.security.*

import com.sun.org.apache.xalan.internal.xsltc.compiler.ForEach;

import org.apache.commons.lang.RandomStringUtils

/**
 * This service class should hold business logic related to cbc application only. 
 * @author Cland
 *
 */
class CbcApiService {
	static transactional = false
	def springSecurityService
	def groupManagerService
	
	
	Location saveLocation(params) throws Exception{
		def location = null	
		if(!params?.location?.id){		
			if(params?.location?.id == ""){				
				location = new Location(params?.location).save()			
				if(location.hasErrors()){
					throw new Exception("Failed to save new location... "  + location?.errors)
				}			
			}
		}
		
		return location
	}
	
	String getUserFullname(Long id){
		Person user = groupManagerService.getUser(id)
		if(user) return user?.person.toString()
		return ""
	}
	Office getUserPrimaryOffice(Person user = null){
		if(user == null){
			user = springSecurityService.getCurrentUser()
		}
		return user?.person?.office //getPrimaryOffice()
	} //end function
	
	def getUserAllowedOffices(Person user = null){
		if(user == null){
			user = springSecurityService.getCurrentUser()
		}
		if(groupManagerService.isAdmin()) return Office.list()
		List offices = []
		offices.add(user?.person?.getPrimaryOffice())
		//TODO: Search for office the user is elligible to work with. NB: groups will have the final say if user is actually allowed.
		
		return offices
	}
	
	boolean canView(Object obj){
		List <Office> allowedOffices = getUserAllowedOffices() //for currently logged in user
		if(obj?.instanceOf(Person)){
			Person p = obj
			if(allowedOffices?.contains(p?.office)) return true
		}else if(obj?.instanceOf(Office)){
			if(groupManagerService.isAdmin()) return true
			Office o = obj
			if(allowedOffices?.contains(o)) return true
			
		}else if(obj?.instanceOf(Parent)){
			if(groupManagerService.isAdmin()) return true
			
		}else if(obj?.instanceOf(Visit)){
			//for now		
			return true
		}
		
		return false
	} //end can view
	boolean canEdit(Object obj){
		if(obj?.instanceOf(Person)){
			Person p = obj
			
		}else if(obj?.instanceOf(Office)){
			Office o = obj
		}
		return false
	} //end canEdit
	
	String getHomeLink(){
		def status = ""
		if(springSecurityService.isLoggedIn()){
			Long userId = groupManagerService.getCurrentUserId() // springSecurityService?.currentUser?.id			
			if(groupManagerService.isAdmin()) return "/?" + status
		}
		
		//else we return the user back to home page.
		return "/?" + status
	}
	
	
	String generateIdNumber(Date birthday,Integer length){
		String charset = (('A'..'Z') + ('0'..'9')).iterator().join()
		
		String randomString = RandomStringUtils.random(length, charset.toCharArray())
		if(birthday == null) birthday = new Date();
		return birthday?.format("yyMMdd") + randomString
	}
	private static int findUpperIndex(int offset, int max, int total) {
		max = offset + max - 1
		if (max >= total) {
			max -= max - total + 1
		}
		return max
	} //end helper method findUpperIndex
	def getOfficesForUser(Person user = null, params){
		if(user == null){
			user = springSecurityService.getCurrentUser()
		}
		def results = Office.createCriteria().list(params){
			createAlias('staff',"s")
			eq('s.id',user?.person?.id)
		}
	}
	def getStaffForOffice(Office office=null,params){
		office = validateOfficeRights(office)

		def results = Person.createCriteria().list(params) {
				person {
					eq('office.id',office?.id)
				}
			//order('office.name','asc')
		}

		return results
//		def tmp = office?.staff*.getLoginDetails()
//		tmp.removeAll([null])
//		return tmp // office?.staff*.getLoginDetails()		
	} //end getStaffForOffice
	
	def getCaseWorkers(Office office, params){
		office = validateOfficeRights(office)
		//Set<RoleGroup> grps = getAuthorities()
		def results = Person.createCriteria().list(params) {
				person {
					eq('office.id',office?.id)
				}
				
			//order('office.name','asc')
		}
		return results?.findAll{groupManagerService.isOfficeCaseWorker(office, it) == true}
	}//
	
	def getClientsForOffice(Office office = null, params){
		office = validateOfficeRights(office)
	
		def results = Person.createCriteria().list(params) {
			eq('office.id',office?.id)			
			//order('office.name','asc')
		}
		return results
		
	} //
		
	def getClients(params){
		if(groupManagerService.isAdmin()){
			return Person.createCriteria().list(params) {}  //this is an admin function to return all cases
		}
		//Otherwise we check for office related cases only
		Office office = getUserPrimaryOffice()
		return getClientsForOffice(office, params)
	}
	def getOffices(params){
		if(groupManagerService.isAdmin()){
			return Office.createCriteria().list(params) {}  //this is an admin function to return all cases
		}
		return getOfficesForUser(springSecurityService.getCurrentUser(), params)
	}
	def getUsers(params){
		if(groupManagerService.isAdmin()){
			return Person.createCriteria().list(params) {}
		}
		return getStaffForOffice(getUserPrimaryOffice(), params)
	}
	

	def validateOfficeRights(Office office = null){
		if(!office) office = getUserPrimaryOffice()
		if(!groupManagerService.isAdmin()){
			//validate if this user is allowed to view this office information
			List allowedOffices = getUserAllowedOffices()  //for currently logged in user
			if(!allowedOffices?.contains(office)) office = getUserPrimaryOffice()
		}
		return office
	}
	String getBasePath(HttpServletRequest request){
		def _protocol = request.protocol
		def _servername = request.getServerName()
		def _port = ""
		if(_servername.equalsIgnoreCase("localhost")) _port = ":" + request.localPort
		return 'http://' + _servername + _port + request.contextPath +"/"
	}
	String generateUsername(String firstname, String lastname){
		String username = firstname.toLowerCase() + "." + lastname.toLowerCase()
		String tmp = username
		int count = 1
		while(Person.findByUsername(tmp) != null){
			tmp = username + count.toString()
			count++
		} 
		return tmp
	}
	Coupon findActiveCoupon(Parent parentInstance, Date now, int visitlimit){
		if(now == null) now = new Date()
		
		def coupons = Coupon.withCriteria(){
			createAlias("parent","p")
			eq("p.id",parentInstance?.id)					
			ge("expiryDate",now)
			le("startDate",now)	
			//maxResults 1		
		}
		def coupon = coupons.find{
			it.visitsLeft > visitlimit
		}
		return coupon
		/*
		def result = Coupon.validCoupons{
			createAlias("parent","p")
			
			eq("p.id",parentInstance?.id)
			
			ge("expiryDate",now)
			le("startDate",now)			
		}
		*/
		//return (coupons == null?null:coupons?.first())
	}
}//end class
