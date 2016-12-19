package cland.membership

import static org.springframework.http.HttpStatus.*
import cland.membership.security.Person
import grails.converters.JSON
import grails.transaction.Transactional
import java.text.SimpleDateFormat
import org.joda.time.DateTime

@Transactional(readOnly = true)
class ChildController {
	def springSecurityService
	def cbcApiService
	def groupManagerService
    static allowedMethods = [save: "POST", update: "POST", delete: "DELETE"]

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
		Parent parent
		if (childInstance == null) {
			notFound()
			return
		}
		try{
		    parent = Parent.get((params.child.id).toLong())
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

		flash.message = message(code: 'default.created.message', args: [message(code: 'child.label', default: 'Child'), childInstance.toString()])
		//redirect(action: "show", id:childInstance?.id)
		render(view:"/child/show/" + childInstance?.id)
        /*
		request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'child.label', default: 'Child'), childInstance.id])
                redirect childInstance
            }
            '*' { respond childInstance, [status: CREATED] }
        } */
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
		//bindData(childInstance?.person, params, [exclude: 'dateOfBirth'])
		//bindData(childInstance?.person, ['dateOfBirth': params.date('dateOfBirth', ['dd-MMM-yyyy'])], [include: 'dateOfBirth'])
		try{
			Person p = Person.get(params?.person?.id)
			def _personid = p?.id
			p.properties = params?.person
			bindData(p, params, [exclude: 'dateOfBirth'])
			bindData(p, ['dateOfBirth': params.person?.date('dateOfBirth', ['dd-MMM-yyyy'])], [include: 'dateOfBirth'])
			p.id = _personid
			if(!p.save(flush:true)){
				println(p.errors)
			}
			childInstance.person = p
		}catch(Exception e){
			e.printStackTrace()
		}
		
        if(!childInstance.save(flush:true)){			
			println(childInstance?.errors)
			respond childInstance.errors, view:'edit'
			return
		}else{

			attachUploadedFilesTo(childInstance?.person,["profilephoto" + childInstance?.person?.id])
													
	        request.withFormat {
	            form multipartForm {
	                flash.message = message(code: 'default.updated.message', args: [message(code: 'Child.label', default: 'Child'), childInstance?.toString()])
	                // redirect childInstance
					redirect (url:cbcApiService.getBasePath(request) + "child/show/" + childInstance?.id, permanent:true)
	            }
	            '*'{ respond childInstance, [status: OK] }
	        }
        
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
                //redirect action:"index", method:"GET"
				redirect (url:cbcApiService.getBasePath(request) + "parent/index", permanent:true)
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'child.label', default: 'Child'), params.id])
                //redirect action: "index", method: "GET"
				redirect (url:cbcApiService.getBasePath(request) + "parent/index", permanent:true)
            }
            '*'{ render status: NOT_FOUND }
        }
    }
	
	/** CUSTOM FUNCTIONS **/
	def visits(params){
		def office = cbcApiService.getOfficeContext()
		def activeVisits = null
		if(groupManagerService.isAdmin()){
			activeVisits = Visit.findAllByStatus("Active")
		}else{
			activeVisits = Visit.findAllByStatusAndOffice("Active",office) //Visit.findAllByStatus("Active")
		}
		render activeVisits*.toMap() as JSON
	}
	def birthdaylist(params){
		//get all the kids whose is birthday is on the way
		def startdate = params?.startDate
		def enddate = params?.endDate
		
		if(startdate != null & startdate != "") {
			startdate = parseDate(startdate,"dd-MMM-yyyy")
		} else {		
			startdate = new DateTime().toDate()
		}
		if(enddate != null  & enddate != "") {
			enddate = parseDate(enddate,"dd-MMM-yyyy")
			if(startdate > enddate) enddate = startdate
			enddate = (new DateTime(enddate).plusDays(1)).toDate()
		} else {
			enddate = (new DateTime().plusMonths(1).toDate())
		}
		
		def startyear = new DateTime(startdate).getYear()
		def endyear = new DateTime(enddate).getYear()
		def startdayofyear = (new DateTime(startdate)).dayOfYear().get()
		def enddayofyear = (new DateTime(enddate)).dayOfYear().get()
		
		def blist = Child.createCriteria().list {
			createAlias("person","p")
			//between('p.birthmonth', startdate?.getCalendarDate().getMonth(), enddate?.getCalendarDate().getMonth())
			
			if(startyear == endyear){
				ge('p.birthdayofyear',startdayofyear)						
				le('p.birthdayofyear',enddayofyear) //if same year as start year
			}else if(startyear < endyear){
				or{
					//between('p.birthdayofyear',startdayofyear,new DateTime(parseDate("31-Dec-" + startyear.toString(),"dd-MMM-yyyy")).dayOfYear().get())
					ge('p.birthdayofyear',startdayofyear)
					//between('p.birthdayofyear',new DateTime(parseDate("01-Jan-" + endyear.toString(),"dd-MMM-yyyy")).dayOfYear().get(),enddayofyear)
					le('p.birthdayofyear',enddayofyear)
				}
			}	
			//order('p.birthyear','asc')	
			order('p.birthmonth','asc')
			order('p.birthday','asc')
		}
		render blist*.toMap() as JSON
	}
	private parseDate(date,fmt) {
		SimpleDateFormat df = new SimpleDateFormat(fmt);
		return (!date) ? new Date() : df.parse(date)
   }
} //end class
