import cland.membership.*
import cland.membership.security.*
import cland.membership.lookup.*
import grails.util.*

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.authority.AuthorityUtils
import org.springframework.security.core.context.SecurityContextHolder as SCH
class BootStrap {

    def init = { servletContext ->
		println "Bootstrap > environment: " + Environment.getCurrent()
		def appName = grails.util.Metadata.current.'app.name'
		println (">> Bootstrapping: ${appName} on OS >> " + System.properties["os.name"] )
		boolean doBootStrap = false
		def userlist = Person.list()
		if(userlist?.size() < 1){
			println("BootStrap >> ON!")
			doBootStrap = true
		}else{
		println("BootStrap >> off!")
		}
		if(doBootStrap){
			switch(Environment.getCurrent()){
				case "DEVELOPMENT":
				
					println ("1. Create users ...")
					createUsers("admin123")			
					println ("3. Initialize Request map ...")
					initRequestmap()
					println ("4. Add other components of the app ...")					
					createOtherComponents()
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
					println ("4. Add other components of the app ...")
					
					createOtherComponents()
				break
			} //end switch
		} //end doBootStrap
				
    } //end init
    def destroy = {
    }
	
	// *** HELPER FUNCTIONS ***
	
	/**
	 * Creates initial users
	 * @return
	 */
	private boolean createUsers(String pwd) {
		
		//Create office and person
		def personAdmin = new Person(username: "admin", enabled: true, password: pwd,firstName:"Sys",lastName:"Sysuser",idNumber :"1111111111",
			dateOfBirth:(new Date() - 365*30),
			gender:Gender.MALE.toString()).save(flush:true)
		def personDev = new Person(username: "dev", enabled: true, password: pwd,firstName:"Sys",lastName:"Devuser",idNumber :"10101010101",
			dateOfBirth:(new Date() - 365*30),
			gender:Gender.MALE.toString()).save(flush:true)
		
		
		try{
			//create ROLES		
			
			println ">> find a admin and dev roles"
			def adminRole = Role.findByAuthority(SystemRoles.ROLE_ADMIN.value)	// new Role(authority:"ROLE_ADMIN").save(flush:true)
			def devRole = Role.findByAuthority(SystemRoles.ROLE_DEVELOPER.value) //new Role(authority:"ROLE_USER").save(flush:true)
			
			
			//SYSTEM ADMIN group(s)
			def adminGroup = new RoleGroup(name:"GROUP_ADMIN",description:"Administrators").save(flush:true)
			def devGroup = new RoleGroup(name:"GROUP_DEVELOPER",description:"Developers").save(flush:true)
			println ">> creating RoleGroupRoles..."
			RoleGroupRole.create adminGroup, adminRole
			RoleGroupRole.create devGroup, devRole
			
					
			if(!personDev.hasErrors()){
				UserRoleGroup.create personDev, devGroup
				UserRoleGroup.create personDev, adminGroup, true
				//Add Admin user to list of roles
				//println ">> Adding admin to office groups"
				//groupManagerService.addUserToGroup(admin, mainOffice, [SystemRoles.ROLE_OCO,SystemRoles.ROLE_CWO])
			}else{
				println(personDev.errors)
			}
			if(!personAdmin.hasErrors()){
				UserRoleGroup.create admin, adminGroup, true
				//Add Admin user to list of roles
				//println ">> Adding admin to office groups"
				//groupManagerService.addUserToGroup(admin, mainOffice, [SystemRoles.ROLE_OCO,SystemRoles.ROLE_CWO])
			}else{
				println(personAdmin.errors)
			}
		}catch(Exception e){
			println "Error " + e
			return false
		}
		
		return true
	} //end create users
	
	private void loginAsAdmin(String pwd) {
		// have to be authenticated as an admin to create ACLs
		SCH.context.authentication = new UsernamePasswordAuthenticationToken( 'admin', pwd, AuthorityUtils.createAuthorityList(SystemRoles.ROLE_ADMIN.value))
	}
	
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
			 '/logout/*']) {
			 new RequestMap( url: url, configAttribute: 'permitAll').save()
		}
			 // show and lists/index
			 for (String url in ['/',
				 '/index',
				 '/index.gsp',
				 '/acl/**/**',
				 '/**/show/**',
				  '/**/index/**']) {
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
				  new RequestMap( url: url, configAttribute:  SystemRoles.ROLE_ADMIN.value + ',' + SystemRoles.ROLE_DEV.value).save()
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
	private void createOtherComponents(){
		new Race(name:"Asian").save()
		new Race(name:"Black").save()
		new Race(name:"Caucasian").save()
		new Race(name:"Coloured").save()
		new Race(name:"Indian").save()
		new Race(name:"Other").save()
		
		//keywords for location
		def keyword = new Keywords(name:"system_areas",label:"System Areas",category:"system_locations")
		keyword.addToValues(new Keywords(name:"one",label:"This One",category:"System")	)
		keyword.save()
		if(keyword.hasErrors()){
		println keyword.errors
		}
	}
} //end class
