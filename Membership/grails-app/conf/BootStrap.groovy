import java.util.logging.Level.KnownLevel;

import cland.membership.lookup.Keywords
import cland.membership.security.*
import cland.membership.*

class BootStrap {
	def groupManagerService
    def init = { servletContext ->
		//TimeZone.setDefault(TimeZone.getTimeZone("Australia/Perth"))
		boolean doBootStrap = false
		
		def userlist = Person.list()
		if(userlist?.size() < 1){
			println("BootStrap >> ON!")
			doBootStrap = true
		}else{
			println("BootStrap >> off!")
		}
		if(doBootStrap){
			println "Doing Bootstrap"
			println ("1. Create users ...")
			createUsers("admin123")		
			println ("3. Initialize Request map ...")
			initRequestmap()
			
			println("4. Creating other default records...")
			createOther()			
		} //end doBootStrap
    }
    def destroy = {
    }
		
	private boolean createUsers(String pwd) {
		//Create office and person
		def personDev
		def personAdmin
		def personManager
		def personAssistant
		def race = new Race(name: "African", dateCreated: new Date(), lastUpdated: new Date()).save(flush: true)
		new Race(name: "Caucasian", dateCreated: new Date(), lastUpdated: new Date()).save(flush: true)
		//if(!race.save(flush: true)){
			println "Race saved " + race
			personAdmin = new Person(enabled: true,firstName:"System",lastName:"Administrator",username: "admin", password: "2016Admin1", email: "email@doman.com", idNumber :"10101010101", dateOfBirth:(new Date() - 365*30),mobileNo:"+621859123")					
			personDev = new Person( enabled: true,firstName:"Sys",lastName:"Devuser", username: "dev", password: "2016Dev1", email: "email@doman.com", idNumber :"15689", dateOfBirth:(new Date() - 365*30),mobileNo:"+62132123") //.save(flush: true)
			personManager = new Person( enabled: true,firstName:"Manager",lastName:"Wiggly", username: "manager", password: "16manager20", email: "email@doman.com", idNumber :"m005", dateOfBirth:(new Date() - 365*30),mobileNo:"+62132123") //.save(flush: true)
			personAssistant = new Person( enabled: true,firstName:"Assistant",lastName:"Wiggly", username: "assistant", password: "assistant1", email: "email@doman.com", idNumber :"a001", dateOfBirth:(new Date() - 365*30),mobileNo:"+62132123") //.save(flush: true)
			
			def mainOffice = new Office(name:"Main Office",code:"NHO",status:"Active")
			mainOffice.addToStaff(personAdmin)
			mainOffice.addToStaff(personDev)
			mainOffice.addToStaff(personManager)
			mainOffice.addToStaff(personAssistant)
			mainOffice.save()
			if(mainOffice.hasErrors()) {
				println mainOffice.errors
				return false;
			}
		
		try{
			//create ROLES
			groupManagerService.generateRoles()
			/*groupManagerService.generateOfficeGroups(mainOffice)*/
			
			println ">> find roles to assign to groups"
			def adminRole = Role.findByAuthority(SystemRoles.ROLE_ADMIN.value)	 			
			def userRole = Role.findByAuthority(SystemRoles.ROLE_USER.value) //new Role(authority:"ROLE_USER").save(flush:true)
			def devRole = Role.findByAuthority(SystemRoles.ROLE_DEVELOPER.value) //new Role(name: "GROUP_DEV").save(flush: true)
			def managerRole = Role.findByAuthority(SystemRoles.ROLE_MANAGER.value)
			def assistantRole = Role.findByAuthority(SystemRoles.ROLE_ASSISTANT.value)
			def reviewerRole = Role.findByAuthority(SystemRoles.ROLE_REVIEWER.value)
			
			println ">> create groups"
			def adminGroup = new RoleGroup(name:"GROUP_ROLE_ADMIN",description:"Administrators Group").save(flush:true)
			if(adminGroup.hasErrors()) adminGroup.errors
			def userGroup = new RoleGroup(name:"GROUP_ROLE_USER",description:"Users Group").save(flush:true)
			if(userGroup.hasErrors()) userGroup.errors
			def devGroup = new RoleGroup(name: "GROUP_ROLE_DEVELOPER",description:"Developers Group").save(flush:true)
			if(devGroup.hasErrors()) devGroup.errors
			def managerGroup = new RoleGroup(name:"GROUP_ROLE_MANAGER",description:"Manager Group").save(flush:true)
			if(managerGroup.hasErrors()) managerGroup.errors
			def assistantGroup = new RoleGroup(name:"GROUP_ROLE_ASSISTANT",description:"Assistant Group").save(flush:true)
			if(assistantGroup.hasErrors()) assistantGroup.errors
			def reviewerGroup = new RoleGroup(name:"GROUP_ROLE_REVIEWER",description:"Reviewer or Read only Group").save(flush:true)
			if(reviewerGroup.hasErrors()) reviewerGroup.errors
			
			println ">> creating RoleGroupRoles..."
			RoleGroupRole.create adminGroup, adminRole
			RoleGroupRole.create userGroup, userRole 
			RoleGroupRole.create devGroup, devRole
			RoleGroupRole.create managerGroup, managerRole
			RoleGroupRole.create assistantGroup, assistantRole
			RoleGroupRole.create reviewerGroup, reviewerRole
			
			println ">> adding person(s) to groups"
			PersonRoleGroup.create personAdmin, adminGroup
			println ">> padmin "
			PersonRoleGroup.create personDev, devGroup
			PersonRoleGroup.create personDev, adminGroup
			println ">> pdev"	
			PersonRoleGroup.create personManager, managerGroup
			println ">> manager "
			PersonRoleGroup.create personAssistant, assistantGroup
			println ">> assistant "
			
		}catch(Exception e){
			println "Error " + e
			return false
		}
		
		return true
	} //end create users
	
	private void initRequestmap(){
		
		for (String url in [		
			 '/**/favicon.ico',
			 '/**/js/**',
			 '/**/css/**',
			 '/**/images/**',
			 '/login',
			 '/login.*',
			 '/login/*',
			 '/logout',
			 '/logout.*',
			 '/logout/*',			 
			 '/assets/*']) {
			 new RequestMap( url: url, configAttribute: 'permitAll').save()
		}
			 // show and lists/index
			 for (String url in [
				 '/',
				 '/index',
				 '/**/show/**',
				  '/**/index/**',
				   '/person/**',
				   '/person/edit/**',
				   '/person/create/**',				   
				   '/parent/',
				   '/parent/*',
				   '/parent/edit/**',
				   '/parent/create/**',
				   '/parent/**',
				   '/booking/**',
				   '/child/*']) {
				  new RequestMap( url: url, configAttribute:'isFullyAuthenticated()').save()
			 }
		
			 //ASSISTANT, MANAGER, ADMIN, DEVELOPER (Basically Staff)
			   for (String url in [
				   '/**/create/**',
				   '/**/dialogcreate/**',
				   '/**/dialogsave/**',
				   '/**/save/**',
				   '/**/update/**',
				   '/**/edit/**',
				   '/country/**',
					'/region/**',
					'/category/**',
				   '/person/delete/**',
					'/parent/delete/**',
				   '/harare/smsdialogcreate/**',
					'/htown',
					'/harare/htown/**',
					'/harare/savenote/**',
				   '/person/personlist/**',
					'/office/jq_list_cases',
					'/office/jq_list_staff',
					'/organisation/orglist/**',
				   '/reports/**',
				   '/reports/officeSummaryStats/**',
				   '/parent/search/**']) {
					new RequestMap( url: url, configAttribute:  SystemRoles.ROLE_ADMIN.value + ','
						+ SystemRoles.ROLE_DEVELOPER.value + ','
						+ SystemRoles.ROLE_MANAGER.value + ','
						+ SystemRoles.ROLE_ASSISTANT.value).save()
			   }
				   
			 //ADMIN, MANAGER
			 for (String url in [				 
				 '/reports/**',
				 '/reports/officeSummaryStats/**',
				 '/settings/**',
				  '/settings/edit/**']) {
				  new RequestMap( url: url, configAttribute:  SystemRoles.ROLE_ADMIN.value + ',' 
					  + SystemRoles.ROLE_DEVELOPER.value + ',' 
					  + SystemRoles.ROLE_MANAGER.value).save()
			 }
			  
			
			 //strictly ADMIN, DEVELOPER
			 for (String url in [ 
				 '/acl/grouplist/**',
				 '/acl/office_groups/**',
				 '/admin/**',
				 '/**/delete/**',
				 '/office/delete/**',
				 '/role/**',
				 '/roleGroup/**',				 
				 '/template/newtemplate/**',
				 '/requestMap/**',
				 '/requestMap/delete/**',
				 '/requestMap/update/**',
				 '/requestMap/show/**',
				 '/requestMap/edit/**',				 
				 '/requestMap/create/**']) {
				 new RequestMap( url: url, configAttribute: SystemRoles.ROLE_ADMIN.value).save()
			}
	} //end method
	private void createOther(){
		new Settings(name:"Wiggly Toes IPC",title:"Wiggly Toes",subtitle:"Indoor Play Centre",visitcount:5,notifytime:5).save(flush:true)
		def keyword = new Keywords(name: "RelationshipTypes",label:"Relationship Types",category:"system_keywords")
		keyword.addToValues(new Keywords(name:"Mother",label:"Mother",category:"System")	)
		keyword.addToValues(new Keywords(name:"Father",label:"Father",category:"System")	)
		keyword.addToValues(new Keywords(name:"Guardian",label:"Guardian",category:"System")	)
		keyword.save()
		if(keyword.hasErrors()){ println keyword.errors }
		
		keyword = new Keywords(name: "ClientTypes",label:"Client Types",category:"system_keywords")
		keyword.addToValues(new Keywords(name:"Standard",label:"Standard",category:"System")	)
		keyword.addToValues(new Keywords(name:"Member",label:"Member",category:"System")	)
		keyword.addToValues(new Keywords(name:"Contract",label:"Premium Contract",category:"System")	)
		keyword.save()
		if(keyword.hasErrors()){ println keyword.errors }
		
		//Gender
		keyword = new Keywords(name: "Gender",label:"Gender",category:"system_keywords")
		keyword.addToValues(new Keywords(name:"Male",label:"Male",category:"System")	)
		keyword.addToValues(new Keywords(name:"Female",label:"Female",category:"System")	)
		keyword.save()
		if(keyword.hasErrors()){ println keyword.errors }
		
		//Time slots: 10:00 - 11:30  |  11:30 - 13:00 | 13:00 - 14:30
		keyword = new Keywords(name: "PartyTimeSlots",label:"Time Slots",category:"system_keywords")
		keyword.addToValues(new Keywords(name:"Timeslot1",label:"10:00 - 11:30",category:"Birth Day Time")	)
		keyword.addToValues(new Keywords(name:"Timeslot2",label:"11:30 - 13:00",category:"Birth Day Time")	)
		keyword.addToValues(new Keywords(name:"Timeslot3",label:"13:00 - 14:30",category:"Birth Day Time")	)
		keyword.save()
		if(keyword.hasErrors()){ println keyword.errors }
		
		//booking type: Birthday | Group
		keyword = new Keywords(name: "BookingType",label:"Booking Type",category:"system_keywords")
		keyword.addToValues(new Keywords(name:"Birthday",label:"Birthday",category:"Booking Type")	)
		keyword.addToValues(new Keywords(name:"Group",label:"Group",category:"Booking Type")	)		
		keyword.save()
		if(keyword.hasErrors()){ println keyword.errors }
		
		//room: Red | Yellow
		keyword = new Keywords(name: "Room",label:"Rooms",category:"system_keywords")
		keyword.addToValues(new Keywords(name:"Room1",label:"Red",category:"Rooms")	)
		keyword.addToValues(new Keywords(name:"Room2",label:"Yellow",category:"Rooms")	)
		keyword.save()
		if(keyword.hasErrors()){ println keyword.errors }
		
		//Party Package: STANDARD | Wiggly Party
		keyword = new Keywords(name: "PartyPackage",label:"Party Packages",category:"system_keywords")
		keyword.addToValues(new Keywords(name:"Package1",label:"Standard",category:"Party Packages")	)
		keyword.addToValues(new Keywords(name:"Package2",label:"Wiggly Party",category:"Party Packages")	)
		keyword.save()
		if(keyword.hasErrors()){ println keyword.errors }
		
		//Party Theme: Fairy | Children's Jungle | Happy Birthday | Princess | Under The Sea
		keyword = new Keywords(name: "PartyTheme",label:"Party Themes",category:"system_keywords")
		keyword.addToValues(new Keywords(name:"Theme1",label:"Fairy",category:"Party Themes")	)
		keyword.addToValues(new Keywords(name:"Theme2",label:"Children's Jungle",category:"Party Themes")	)
		keyword.addToValues(new Keywords(name:"Theme3",label:"Happy Birthday",category:"Party Themes")	)
		keyword.addToValues(new Keywords(name:"Theme4",label:"Princess",category:"Party Themes")	)
		keyword.addToValues(new Keywords(name:"Theme5",label:"Under The Sea",category:"Party Themes")	)
		keyword.save()
		if(keyword.hasErrors()){ println keyword.errors }
		
	} //end createOther
}