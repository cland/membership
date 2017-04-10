package cland.membership



import static org.springframework.http.HttpStatus.*
import grails.converters.JSON
import grails.transaction.Transactional

@Transactional(readOnly = true)
class PartnerContractController {
	def springSecurityService
	def groupManagerService
	def cbcApiService
    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE",confirmmembership:"POST"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond PartnerContract.list(params), model:[partnerContractInstanceCount: PartnerContract.count()]
    }

    def show(PartnerContract partnerContractInstance) {
        respond partnerContractInstance
    }

    def create() {
        respond new PartnerContract(params)
    }

    @Transactional
    def save(PartnerContract partnerContractInstance) {
        if (partnerContractInstance == null) {
            notFound()
            return
        }

        if (partnerContractInstance.hasErrors()) {
            respond partnerContractInstance.errors, view:'create'
            return
        }

        partnerContractInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'partnerContract.label', default: 'PartnerContract'), partnerContractInstance.id])
                //redirect partnerContractInstance
				redirect (url:cbcApiService.getBasePath(request) + "partnerContract/show/" + partnerContractInstance?.id, permanent:true)
            }
            '*' { respond partnerContractInstance, [status: CREATED] }
        }
    }

    def edit(PartnerContract partnerContractInstance) {
        respond partnerContractInstance
    }

    @Transactional
    def update(PartnerContract partnerContractInstance) {
        if (partnerContractInstance == null) {
            notFound()
            return
        }

        if (partnerContractInstance.hasErrors()) {
            respond partnerContractInstance.errors, view:'edit'
            return
        }

        partnerContractInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'PartnerContract.label', default: 'PartnerContract'), partnerContractInstance.id])
                //redirect partnerContractInstance
				redirect (url:cbcApiService.getBasePath(request) + "partnerContract/show/" + partnerContractInstance?.id, permanent:true)
            }
            '*'{ respond partnerContractInstance, [status: OK] }
        }
    }

    @Transactional
    def delete(PartnerContract partnerContractInstance) {

        if (partnerContractInstance == null) {
            notFound()
            return
        }

        partnerContractInstance.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'PartnerContract.label', default: 'PartnerContract'), partnerContractInstance.id])
                redirect action:"index", method:"GET"
				redirect (url:cbcApiService.getBasePath(request) + "partnerContract/", permanent:true)
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'partnerContract.label', default: 'PartnerContract'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
	
	@Transactional
	def confirmmembership(){
		def result = []
		def curuser = groupManagerService.getCurrentUser()
		try{
			
			Map<String, String[]> vars = request.getParameterMap()
			def _id = vars.contractid[0]
					
			def contractInstance = PartnerContract.get(_id)
			if(contractInstance){
				contractInstance.isValidPartnerMember = true
				contractInstance.history = contractInstance.history + " >> Updated " + new Date().format("dd-MMM-yyyy HH:mm") + " by " + curuser
				if(!contractInstance.save(flush:true)){
					println(contractInstance.errors)
					result = [result:"failed",message:"Failed to save instance!"]
				}else{
					result = [result:"success",message:"Instance updated!"]
				}
				
			}else{
				result = [result:"notfound",message:"Error: Instance with id '" + _id + "' not found!"]
			}
		}catch(Exception e){
			//e.printStackTrace()
			println e.getMessage()
			result = [result:"failure",message:"Error processing action."]
		}
		render result as JSON
	} //
} //end class
