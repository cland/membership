package cland.membership



import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import cland.membership.security.*

@Transactional(readOnly = true)
class SettingsController {
	def groupManagerService
    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)		
        respond Settings.list(params), model:[settingsInstanceCount: Settings.count()]
    }

    def show(Settings settingsInstance) {
        respond settingsInstance
    }

    def create() {
		def staff = Person.list(params)
        respond new Settings(params), model:[personInstanceList:staff]
    }

    @Transactional
    def save(Settings settingsInstance) {
        if (settingsInstance == null) {
            notFound()
            return
        }

        if (settingsInstance.hasErrors()) {
            respond settingsInstance.errors, view:'create'
            return
        }

        settingsInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'settings.label', default: 'Settings'), settingsInstance.id])
                redirect settingsInstance
            }
            '*' { respond edit(settingsInstance), [status: CREATED] }
        }
    }

    def edit(Settings settingsInstance) {
		def office = Office.get(1)
		def staff = null
		if(groupManagerService.isDeveloper()){
			staff = office?.staff?.findAll{groupManagerService.isStaff(office,it) == true }
		}else{
			staff = office?.staff?.findAll{
				groupManagerService.isStaff(office,it) == true &
				!groupManagerService.isOfficeDeveloper(office, it) &
				!groupManagerService.isOfficeAdmin(office, it)}
		}
		
		def templates = Template.list(params)
        respond settingsInstance, model:[personInstanceList:staff,templateInstanceList:templates]
    }

    @Transactional
    def update(Settings settingsInstance) {
        if (settingsInstance == null) {
            notFound()
            return
        }

        if (settingsInstance.hasErrors()) {
            respond settingsInstance.errors, view:'edit'
            return
        }

        settingsInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'Settings.label', default: 'Settings'), settingsInstance.id])
                redirect (uri:'/') //settingsInstance
            }
            '*'{ respond settingsInstance, [status: OK] }
        }
    }

    @Transactional
    def delete(Settings settingsInstance) {

        if (settingsInstance == null) {
            notFound()
            return
        }

        settingsInstance.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'Settings.label', default: 'Settings'), settingsInstance.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'settings.label', default: 'Settings'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
