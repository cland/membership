package cland.membership

import static org.springframework.http.HttpStatus.*
import cland.membership.security.Person
import cland.membership.lookup.*
import grails.converters.JSON
import grails.transaction.Transactional
import groovy.json.JsonSlurper

import java.text.DateFormat
import java.text.SimpleDateFormat

import org.joda.time.DateTime
import org.joda.time.format.DateTimeFormat

import com.macrobit.grails.plugins.attachmentable.domains.Attachment;

@Transactional(readOnly = true)
class ParentController {
	def springSecurityService
	def groupManagerService
	def cbcApiService
	def emailService
	def nexmoService

    static allowedMethods = [save: "POST", update: "POST", delete: "DELETE",checkout:"POST",newclient:"POST",checkin:"POST"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond Parent.list(params), model:[parentInstanceCount: Parent.count()]
    }

    def show(Parent parentInstance) {
        respond parentInstance
    }

    def create() {
        respond new Parent(params)
    }

    @Transactional
    def save(Parent parentInstance) {
		
		def dfmt = new SimpleDateFormat("dd-MMM-yyyy HH:mm")
		Office office = Office.list().first()
		
        if (parentInstance == null) {
            notFound()
            return
        }
		parentInstance.clientType = Keywords.findByName("Standard")
		def num = cbcApiService.generateIdNumber(new Date(),5)
		parentInstance.membershipNo = num
		
		Person person1 = new Person(params?.person1) 
		person1.office = office
		person1.username = person1.firstName.toLowerCase() + "." + person1.lastName.toLowerCase()
		person1.password = person1.username
		person1.enabled = false
		if (person1.save(flush:true)) {
			println person1.errors			
		}
					
		parentInstance.person1 = person1
		
		//Emergency person
		Person person2 = new Person(params.person2)
		person2.office = office
		person2.username = person2.firstName.toLowerCase() + "." + person2.lastName.toLowerCase()
		person2.password = person2.username
		person2.enabled = false
		
		if(!person2.save(flush:true)){
			println person2.errors
		}else{
			parentInstance.person2 = person2
		}
		
		if(!parentInstance.save(flush:true)){
			println parentInstance.errors
		}
		flash.message = message(code: 'default.created.message', args: [message(code: 'parent.label', default: 'Parent'), parentInstance.id])
		redirect(action: "show", id:parentInstance?.id, permanent:true)
		
       // request.withFormat {
       //     form multipartForm {
       //         flash.message = message(code: 'default.created.message', args: [message(code: 'parent.label', default: 'Parent'), parentInstance.id])
       //         redirect parentInstance
       //    }
       //     '*' { respond parentInstance, [status: CREATED] }
       // }
    }

    def edit(Parent parentInstance) {
        respond parentInstance
    }

    @Transactional
    def update(Parent parentInstance) {
        if (parentInstance == null) {
            notFound()
            return
        }

        if (parentInstance.hasErrors()) {
            respond parentInstance.errors, view:'edit'
            return
        }
		def dfmt = new SimpleDateFormat("dd-MMM-yyyy HH:mm")
		Office office = Office.list().first()
		
		//need to add the children 
		def newvisits = [:]
		// save the children
		def i = 1
		while(params.get("child.person.lastname" + i)){
			def child = new Child()
			def p = new Person()
			p.firstName = params.get("child.person.firstname" + i)
			p.lastName = params.get("child.person.lastname" + i)
			if(p.firstName != "" & p.lastName != ""){
				p.dateOfBirth = new Date(params.get("child.person.dateOfBirth" + i))
				p.gender =  Keywords.get(params.get("child.person.gender" + i))
				p.office = office
				p.username = p.firstName.toLowerCase() + "." + p.lastName.toLowerCase()
				p.password = p.username
				p.enabled = false
				p.mobileNo = "-1"
				if(!p.save(flush:true)){
					println p.errors
					 respond parentInstance.errors, view:'edit'            
					return
				}
				child.person = p
				groupManagerService.addUserToGroup(p,office,"ROLE_USER")
				attachUploadedFilesTo(p,["profilephoto" + i])
				if(parentInstance.children){
					child.accessNumber = parentInstance.children.size() + 1
				}else{
					child.accessNumber = 1
				}
				// is checkin required now? IF NOT ARRAY NOT WORKING:
				println "Processing checkin...'" + params.get("child.checkin" + i) + "'"
				if( params.get("child.checkin" + i) == "Yes" ){
					//println ".. creating a visit now."
					//println "time: " + params.child.visit.time[index]
					//DateTime timein = DateTime.parse(params.child.visit.time[index], DateTimeFormat.forPattern("dd-MMM-yyyy HH:mm")) //.parseDateTime(params.child.visit.time[index])
					Date timein = dfmt.parse(params.get("child.visit.time"+ i))
					def _photokey = "visitphoto" + i
					def visit = new Visit(status:"Active",starttime:timein,timerCheckPoint:timein,photoKey:_photokey)
					child.addToVisits(visit)
					
					//attachUploadedFilesTo(visit,["visitphoto" + index])
					newvisits.put(p?.id , _photokey)
				}
								
				parentInstance.addToChildren(child)
			}// end first check for firstname and lastname
			
			i++
		}
        parentInstance.save flush:true
		newvisits.each {cid,key ->			
			def c = Child.findByPerson(Person?.get(cid))
			if(c != null){
				def v = c.visits.find{ it?.photoKey == key }
				if(v != null){
					attachUploadedFilesTo(v,[key])
				}
			}
		}
		
        request.withFormat {
            form multipartForm {
                flash.message = "Client '" + parentInstance + "' updated successfully! Membership number: '" + parentInstance?.membershipNo + "'"
                redirect(action: "show", id:parentInstance?.id, permanent:true) //redirect parentInstance, permanent:true
            }
            '*'{ respond parentInstance, [status: OK] }
        }
    }

    @Transactional
    def delete(Parent parentInstance) {

        if (parentInstance == null) {
            notFound()
            return
        }

        parentInstance.delete flush:true
		flash.message = "Client '" + parentInstance + "' updated successfully! Membership number: '" + parentInstance?.membershipNo + "'"
		redirect(action: "show", id:parentInstance?.id)
		/*
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'Parent.label', default: 'Parent'), parentInstance.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
        */
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'parent.label', default: 'Parent'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
	
	@Transactional
	def newclient(){
		def dfmt = new SimpleDateFormat("dd-MMM-yyyy HH:mm")
		Office office = Office.list().first()
		
		Parent parentInstance = new Parent(params.parent)
		parentInstance.clientType = Keywords.findByName("Standard")
		def num = cbcApiService.generateIdNumber(new Date(),5)
		parentInstance.membershipNo = num
		Person person1 = new Person(params.parent.person1)
		person1.office = office
		person1.username = person1.firstName.toLowerCase() + "." + person1.lastName.toLowerCase()
		person1.password = person1.username
		person1.enabled = false
		
		if(!person1.save(flush:true)){
			println person1.errors
			render person1.errors as JSON
			return
		}
		groupManagerService.addUserToGroup(person1,office,"ROLE_USER")
		parentInstance.person1 = person1
		
		//Emergency person
		Person person2 = new Person(params.parent.person2)
		person2.office = office
		person2.username = person2.firstName.toLowerCase() + "." + person2.lastName.toLowerCase()
		person2.password = person2.username
		person2.enabled = false
		
		if(!person2.save(flush:true)){
			println person2.errors			
		}else{
			parentInstance.person2 = person2
		}
		groupManagerService.addUserToGroup(person2,office,"ROLE_USER")
		def newvisits = [:]
		// save the children
		def i = 1
		while(params.get("child.person.lastname" + i)){
			def child = new Child()
			def p = new Person()
			p.firstName = params.get("child.person.firstname" + i)
			p.lastName = params.get("child.person.lastname" + i)
			if(p.firstName != "" & p.lastName != ""){
				p.dateOfBirth = new Date(params.get("child.person.dateOfBirth" + i))
				p.gender =  Keywords.get(params.get("child.person.gender" + i))
				p.office = office
				p.username = p.firstName.toLowerCase() + "." + p.lastName.toLowerCase()
				p.password = p.username
				p.enabled = false
				p.mobileNo = "-1"
				if(!p.save(flush:true)){
					println p.errors
					request.withFormat {
						form multipartForm {
							flash.message = "Error!"
							redirect controller:"home", action: "index", method: "GET"
						}
						'*'{ render status: OK }
					}
					return
				}
				groupManagerService.addUserToGroup(p,office,"ROLE_USER")
				child.person = p
				attachUploadedFilesTo(p,["profilephoto" + i])
				if(parentInstance.children){
					child.accessNumber = parentInstance.children.size() + 1
				}else{
					child.accessNumber = 1
				}
				// is checkin required now? IF NOT ARRAY NOT WORKING:
				println "Processing checkin...'" + params.get("child.checkin" + i) + "'"
				if( params.get("child.checkin" + i) == "Yes" ){
					//println ".. creating a visit now."
					//println "time: " + params.child.visit.time[index]
					//DateTime timein = DateTime.parse(params.child.visit.time[index], DateTimeFormat.forPattern("dd-MMM-yyyy HH:mm")) //.parseDateTime(params.child.visit.time[index])
					Date timein = dfmt.parse(params.get("child.visit.time"+ i))
					def _photokey = "visitphoto" + i
					def visit = new Visit(status:"Active",starttime:timein,timerCheckPoint:timein,photoKey:_photokey)
					child.addToVisits(visit)
					
					//attachUploadedFilesTo(visit,["visitphoto" + index])
					newvisits.put(p?.id , _photokey)
				}
								
				parentInstance.addToChildren(child)
			}// end first check for firstname and lastname
			
			i++
		}
		
		if(!parentInstance.save(flush: true)){
			println parentInstance.errors
			request.withFormat {
		            form multipartForm {
		                flash.message = "Error!"
		                redirect controller:"home", action: "index", method: "GET", permanent:true
		            }
		            '*'{ render status: OK }
		        }
			return
		}
		
		//attachUploadedFilesTo(parentInstance,["profilephoto1","profilephoto2"])
		newvisits.each {cid,key ->
			def c = Child.findByPerson(Person?.get(cid))
			if(c != null){
				def v = c.visits.find{ it?.photoKey == key }
				if(v != null){
					attachUploadedFilesTo(v,[key])
				}
			}
		}	
		
		request.withFormat {
		            form multipartForm {
		                flash.message = "Client '" + parentInstance + "' create successfully! Membership number: '" + parentInstance?.membershipNo + "'"
		                redirect controller:"home", action: "index", method: "GET", permanent:true
		            }
		            '*'{ render status: OK }
		        }
	}
	def search(){		
		//def test = Child.get(1)
		//def cnt = test.visits.findAll {it.status == "Active"}
		//println("Active test cnt: " + cnt?.size())
		
		def term = "%" + params?.term + "%"
		def results = Parent.createCriteria().list(params) {
			or{
				person1 {
					or{
						ilike('lastName',term)
						ilike('mobileNo',term)
						ilike('email',term)
					}					
				}
				ilike('membershipNo',term)
				
			}
		}
		def selectList = []
		if(results.size()>0){
			results.each {
				selectList.add(it.toAutoCompleteMap())
			}
		}else{
			selectList = [id:-1,label:"No results found!",value:"",	childlist:null,category:"No Result"]
		}

		render selectList as JSON
	} //end search
	@Transactional
	def checkout(params){
		def result = []
		Map<String, String[]> vars = request.getParameterMap()
		def _id = vars.id[0]
		def _endtime = vars.endtime[0]
		def _status = vars.status[0]
		def visit = Visit.get(_id)
		if (visit != null){
			def dfmt = new SimpleDateFormat("dd-MMM-yyyy HH:mm")			
			def dateout = dfmt.parse(_endtime) 			
			visit.endtime = dateout //timeout.toLocalDateTime();
			visit.status = _status
			if(visit.save(flush:true)){
				result = [result:"success"]
				result.putAll(visit?.toMap())				
			}else{
				result.push([result:"failed", message:"Could not find visit with id '" + _id + "'"])
			}
		}else{
			
		}
		
		render result as JSON
	} //end method checkout
	boolean isCollectionOrArray(object) {
		[Collection, Object[]].any { it.isAssignableFrom(object.getClass()) }
	}
	@Transactional
	def checkin(params){
		def result = []
		def msg = ""		
	
		def _contactno = params?.get("contactno")
		def _starttime = params?.get("child.searchvisit.time")
		def _children = params?.list("search_children")
		
		_children.each{
			def childInstance = Child.get(Long.parseLong(it))
			if(childInstance){
				println(childInstance)
				Date timein = new SimpleDateFormat("dd-MMM-yyyy HH:mm").parse(_starttime)
				def visit = new Visit(status:"Active",starttime:timein,timerCheckPoint:timein,contactNo:_contactno)
				childInstance.addToVisits(visit)
				if(!childInstance.save(flush:true)){
					println(childInstance.errors)
					msg = msg + "Child '" + value + "' failed to save! "
				}
				attachUploadedFilesTo(visit,["visitphoto" + childInstance?.id])
			}
		}//end looping through all the children id list
				

		result = [result:"success",message:msg]
		render result as JSON
	} //end function checkin
	
	@Transactional
	def newclientajax(){
		println ("======================================")
		println("PARAMS")
		println(params)
		
		println("REQUEST MAP")
		Map<String, String[]> vars = request.getParameterMap()
		println(vars)
		println ("======================================")
		def dfmt = new SimpleDateFormat("dd-MMM-yyyy HH:mm")
		Office office = Office.list().first()
		
		Parent parentInstance = new Parent(params.parent)
		parentInstance.clientType = Keywords.findByName("Standard")
		def num = cbcApiService.generateIdNumber(new Date(),5)
		parentInstance.membershipNo = num
		Person person1 = new Person(params.parent.person1)
		person1.office = office
		person1.username = person1.firstName.toLowerCase() + "." + person1.lastName.toLowerCase()
		person1.password = person1.username
		person1.enabled = false
		
		if(!person1.save(flush:true)){
			println person1.errors
			render person1.errors as JSON
			return
		}
		parentInstance.person1 = person1
		
		//Emergency person
		Person person2 = new Person(params.parent.person2)
		person2.office = office
		person2.username = person2.firstName.toLowerCase() + "." + person2.lastName.toLowerCase()
		person2.password = person2.username
		person2.enabled = false
		
		if(!person2.save(flush:true)){
			println person2.errors
		}else{
			parentInstance.person2 = person2
		}
		
		// save the children
		params.child.person.firstname.eachWithIndex { value, index ->
			def child = new Child()
			def p = new Person()
			p.firstName = value
			p.lastName = params.child.person.lastname[index]
			p.dateOfBirth = new Date(params.child.person.dateOfBirth[index])
			p.gender = Keywords.get(params.child.person.gender[index])
			p.office = office
			p.username = p.firstName.toLowerCase() + "." + p.lastName.toLowerCase()
			p.password = p.username
			p.enabled = false
			p.mobileNo = "-1"
			if(!p.save(flush:true)){
				println p.errors
				render p.errors as JSON
				return
			}
			child.person = p
			if(parentInstance.children){
				child.accessNumber = parentInstance.children.size() + 1
			}else{
				child.accessNumber = 1
			}
			//is checkin required now?
			println "Processing checkin..."
			if( params.child.checkin[index] == "Yes" ){
				//println ".. creating a visit now."
				//println "time: " + params.child.visit.time[index]
				//DateTime timein = DateTime.parse(params.child.visit.time[index], DateTimeFormat.forPattern("dd-MMM-yyyy HH:mm")) //.parseDateTime(params.child.visit.time[index])
				Date timein = dfmt.parse(params.child.visit.time[index])
				def visit = new Visit(status:"Active",starttime:timein,timerCheckPoint:timein)
				attachUploadedFilesTo(visit,["visitphoto" + index])
			
				child.addToVisits(visit)
			}
			
			attachUploadedFilesTo(child,["profilephoto" + index])  //TODO: Add attachment to child
			parentInstance.addToChildren(child)
		}
		if(!parentInstance.save(flush: true)){
			println parentInstance.errors
			render parentInstance.errors as JSON
			return
		}
		
		render parentInstance.toMap() as JSON
	}
} //end class
