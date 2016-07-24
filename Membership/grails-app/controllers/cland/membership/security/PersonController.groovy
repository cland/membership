package cland.membership.security



import static org.springframework.http.HttpStatus.*
import cland.membership.Office
import grails.converters.JSON
import grails.transaction.Transactional
import org.joda.time.DateTime
import org.joda.time.Days
import org.joda.time.Period

@Transactional(readOnly = true)
class PersonController {
	def autoCompleteService
	def cbcApiService
	def groupManagerService
    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 50, 100)
		if(!params?.sort) params.sort = "username"
		//params.order = "asc"
		Office office = Office.list().first()
		def personList = null
		
		if(groupManagerService.isAdmin()){
			personList = Person.list(params)
		}else{
			personList = Person.createCriteria().list(params) {
				and{
					not{'in'("lastName",["Administrator","Devuser"])}
					not{'in'("username",["dev","admin"])}
				}		
			}
		}
		println(personList?.size())
        respond personList, model:[personInstanceCount: Person.count()]
    }

    def show(Person personInstance) {
        respond personInstance
    }

    def create() {
        respond new Person(params)
    }

    @Transactional
    def save(Person personInstance) {
        if (personInstance == null) {
            notFound()
            return
        }
		bindData(personInstance, params, [exclude: 'dateOfBirth'])
		bindData(personInstance, ['dateOfBirth': params.date('dateOfBirth', ['dd-MMM-yyyy'])], [include: 'dateOfBirth'])
		
        if (personInstance.hasErrors()) {
            respond personInstance.errors, view:'create'
            return
        }

        if(!personInstance.save(flush:true)){
			println personInstance.errors
		}else{
			//Add user to access groups
			def officegroups = (params.list("officegroups")*.toLong())
			groupManagerService.addUserToGroup(personInstance,officegroups)
		}

		
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'person.label', default: 'Person'), personInstance.id])
                //redirect personInstance
				redirect (url:cbcApiService.getBasePath(request) + "person/show/" + personInstance?.id, permanent:true)
            }
            '*' { respond personInstance, [status: CREATED] }
        } 
    }

    def edit(Person personInstance) {
        respond personInstance
    }

    @Transactional
    def update(Person personInstance) {
        if (personInstance == null) {
            notFound()
            return
        }
		
		bindData(personInstance, params, [exclude: 'dateOfBirth'])
		bindData(personInstance, ['dateOfBirth': params.date('dateOfBirth', ['dd-MMM-yyyy'])], [include: 'dateOfBirth'])
		
        if (personInstance.hasErrors()) {
            respond personInstance.errors, view:'edit'
            return
        }

        personInstance.save flush:true
		//Add user to access groups - we clear all his groups first in this instance
		PersonRoleGroup.removeAll(personInstance, true)
		def officegroups = (params.list("officegroups")*.toLong())
		groupManagerService.addUserToGroup(personInstance,officegroups)
		
     
		request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'Person.label', default: 'Person'), personInstance.id])
                //redirect personInstance
				redirect (url:cbcApiService.getBasePath(request) + "person/show/" + personInstance?.id, permanent:true)
            }
            '*'{ respond personInstance, [status: OK] }
        } 
    }

    @Transactional
    def delete(Person personInstance) {

        if (personInstance == null) {
            notFound()
            return
        }

        personInstance.delete flush:true

		flash.message = message(code: 'default.deleted.message', args: [message(code: 'Person.label', default: 'Person'), personInstance.id])
		redirect(controller: "home",action: "index")
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'Person.label', default: 'Person'), personInstance.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'person.label', default: 'Person'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    } //end not Found()
	
	/**
	 * Custom functions added:
	 */
	def personlist = {
		render autoCompleteService.searchPeople(params) as JSON
	}
	
	def visits = {
		//TODO: created JSON test data of visits to display on the live panel.
		DateTime tmp = new DateTime(2016,3,13,0,5)
		def data = [name:"jason",startdate:tmp,period:2]
		render data as JSON
	}
	
} //end class
