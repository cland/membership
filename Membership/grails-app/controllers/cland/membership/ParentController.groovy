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
	def cbcApiService
	def emailService
	def nexmoService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE",checkout:"POST",newclient:"POST",checkin:"POST"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond Parent.list(params), model:[parentInstanceCount: Parent.count()]
    }

    def show(Parent parentInstance) {
        respond parentInstance
    }

    def create() {
		println "These are the parameters: " + params
        respond new Parent(params)
    }

    @Transactional
    def save(Parent parentInstance) {
		def smsResult
		println "This is the username: " +params.username
        if (parentInstance == null) {
            notFound()
            return
        }
		Person person = new Person() 
		person.username = params.username
		person.password = params.password
		person.enabled = true
		person.firstName = params.firstName
		person.lastName = params.lastName
		person.knownAs = params.knownAs
		person.title = params.title
		person.email = params.email
		person.gender = params.gender
		person.idNumber = params.idNumber
		person.dateOfBirth = params.dateOfBirth
		person.createdBy = springSecurityService.currentUser.id
		
		Office office = Office.get(Office.list().first().id)
		
		//TODO: add the items below as template
		/*office.name = params.name
		office.code = params.code
		office.status = params.status */
		
		if (office.hasErrors()) {
			println office.errors
			respond office.errors, view:'create'
			return
		}
		
		if (person.hasErrors()) {
			println person.errors
			respond parentInstance.errors, view:'create'
			return
		}
		
		if(office.save(flush:true)){
			println person
		   }else{
		   	println office.errors
			   render(contentType: "text/json"){
				   office.errors
			   }
		   }
		
		person.office = office
		println person
		
		if(person.save(flush:true)){
			println "Person saved"
			parentInstance.person1 = person
			/*sendMail {
				to "ndabantethelelo@gmail.com"
				subject "Notification"
				body "Hello " + person.firstName +" this is to verify that your account has been created"
			  }*/
			/*try{
				smsResult = nexmoService.sendSms("0621347734", "Hello Bo, This is a notification of a new person in " +
					"Membership call Lungelo Ndaba when you get this sms", "0791623651")
			}catch(e){
				println e
				render(contentType: "text/json"){
					e
				}
			}*/
			
			
			//send query to fetch children
			
		}else{
			println person.errors
			render(contentType: "text/json"){
				person.errors
			}
		}
		
		println "This is the person: " + person
		
        parentInstance.save flush:true
		if(parentInstance.save(flush:true)){
			println "parent saved"
			parentInstance.person1 = person
			
			
		}else{
			println person.errors
			render(contentType: "text/json"){
				person.errors
			}
		}
		/*if (parentInstance.hasErrors()) {
			println parentInstance.errors
			println "This is the person: " + parentInstance.person1
			respond parentInstance.errors, view:'create'
			return
		}*/

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'parent.label', default: 'Parent'), parentInstance.id])
                //redirect parentInstance
				redirect(uri:'/')
            }
            '*' { respond parentInstance, [status: CREATED] }
        }
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

        parentInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'Parent.label', default: 'Parent'), parentInstance.id])
                redirect parentInstance
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

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'Parent.label', default: 'Parent'), parentInstance.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
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
		println(params)
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
		
		def newvisits = []
		// save the children
		def i = 1
		while(params.get("child.person.lastname" + i)){
			def child = new Child()
			def p = new Person()
			p.firstName = params.get("child.person.firstname" + i)
			p.lastName = params.get("child.person.lastname" + i)
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
				def visit = new Visit(status:"Active",starttime:timein,timerCheckPoint:timein,photoKey:"visitphoto" + i)
				child.addToVisits(visit)
				
				//attachUploadedFilesTo(visit,["visitphoto" + index])
				newvisits.add("visitphoto" + i)
			}
							
			parentInstance.addToChildren(child)
			i++
		}
		/**
		params.child.person.firstname.eachWithIndex { value, index ->
			if(value != "" & !value.isEmpty()){
				def child = new Child()
				def p = new Person()
				p.firstName = value
				p.lastName = params.get("child.person.lastname" + (index+1))
				p.dateOfBirth = new Date(params.get("child.person.dateOfBirth" + (index+1)))
				p.gender =  Keywords.get(params.get("child.person.gender" + (index+1)))
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
				child.person = p
				attachUploadedFilesTo(p,["profilephoto" + (index + 1)])
				if(parentInstance.children){
					child.accessNumber = parentInstance.children.size() + 1
				}else{
					child.accessNumber = 1
				}
				//TODO: is checkin required now? IF NOT ARRAY NOT WORKING: 
				println "Processing checkin...'" + params.get("child.checkin" + (index+1)) + "'"
				if( params.get("child.checkin" + (index+1)) == "Yes" ){
					//println ".. creating a visit now."
					//println "time: " + params.child.visit.time[index]
					//DateTime timein = DateTime.parse(params.child.visit.time[index], DateTimeFormat.forPattern("dd-MMM-yyyy HH:mm")) //.parseDateTime(params.child.visit.time[index])
					Date timein = dfmt.parse(params.get("child.visit.time"+ (index+1))) 
					def visit = new Visit(status:"Active",starttime:timein,timerCheckPoint:timein,photoKey:"visitphoto" + (index + 1))									
					child.addToVisits(visit)
					
					//attachUploadedFilesTo(visit,["visitphoto" + index])
					newvisits.add("visitphoto" + (index + 1))
				}
								
				parentInstance.addToChildren(child)			
			}
		}
		*/
		
		if(!parentInstance.save(flush: true)){
			println parentInstance.errors
			request.withFormat {
		            form multipartForm {
		                flash.message = "Error!"
		                redirect controller:"home", action: "index", method: "GET"
		            }
		            '*'{ render status: OK }
		        }
			return
		}
		
		//attachUploadedFilesTo(parentInstance,["profilephoto1","profilephoto2"])
		newvisits.each {
			println(". Visit file key: " + it)		
			def v = Visit.findByPhotoKey(it)
			if(v != null){
				attachUploadedFilesTo(v,[it.toString()])
			}
		}
		println "Success"
		request.withFormat {
		            form multipartForm {
		                flash.message = "Client create Successfully!"
		                redirect controller:"home", action: "index", method: "GET"
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
		Map<String, String[]> vars = request.getParameterMap()
		println(vars)
		println ("=======")
		println (params)
		/*
		def _starttime = vars?.starttime[0]
		def _children = vars?.values[0]?.split(",")
		def _contactno = vars?.contactno[0]
		_children.eachWithIndex { value, index ->
			def child = Child.get(value)
			if(child != null){
				Date timein = new SimpleDateFormat("dd-MMM-yyyy HH:mm").parse(_starttime)
				def visit = new Visit(status:"Active",starttime:timein,timerCheckPoint:timein,contactNo:_contactno)
				child.addToVisits(visit)
				if(!child.save(flush:true)){
					println(child.errors)
					msg = msg + "Child '" + value + "' failed to save! "
				}
			}
		}
		*/

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
			//	visit.save()
				child.addToVisits(visit)
			}
			//child.save()
			attachUploadedFilesTo(child,["profilephoto" + index])  //TODO: Add attachment to child
			parentInstance.addToChildren(child)
		}
		if(!parentInstance.save(flush: true)){
			println parentInstance.errors
			render parentInstance.errors as JSON
			return
		}
		println "Success"
		render parentInstance.toMap() as JSON
	}
} //end class
