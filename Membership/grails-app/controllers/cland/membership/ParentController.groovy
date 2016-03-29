package cland.membership



import static org.springframework.http.HttpStatus.*
import cland.membership.security.Person
import grails.transaction.Transactional
import groovy.json.JsonSlurper
import java.text.DateFormat

@Transactional(readOnly = true)
class ParentController {
	def springSecurityService
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
	def newclient(){
		JsonSlurper jsonSlurper = new JsonSlurper()
		println params
		Office office = Office.get(Office.list().first().id)
		Person personInstance = new Person(params.person)
		println personInstance
		personInstance.username = params.person["firstname"]
		personInstance.password = params.person["firstname"]
		personInstance.firstName = params.person["firstname"]
		personInstance.lastName = params.person["lastname"]
		personInstance.mobileNo = params.telNo
		personInstance.office = office
		if(!personInstance.save(flush: true)){
			println personInstance.errors
			return
		}else{
			println "person saved"
		}
		Parent parentInstance = new Parent(params)
		parentInstance.person1 = personInstance
		parentInstance.clientType = "Standard"
		parentInstance.membershipNo = Parent.last().membershipNo + 1
		if(!parentInstance.save(flush: true)){
			println parentInstance.errors
			return
		}else{
			println "Parent saved"
		}
		/*** TEMPORAL  ***/
		Person childPerson = new Person()
		String username = (params.child["person"].firstname).toList().first()
		println username
		String lastname = (params.child["person"].lastname).toList().first()
		Date dOb = Date.parse("dd-MMM-yyyy",((params.child["person"].dateOfBirth).toList().first()).toString())
		
		childPerson.username = username
		childPerson.password = username
		childPerson.firstName = username
		childPerson.lastName = lastname
		childPerson.dateOfBirth = dOb 
		childPerson.mobileNo = personInstance.mobileNo
		childPerson.office = office
		if(!childPerson.save(flush: true)){
			println childPerson.errors
			return
		}else{
			println "Child person saved"
		}
		Child childInstance = new Child()
		childInstance.parent = parentInstance
		childInstance.accessNumber = Child.last().accessNumber + 1
		childInstance.person = childPerson
		childInstance.lastUpdated = new Date()
		childInstance.dateCreated = new Date()
		if(!childInstance.save(flush: true)){
			println childInstance.errors
			return
		}else{
			println "Child saved"
		}
		println "Success"
		return "Successfully created person child parent and office"
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
}
