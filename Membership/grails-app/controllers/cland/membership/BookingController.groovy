package cland.membership

import static org.springframework.http.HttpStatus.*
import cland.membership.security.Person
import cland.membership.lookup.*
import grails.converters.JSON
import grails.transaction.Transactional
import java.text.SimpleDateFormat

@Transactional(readOnly = true)
class BookingController {
	def springSecurityService
	def cbcApiService
	def emailService
	def nexmoService
    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond Booking.list(params), model:[bookingInstanceCount: Booking.count()]
    }

    def show(Booking bookingInstance) {
        respond bookingInstance
    }

    def create() {
        respond new Booking(params)
    }

    @Transactional
    def save(Booking bookingInstance) {
        if (bookingInstance == null) {
            notFound()
            return
        }

        if (bookingInstance.hasErrors()) {
            respond bookingInstance.errors, view:'create'
            return
        }

        bookingInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'booking.label', default: 'Booking'), bookingInstance.id])
                redirect bookingInstance
            }
            '*' { respond bookingInstance, [status: CREATED] }
        }
    }

    def edit(Booking bookingInstance) {
        respond bookingInstance
    }

    @Transactional
    def update(Booking bookingInstance) {
        if (bookingInstance == null) {
            notFound()
            return
        }

        if (bookingInstance.hasErrors()) {
            respond bookingInstance.errors, view:'edit'
            return
        }

        bookingInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'Booking.label', default: 'Booking'), bookingInstance.id])
                redirect bookingInstance
            }
            '*'{ respond bookingInstance, [status: OK] }
        }
    }

    @Transactional
    def delete(Booking bookingInstance) {

        if (bookingInstance == null) {
            notFound()
            return
        }

        bookingInstance.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'Booking.label', default: 'Booking'), bookingInstance.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'booking.label', default: 'Booking'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    } //end notFound
	
	@Transactional
	def newbooking(){
		def dfmt = new SimpleDateFormat("dd-MMM-yyyy HH:mm")
		Office office = Office.list().first()
		def bookingInstance = new Booking()
		
		//contact/parent
		Parent parentInstance = new Parent(params.parent)
		parentInstance.clientType = Keywords.findByName("Standard")
		def num = cbcApiService.generateIdNumber(new Date(),5)
		parentInstance.membershipNo = num
		Person person1 = new Person(params.person)
		person1.office = office
		person1.username = person1.firstName.toLowerCase() + "." + person1.lastName.toLowerCase()
		person1.password = person1.username
		person1.enabled = false
		
		if(!person1.save(flush:true)){
			println person1.errors
			render person1.errors as JSON
			return
		}
		bookingInstance.person = person1
	}
} //end class
