package cland.membership



import static org.springframework.http.HttpStatus.*
import grails.converters.JSON
import grails.transaction.Transactional

@Transactional(readOnly = true)
class TemplateController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE", newtemplate:"POST"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond Template.list(params), model:[templateInstanceCount: Template.count()]
    }

    def show(Template templateInstance) {
        respond templateInstance
    }

    def create() {
        respond new Template(params)
    }

    @Transactional
    def save(Template templateInstance) {
        if (templateInstance == null) {
            notFound()
            return
        }

        if (templateInstance.hasErrors()) {
            respond templateInstance.errors, view:'create'
            return
        }

        templateInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'template.label', default: 'Template'), templateInstance.id])
                redirect templateInstance
            }
            '*' { respond templateInstance, [status: CREATED] }
        }
    }

    def edit(Template templateInstance) {
        respond templateInstance
    }

    @Transactional
    def update(Template templateInstance) {
        if (templateInstance == null) {
            notFound()
            return
        }

        if (templateInstance.hasErrors()) {
            respond templateInstance.errors, view:'edit'
            return
        }

        templateInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'Template.label', default: 'Template'), templateInstance.id])
                redirect templateInstance
            }
            '*'{ respond templateInstance, [status: OK] }
        }
    }

    @Transactional
    def delete(Template templateInstance) {

        if (templateInstance == null) {
            notFound()
            return
        }

        templateInstance.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'Template.label', default: 'Template'), templateInstance.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'template.label', default: 'Template'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    } //
	
	@Transactional
	def newtemplate(){
		def result = []
		Map<String, String[]> vars = request.getParameterMap()
		def _status = vars.status[0]
		def _title = vars.title[0]
		def _body = vars.body[0]

		def template = new Template(title:_title, body:_body,status:_status)
		if(!template.save(flush:true)){
			println(template.errors)
			result = [result:"failure",message:"Failed to save template!"]			
		}else{
			result = [result:"success",id:template?.id]
		}
		
		render result as JSON
	}
} //end class
