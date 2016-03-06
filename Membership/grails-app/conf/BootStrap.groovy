import java.util.logging.Level.KnownLevel;

import cland.membership.security.Person
import cland.membership.security.PersonRole
import cland.membership.security.RequestMap
import cland.membership.security.RoleGroup
import cland.membership.security.RoleGroupRole
import cland.membership.security.Role
import cland.membership.*

class BootStrap {

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
			println "Race saved"
			 personAdmin = new Person(firstName:"Sys",lastName:"Sysuser", 
				username: "admin", password: pwd, email: "email@doman.com", gender:"Male",
				knownAs: "Sys", race: Race.get(1))
			 personDev = new Person(firstName:"Sys",lastName:"Devuser", password: pwd, username: "dev")
			if(!personAdmin.save(flush: true)){
				println "Error occured"
				personAdmin.errors.each{
					println it
				}
			}else{
				println "Success!"
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
			/*groupManagerService.generateRoles()
			groupManagerService.generateOfficeGroups(mainOffice)*/
			
			println ">> find a admin and dev roles"
			def adminRole = new Role(authority:"ROLE_ADMIN") /*Role.findByAuthority(SystemRoles.ROLE_ADMIN.value)*/	 
			if(!adminRole.save(flush:true)){
				println adminRole.errors
			}else{
				println "Admin Role saved"
			}
			def userRole = new Role(authority:"ROLE_USER").save(flush:true)
			def adminGroup = new RoleGroup(name:"GROUP_ADMIN").save(flush:true)
			def devRole = new Role(name: "GROUP_DEV").save(flush: true)
			if(!adminGroup.save(flush:true)){
				println adminGroup.errors
			}else{
				println "Success person group"
			}
			def userGroup = new RoleGroup(authority:"GROUP_USER").save(flush:true)
			def devGroup = new RoleGroup(authority: "GROUP_DEV").save(flush:true)
			/*def devGroup = new RoleGroup(name:"GROUP_DEVELOPER").save(flush:true)
			def userGroup = new RoleGroup(name:"GROUP_USER").save(flush:true)*/
			println ">> creating RoleGroupRoles..."
			RoleGroupRole.create adminGroup, adminRole
			RoleGroupRole.create userGroup, userRole 
			RoleGroupRole.create devGroup, devRole
			/*RoleGroupRole.create userGroup, userRole*/
			
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
				 '/index.gsp',
				 '/acl/**/**',
				 '/person/personlist/**',
				 '/case/jq_list_actions',
				 '/office/jq_list_cases',
				 '/office/jq_list_staff',
				 '/organisation/orglist/**',
				 '/labour/**',
				 '/eviction/**',
				 '/country/**',
				 '/region/**',
				 '/report/**',
				 '/category/**',
				 '/case/index/**',
				 '/**/show/**',
				  '/**/index/**',
				   '/Membership/*',
				   '/Membership/assets/*',
				   '/Membership/person/*',
				   '/person/*',
				   '/Membership/parent/*',
				   '/parent/*',
				   '/Membership/parent/edit/8',
				   '*/parent/*',
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
				 '/**/edit/**',]) {
				  new RequestMap( url: url, configAttribute:  SystemRoles.ROLE_ADMIN.value).save()
			 }
			  
			
			 //strictly admin
			 for (String url in [ '/requestmap/**',
				 '/admin/**',
				 '/**/delete/**',
				 '/office/delete/**',
				 '/role/**',
				 '/roleGroup/**',
				 '/user/**']) {
				 new RequestMap( url: url, configAttribute: SystemRoles.ROLE_ADMIN.value).save()
			}
	} //end method
}