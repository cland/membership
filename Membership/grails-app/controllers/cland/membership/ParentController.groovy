package cland.membership

import static org.springframework.http.HttpStatus.*
import cland.membership.security.Person
import grails.converters.JSON
import grails.transaction.Transactional
import groovy.json.JsonSlurper
import java.text.DateFormat
import org.joda.time.DateTime
import org.joda.time.format.DateTimeFormat

@Transactional(readOnly = true)
class ParentController {
	def springSecurityService
	def cbcApiService
	def emailService
	def nexmoService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

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
	
		Office office = Office.list().first()
		
		Parent parentInstance = new Parent(params.parent)
		parentInstance.clientType = "Standard"
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
		
		println "Adding children..." + params.child
		params.child.person.firstname.eachWithIndex { value, index ->
			def child = new Child()
			def p = new Person()
			p.firstName = value
			p.lastName = params.child.person.lastname[index]
			p.dateOfBirth = new Date(params.child.person.dateOfBirth[index])
			p.gender = params.child.person.gender[index]
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
				println ".. creating a visit now."
				println "time: " + params.child.visit.time[index]
				DateTime timein = DateTime.parse(params.child.visit.time[index], DateTimeFormat.forPattern("dd-MMM-yyyy HH:mm")) //.parseDateTime(params.child.visit.time[index])
				def visit = new Visit(status:"Active",starttime:timein.toDate(),timerCheckPoint:timein.toDate())
			//	visit.save()
				child.addToVisits(visit)
			}
			//child.save()
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
}
