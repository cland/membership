package cland.membership



import static org.springframework.http.HttpStatus.*
import grails.converters.JSON
import grails.transaction.Transactional
import java.text.SimpleDateFormat
import org.joda.time.DateTime

@Transactional(readOnly = true)
class VisitController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 50, 100)
		if(!params?.sort) params.sort = "starttime"
        respond Visit.list(params), model:[visitInstanceCount: Visit.count()]
    }
	def dailyreport(Integer max) {
	
	}
	
	def dailyreportdata(params){
		Settings settings = Settings.list().first()
		def _status = (params?.status ? params?.status : "Complete")
		def startdate = params?.startDate_open
		def enddate = params?.endDate_open
		
		if(startdate != null & startdate != "") startdate = parseDate(startdate,"dd-MMM-yyyy") else startdate = new DateTime().minusMonths(settings?.reportminmonth).toDate()
		if(enddate != null  & enddate != "") enddate = parseDate(enddate,"dd-MMM-yyyy") else enddate = (new Date())
		
		def visits = Visit.createCriteria().list(params){
			eq("status",_status)
			if(startdate != null & enddate != null){
				between('starttime', startdate, enddate)
			}
			order('starttime','desc')
		}
		
		render visits*.reportMap() as JSON
	}
    def show(Visit visitInstance) {
        respond visitInstance
    }

    def create() {
        respond new Visit(params)
    }

    @Transactional
    def save(Visit visitInstance) {
        if (visitInstance == null) {
            notFound()
            return
        }

        if (visitInstance.hasErrors()) {
            respond visitInstance.errors, view:'create'
            return
        }

        visitInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'visit.label', default: 'Visit'), visitInstance.id])
                redirect visitInstance
            }
            '*' { respond visitInstance, [status: CREATED] }
        }
    }

    def edit(Visit visitInstance) {
        respond visitInstance
    }

    @Transactional
    def update(Visit visitInstance) {
        if (visitInstance == null) {
            notFound()
            return
        }

        if (visitInstance.hasErrors()) {
            respond visitInstance.errors, view:'edit'
            return
        }

        visitInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'Visit.label', default: 'Visit'), visitInstance.id])
                redirect visitInstance
            }
            '*'{ respond visitInstance, [status: OK] }
        }
    }

    @Transactional
    def delete(Visit visitInstance) {

        if (visitInstance == null) {
            notFound()
            return
        }

        visitInstance.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'Visit.label', default: 'Visit'), visitInstance.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'visit.label', default: 'Visit'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
	private parseDate(date,fmt) {
		SimpleDateFormat df = new SimpleDateFormat(fmt);
		return (!date) ? new Date() : df.parse(date)
   }
}
