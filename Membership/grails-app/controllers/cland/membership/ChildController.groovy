package cland.membership



import static org.springframework.http.HttpStatus.*
import cland.membership.security.Person
import grails.transaction.Transactional

@Transactional(readOnly = true)
class ChildController {
	def springSecurityService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond Child.list(params), model:[childInstanceCount: Child.count()]
    }

    def show(Child childInstance) {
        respond childInstance
    }

    def create() {
        respond new Child(params)
    }

    @Transactional
    def save(Child childInstance) {
		println "In the save controller"
		Parent parent
		println params
		println "This is the username: " +params.username
		if (childInstance == null) {
			notFound()
			return
		}
		try{
			println params.child.id
		    parent = Parent.get((params.child.id).toLong())
			println "This is the parent: " + parent
		}catch(e){
			println e.message
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
		
		Office office = new Office()
		
		//TODO: add the items below as template
		office.name = params.name
		office.code = params.code
		office.status = params.status
		
		if (office.hasErrors()) {
			println "Office has errors"
			respond office.errors, view:'create'
			return
		}
		
		if(office.save(flush:true)){
			println "Office saved"
			println office
		   }else{
		   	println "Error saving office"
			   render(contentType: "text/json"){
				   office.errors
			   }
		   }
		
		person.office = office
		println "office saved"
		
		if(person.save(flush:true)){
			println "Successfully saved person class"
			childInstance.person = person
			
		}else{
			println "Failed saving person class"
			render(contentType: "text/json"){
				person.errors
			}
		}
		println "Person Saved"
		childInstance.person = person
		if(parent){
			childInstance.parent = parent
		}
		if (childInstance == null) {
			println 'Child not  found'
			notFound()
			return
		}
		if(childInstance.save(flush:true)){
			println "Successfully saved child class"
			
		}else{
			println "Faile to save child class"
			println childInstance.errors
			render(contentType: "text/json"){
				childInstance.errors
			}
		}
		/*if (childInstance.hasErrors()) {
			println "person errors"
			println childInstance.errors
			//respond childInstance.errors, view:'create'
			return
		}*/

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'child.label', default: 'Child'), childInstance.id])
                redirect childInstance
            }
            '*' { respond childInstance, [status: CREATED] }
        }
    }

    def edit(Child childInstance) {
        respond childInstance
    }

    @Transactional
    def update(Child childInstance) {
        if (childInstance == null) {
            notFound()
            return
        }

        if (childInstance.hasErrors()) {
            respond childInstance.errors, view:'edit'
            return
        }

        childInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'Child.label', default: 'Child'), childInstance.id])
                redirect childInstance
            }
            '*'{ respond childInstance, [status: OK] }
        }
    }

    @Transactional
    def delete(Child childInstance) {

        if (childInstance == null) {
            notFound()
            return
        }

        childInstance.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'Child.label', default: 'Child'), childInstance.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'child.label', default: 'Child'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
