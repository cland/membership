import java.util.logging.Level.KnownLevel;

import cland.membership.security.*
import cland.membership.*

class BootStrap {
	def groupManagerService
    def init = { servletContext ->
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
			new Settings(name:"Wiggly Toes IPC",title:"Wiggly Toes",subtitle:"Indoor Play Centre",visitcount:5,notifytime:5).save(flush:true)
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
			personAdmin = new Person(enabled: true,firstName:"Sys",lastName:"Sysuser",username: "admin", password: pwd, email: "email@doman.com", gender:Gender.MALE.toString(),	idNumber :"10101010101", dateOfBirth:(new Date() - 365*30))
			 
		//	if(!personAdmin.save(flush: true)){
		//		println("personAdmin error...")
		//		personAdmin.errors
		//	}else{
		//		println "Admin person saved!" //  + personAdmin.toString()
		//	}
			
			personDev = new Person( enabled: true,firstName:"Sys",lastName:"Devuser", username: "dev", password: pwd, email: "email@doman.com", gender:Gender.FEMALE.toString(),	idNumber :"156456556551", dateOfBirth:(new Date() - 365*30)) //.save(flush: true)
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
			
			println ">> create groups"
			def adminGroup = new RoleGroup(name:"GROUP_ADMIN",description:"Administrators Group").save(flush:true)
			if(adminGroup.hasErrors()) adminGroup.errors
			def userGroup = new RoleGroup(name:"GROUP_USER",description:"Users Group").save(flush:true)
			if(userGroup.hasErrors()) userGroup.errors
			def devGroup = new RoleGroup(name: "GROUP_DEVELOPER",description:"Developers Group").save(flush:true)
			if(devGroup.hasErrors()) devGroup.errors
			
			/*def devGroup = new RoleGroup(name:"GROUP_DEVELOPER").save(flush:true)
			def userGroup = new RoleGroup(name:"GROUP_USER").save(flush:true)*/
			println ">> creating RoleGroupRoles..."
			RoleGroupRole.create adminGroup, adminRole
			RoleGroupRole.create userGroup, userRole 
			RoleGroupRole.create devGroup, devRole
			/*RoleGroupRole.create userGroup, userRole*/
			
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
				   '/Membership/child/*',
				   '/child/*',
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
				 '/settings/edit/**']) {
				 new RequestMap( url: url, configAttribute: SystemRoles.ROLE_ADMIN.value).save()
			}
	} //end method
}