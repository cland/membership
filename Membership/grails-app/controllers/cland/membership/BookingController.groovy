package cland.membership

import static org.springframework.http.HttpStatus.*
import cland.membership.security.*
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
		println params
		def result = []
		try{
			def dfmt = new SimpleDateFormat("dd-MMM-yyyy")
			Office office = Office.list().first()
			def bookingInstance = new Booking()
			
			bookingInstance.bookingDate = dfmt.parse(params.booking.date) 
			bookingInstance.timeslot = Keywords.get(params?.booking.timeslot)
			bookingInstance.numKids = Integer.parseInt(params?.booking.totalkidcount)
			bookingInstance.numAdults = Integer.parseInt(params?.booking.totaladultcount)
			bookingInstance.comments = params?.booking.comments
			bookingInstance.bookingType = Keywords.get(params?.booking.bookingtype)
			bookingInstance.room = Keywords.get(params?.booking.room)
			bookingInstance.partyPackage = Keywords.get(params?.booking.partyPackage)
			bookingInstance.partyTheme = Keywords.get(params?.booking.partyTheme)
			
			
			// contact/parent
			Parent parentInstance = new Parent(params.parent)
			parentInstance.clientType = Keywords.findByName("Standard")
			def num = cbcApiService.generateIdNumber(new Date(),5)
			parentInstance.membershipNo = num
			
			Person person1 = new Person(params.parent.person1)
			person1.office = office
			person1.username = person1?.firstName?.toLowerCase() + "." + person1?.lastName?.toLowerCase()
			person1.password = person1.username
			person1.enabled = false
			
			if(!person1.save(flush: true)){
				println person1.errors
				result = [result:"failure",message:"Failed to contact details"]
				render result as JSON
				return
			}
			parentInstance.person1 = person1
			
			//save the birthday child
			def child = new Child()
			def p = new Person()
			p.firstName = params.child.person.lastname
			p.lastName = params.child.person.lastname
			p.dateOfBirth = new Date(params.child.person.dateOfBirth)
			p.gender = params.child.person.gender
			p.office = office
			p.username = p.firstName.toLowerCase() + "." + p.lastName.toLowerCase()
			p.password = p.username
			p.enabled = false
			p.mobileNo = "-1"
			if(!p.save(flush: true)){
				println p.errors
				result = [result:"failure",message:"Failed to save child details"]
				render result as JSON
				return
			}
			child.person = p
			if(parentInstance.children){
				child.accessNumber = parentInstance.children.size() + 1
			}else{
				child.accessNumber = 1
			}
			parentInstance.addToChildren(child)
			
			if(!parentInstance.save(flush: true)){
				println parentInstance.errors
				result = [result:"failure",message:"failed to save parent details."]
				render result as JSON
				return
			}
			
			println "Success"
			
			bookingInstance.parent = parentInstance
			bookingInstance.birthdayChild = child					
			
			//childlead
			params.childlead.firstname.eachWithIndex { value, index ->
				def childlead = new ChildLead()
				childlead.firstName = value 
				childlead.lastName = params.childlead.lastname[index]
				childlead.mobileNo = params.childlead.mobileno[index]
				
				bookingInstance.addToChildren(childlead)				
			}
			
			//save the booking
			if(!bookingInstance.save(flush:true)){
				println bookingInstance.errors
				result = [result:"failure",message:"Failed to save BOOKING details. "]
				render result as JSON
				return
			}
			
			result = [result:"success"]
			result.putAll(bookingInstance.toMap())
			render result as JSON
		}catch(Exception e){
			println(e.printStackTrace())
			result = [result:"failure",message:"Error saving booking. [" + e.getMessage() + "]"]
			render result as JSON
			return
		}
		
		
	} //end function newbooking
} //end class
