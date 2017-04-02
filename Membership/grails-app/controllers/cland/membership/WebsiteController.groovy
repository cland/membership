package cland.membership



import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Transactional(readOnly = true)
class WebsiteController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond Website.list(params), model:[websiteInstanceCount: Website.count()]
    }

    def show(Website websiteInstance) {
        respond websiteInstance
    }

    def create() {
        respond new Website(params)
    }

    @Transactional
    def save(Website websiteInstance) {
        if (websiteInstance == null) {
            notFound()
            return
        }

        if (websiteInstance.hasErrors()) {
            respond websiteInstance.errors, view:'create'
            return
        }

        websiteInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'website.label', default: 'Website'), websiteInstance.id])
                redirect websiteInstance
            }
            '*' { respond websiteInstance, [status: CREATED] }
        }
    }

    def edit(Website websiteInstance) {
        respond websiteInstance
    }

    @Transactional
    def update(Website websiteInstance) {
        if (websiteInstance == null) {
            notFound()
            return
        }

        if (websiteInstance.hasErrors()) {
            respond websiteInstance.errors, view:'edit'
            return
        }

        websiteInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'Website.label', default: 'Website'), websiteInstance.id])
                redirect websiteInstance
            }
            '*'{ respond websiteInstance, [status: OK] }
        }
    }

    @Transactional
    def delete(Website websiteInstance) {

        if (websiteInstance == null) {
            notFound()
            return
        }

        websiteInstance.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'Website.label', default: 'Website'), websiteInstance.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'website.label', default: 'Website'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
