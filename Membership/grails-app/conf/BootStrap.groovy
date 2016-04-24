import java.util.logging.Level.KnownLevel;

import cland.membership.lookup.Keywords
import cland.membership.security.*
import cland.membership.*

class BootStrap {
	def groupManagerService
    def init = { servletContext ->
		TimeZone.setDefault(TimeZone.getTimeZone("Australia/Perth"))
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
		//	println ("2. Login ...")
		//	loginAsAdmin()
			println ("3. Initialize Request map ...")
			initRequestmap()
			
			println("4. Creating other default records...")
			createOther()
			/*switch(Environment.getCurrent()){
				case "DEVELOPMENT":
				createLocations()
					println ("1. Create users ...")
					createUsers("admin123")
				//	println ("2. Login ...")
				//	loginAsAdmin()
					println ("3. Initialize Request map ...")
					initRequestmap()
				//	println ("5. Logout ...")
					// logout
				//	SCH.clearContext()
				break
				case "PRODUCTION":
					println ("1. Create users ...")
					createUsers("admin123")
				//	println ("2. Login ...")
				//	loginAsAdmin()
					println ("3. Initialize Request map ...")
					initRequestmap()
				break
			} //end switch*/
		} //end doBootStrap
    }
    def destroy = {
    }
		
	private boolean createUsers(String pwd) {
		//Create office and person
		def personDev
		def personAdmin
		def race = new Race(name: "African", dateCreated: new Date(), lastUpdated: new Date()).save(flush: true)
		//if(!race.save(flush: true)){
			println "Race saved " + race
			personAdmin = new Person(enabled: true,firstName:"Sys",lastName:"Sysuser",username: "admin", password: pwd, email: "email@doman.com", gender:Gender.MALE.toString(),	idNumber :"10101010101", dateOfBirth:(new Date() - 365*30),mobileNo:"+621859123")
			 
		//	if(!personAdmin.save(flush: true)){
		//		println("personAdmin error...")
		//		personAdmin.errors
		//	}else{
		//		println "Admin person saved!" //  + personAdmin.toString()
		//	}
			
			personDev = new Person( enabled: true,firstName:"Sys",lastName:"Devuser", username: "dev", password: pwd, email: "email@doman.com", gender:Gender.FEMALE.toString(),	idNumber :"156456556551", dateOfBirth:(new Date() - 365*30),mobileNo:"+62132123") //.save(flush: true)
		//	if(!personDev.save(flush: true)){
		//		println("personDev error...")
		//		personDev.errors
		//	}else{
		//		println "Dev person saved! " //+ personDev.toString()
		//	}
			
			def mainOffice = new Office(name:"Main Office",code:"NHO",status:"Active")
			mainOffice.addToStaff(personAdmin)
			mainOffice.addToStaff(personDev)
			mainOffice.save()
			if(mainOffice.hasErrors()) {
				println mainOffice.errors
				return false;
			}
		/*}else{
			println "Errors race"
			println race.errors
			race.errors.each {
				println it
			}
		}*/
		try{
			//create ROLES
		//	new Role(authority:"ROLE_ADMINTEST",description:"test description").save(flush:true)
			groupManagerService.generateRoles()
			/*groupManagerService.generateOfficeGroups(mainOffice)*/
			
			println ">> find roles to assign to groups"
			def adminRole = Role.findByAuthority(SystemRoles.ROLE_ADMIN.value)	 			
			def userRole = Role.findByAuthority(SystemRoles.ROLE_USER.value) //new Role(authority:"ROLE_USER").save(flush:true)
			def devRole = Role.findByAuthority(SystemRoles.ROLE_DEVELOPER.value) //new Role(name: "GROUP_DEV").save(flush: true)
			def managerRole = Role.findByAuthority(SystemRoles.ROLE_MANAGER.value)
			def assistantRole = Role.findByAuthority(SystemRoles.ROLE_ASSISTANT.value)
			
			println ">> create groups"
			def adminGroup = new RoleGroup(name:"GROUP_ADMIN",description:"Administrators Group").save(flush:true)
			if(adminGroup.hasErrors()) adminGroup.errors
			def userGroup = new RoleGroup(name:"GROUP_USER",description:"Users Group").save(flush:true)
			if(userGroup.hasErrors()) userGroup.errors
			def devGroup = new RoleGroup(name: "GROUP_DEVELOPER",description:"Developers Group").save(flush:true)
			if(devGroup.hasErrors()) devGroup.errors
			def managerGroup = new RoleGroup(name:"GROUP_MANAGER",description:"Manager Group").save(flush:true)
			if(managerGroup.hasErrors()) managerGroup.errors
			def assistantGroup = new RoleGroup(name:"GROUP_ASSISTANT",description:"Assistant Group").save(flush:true)
			if(assistantGroup.hasErrors()) assistantGroup.errors
			
			println ">> creating RoleGroupRoles..."
			RoleGroupRole.create adminGroup, adminRole
			RoleGroupRole.create userGroup, userRole 
			RoleGroupRole.create devGroup, devRole
			RoleGroupRole.create managerGroup, managerRole
			RoleGroupRole.create assistantGroup, assistantRole
			
			println ">> adding person(s) to groups"
			PersonRoleGroup.create personAdmin, adminGroup
			println ">> padmin"
			PersonRoleGroup.create personDev, devGroup
			println ">> pdev"
			/*1.times {
				long id = it + 1
				def user = new Person(username: "dev$id", enabled: true, password: pwd,person:personDev).save(flush:true)
				//UserRoleGroup.create user, devGroup
				if(!user.hasErrors()){
					println ">> Adding dev user to office groups"
					groupManagerService.addUserToGroup(user, mainOffice, SystemRoles.list())
				}else{
					println(user.errors)
				}
				
			}*/
		
			
		}catch(Exception e){
			println "Error " + e
			return false
		}
		
		return true
	} //end create users
	
	private void initRequestmap(){
		
		for (String url in [
			'/',
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
			 for (String url in ['/',
				 '/index',
				 '/acl/**/**',
				 '/person/personlist/**',
				 '/office/jq_list_cases',
				 '/office/jq_list_staff',
				 '/organisation/orglist/**',				 
				 '/country/**',
				 '/region/**',
				 '/report/**',
				 '/category/**',
				 '/**/show/**',
				  '/**/index/**',
				   '/Membership/*',
				   '/Membership/assets/*',
				   '/person/**',
				   '/person/edit/**',
				   '/person/create/**',
				   '/person/delete/**',
				   '/parent/delete/**',
				   '/parent/',
				   '/parent/*',
				   '/parent/edit/**',
				   '/parent/create/**',
				   '/parent/**',
				   '/booking/**',
				   '/child/*',
				   '/harare/smsdialogcreate/**',
				   '/htown',
				   '/harare/htown/**',
				   '*/child/*']) {
				  new RequestMap( url: url, configAttribute:'isFullyAuthenticated()').save()
			 }
		
			 //editing for office admin
			 for (String url in [
				 '/**/create/**',
				 '/**/dialogcreate/**',
				 '/**/dialogsave/**',
				 '/**/save/**',
				 '/**/update/**',
				 '/**/edit/**',
				 '/parent/search/**',
				 '/template/newtemplate/**',
				 '/requestMap/delete/**',
				 '/requestMap/update/**',
				 '/requestMap/show/**',
				 '/requestMap/edit/**',				 
				 '/requestMap/create/**']) {
				  new RequestMap( url: url, configAttribute:  SystemRoles.ROLE_ADMIN.value).save()
			 }
			  
			
			 //strictly admin
			 for (String url in [ '/requestMap/**',
				 '/admin/**',
				 '/**/delete/**',
				 '/office/delete/**',
				 '/role/**',
				 '/roleGroup/**',
				 '/settings/**',	
				 '/reports/**',
				 '/settings/edit/**']) {
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