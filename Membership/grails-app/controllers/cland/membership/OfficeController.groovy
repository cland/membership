package cland.membership



import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Transactional(readOnly = true)
class OfficeController {
	def groupManagerService
    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond Office.list(params), model:[officeInstanceCount: Office.count()]
    }

    def show(Office officeInstance) {
        respond officeInstance
    }

    def create() {
        respond new Office(params)
    }

    @Transactional
    def save(Office officeInstance) {
        if (officeInstance == null) {
            notFound()
            return
        }

        if (officeInstance.hasErrors()) {
            respond officeInstance.errors, view:'create'
            return
        }

        officeInstance.save flush:true
		groupManagerService.generateOfficeGroups(officeInstance)
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'office.label', default: 'Office'), officeInstance.id])
                redirect officeInstance
            }
            '*' { respond officeInstance, [status: CREATED] }
        }
    }

    def edit(Office officeInstance) {
        respond officeInstance
    }

    @Transactional
    def update(Office officeInstance) {
        if (officeInstance == null) {
            notFound()
            return
        }

        if (officeInstance.hasErrors()) {
            respond officeInstance.errors, view:'edit'
            return
        }

        officeInstance.save flush:true
		if(officeInstance?.officeGroups?.isEmpty()){
			groupManagerService.generateOfficeGroups(officeInstance)
		}
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'Office.label', default: 'Office'), officeInstance.id])
                redirect officeInstance
            }
            '*'{ respond officeInstance, [status: OK] }
        }
    }

    @Transactional
    def delete(Office officeInstance) {

        if (officeInstance == null) {
            notFound()
            return
        }

        officeInstance.delete flush:true
		groupManagerService.removeOfficeGroups(officeInstance)
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'Office.label', default: 'Office'), officeInstance.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'office.label', default: 'Office'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
