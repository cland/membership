package cland.membership



import static org.springframework.http.HttpStatus.*
import cland.membership.security.Person
import grails.transaction.Transactional

@Transactional(readOnly = true)
class ParentController {
	def springSecurityService

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
		parentInstance.date = new Date()
		
		Office office = new Office()
		
		//TODO: add the items below as template
		office.name = params.name
		office.code = params.code
		office.status = params.status 
		
		if (office.hasErrors()) {
			println office.errors
			respond office.errors, view:'create'
			return
		}
	//	person.office = office
		/*if (parentInstance.hasErrors()) {
			println parentInstance.errors
			respond parentInstance.errors, view:'create'
			return
		}*/
		
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
                redirect parentInstance
				
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
