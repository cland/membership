package cland.membership



import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import java.text.SimpleDateFormat
import org.joda.time.*

@Transactional(readOnly = true)
class VisitBookingController {
	def groupManagerService
	def cbcApiService
    static allowedMethods = [save: "POST", update: "POST", delete: "DELETE"]

    def index(Integer max) {
		
        params.max = Math.min(max ?: 20, 100)
		if(groupManagerService.isStaff(null,null)){
			respond VisitBooking.list(params), model:[visitBookingInstanceCount: VisitBooking.count()]
		}else{
			def client = Parent.findByPerson1(groupManagerService.getCurrentUser())
			def bookings = VisitBooking.createCriteria().list(params){
				parent{
					idEq(client?.id)
				}
			}
			respond bookings, model:[visitBookingInstanceCount:bookings.size()]
		}		       
    } //end index

    def show(VisitBooking visitBookingInstance) {
        respond visitBookingInstance
    }

    def create() {
		def currentUser = groupManagerService.getCurrentUser()
		def parent = Parent.findByPerson1(currentUser)
		print parent?.children?.size()
		params.parent = parent
        respond new VisitBooking(params)
    }

    @Transactional
    def save(VisitBooking visitBookingInstance) {
		
        if (visitBookingInstance == null) {
            notFound()
            return
        }
		bindData(visitBookingInstance, params, [exclude: 'bookingDate'])
		bindData(visitBookingInstance, ['bookingDate': params.date('bookingDate', ['dd-MMM-yyyy HH:mm'])], [include: 'bookingDate'])
        if (visitBookingInstance.hasErrors()) {
            respond visitBookingInstance.errors, view:'create'
            return
        }
		def dfmt = new SimpleDateFormat("dd-MMM-yyyy HH:mm")
		Date bookingdate = params.date("bookingDate",['dd-MMM-yyyy HH:mm'])
		DateTime selectedtime = new DateTime(bookingdate)
		DateTime timenow = new DateTime(new Date())
		timenow = timenow.plusHours(1)
		
		if(params?.children == null){
			visitBookingInstance.errors.rejectValue("Children", "cuserr1", "Select 1 or more children")			
		}
		
		if(selectedtime < timenow){
			visitBookingInstance.errors.rejectValue("bookingDate", "cuserr1", "Booking a visit for today should be at least 1 hour from now.")			
		}
		
		if(visitBookingInstance.hasErrors()){
			//visitBookingInstance.errors.reject("cuserr1", "Booking for a visit today should be at least 1 hour from now.")
			respond visitBookingInstance.errors, view:'create'
			return
		}
		
		visitBookingInstance.referenceNo = cbcApiService.generateRandomString(new Date(),"ddhhmmss",3)
        if(!visitBookingInstance.save (flush:true)){
			println(visitBookingInstance.errors)
			respond visitBookingInstance.errors, view:'create'
			return
		}

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'visitBooking.label', default: 'VisitBooking'), "Reference No.: " + visitBookingInstance.referenceNo])
                //redirect visitBookingInstance
				redirect (url:cbcApiService.getBasePath(request) + "visitBooking/show/" + visitBookingInstance?.id, permanent:true)
            }
            '*' { respond visitBookingInstance, [status: CREATED] }
        }
    }

    def edit(VisitBooking visitBookingInstance) {
				
		if(!groupManagerService.isAdmin() && groupManagerService.getCurrentUserId() != visitBookingInstance?.parent?.person1.id ){
			redirect (url:cbcApiService.getBasePath(request) + "visitBooking/", permanent:true)
		}
        respond visitBookingInstance
    }

    @Transactional
    def update(VisitBooking visitBookingInstance) {
		println("Updating.. ")
        if (visitBookingInstance == null) {
            notFound()
            return
        }
		bindData(visitBookingInstance, params, [exclude: 'bookingDate'])
		bindData(visitBookingInstance, ['bookingDate': params.date('bookingDate', ['dd-MMM-yyyy HH:mm'])], [include: 'bookingDate'])
		
        if (visitBookingInstance.hasErrors()) {
            respond visitBookingInstance.errors, view:'edit'
            return
        }
		println("Checking access rights.. ")
		if(!groupManagerService.isStaff(null,null) && groupManagerService.getCurrentUserId() != visitBookingInstance?.parent?.person1.id ){
			redirect (url:cbcApiService.getBasePath(request) + "visitBooking/", permanent:true)
		}
		println("saving updates.. ")
        if(!visitBookingInstance.save (flush:true)){
			println(visitBookingInstance.errors)
			respond visitBookingInstance.errors, view:'edit', id:visitBookingInstance.id
			return
		}

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'VisitBooking.label', default: 'Visit Booking Ref: ' + visitBookingInstance?.referenceNo), visitBookingInstance.id])
                //redirect visitBookingInstance
				redirect (url:cbcApiService.getBasePath(request) + "visitBooking/show/" + visitBookingInstance?.id, permanent:true)
            }
            '*'{ respond visitBookingInstance, [status: OK] }
        }
    }

    @Transactional
    def delete(VisitBooking visitBookingInstance) {

        if (visitBookingInstance == null) {
            notFound()
            return
        }
		if(!groupManagerService.isStaff(null,null) && groupManagerService.getCurrentUserId() != visitBookingInstance?.parent?.person1.id ){
			redirect (url:cbcApiService.getBasePath(request) + "visitBooking/", permanent:true)
		}
        visitBookingInstance.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'VisitBooking.label', default: 'VisitBooking'), visitBookingInstance.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'visitBooking.label', default: 'VisitBooking'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
