package cland.membership



import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Transactional(readOnly = true)
class ChildController {

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
        if (childInstance == null) {
            notFound()
            return
        }

        if (childInstance.hasErrors()) {
            respond childInstance.errors, view:'create'
            return
        }

        childInstance.save flush:true

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
