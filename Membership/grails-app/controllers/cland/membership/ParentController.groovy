package cland.membership

import static org.springframework.http.HttpStatus.*
import cland.membership.security.Person
import cland.membership.lookup.*
import grails.converters.JSON
import grails.transaction.Transactional
import groovy.json.JsonSlurper

import java.text.DateFormat
import java.text.SimpleDateFormat

import org.joda.time.DateTime
import org.joda.time.format.DateTimeFormat

import com.macrobit.grails.plugins.attachmentable.domains.Attachment;

@Transactional(readOnly = true)
class ParentController {
	def springSecurityService
	def groupManagerService
	def cbcApiService
	def emailService
	def nexmoService

    static allowedMethods = [save: "POST", update: "POST", delete: "DELETE",checkout:"POST",newclient:"POST",checkin:"POST", newcoupon:"POST", selfregister:"POST", updatevisitstatus:"POST", addvisittocoupon:"POST"]

    def index(Integer max) {
        params.max = Math.min(max ?: 30, 100)
        respond Parent.list(params).sort{it.person1.lastName }, model:[parentInstanceCount: Parent.count()]
    }

    def show(Parent parentInstance) {
		//def c = cbcApiService.findActiveCoupon(parentInstance, null,0)
		//println(c)
        respond parentInstance
    }

    def create() {
        respond new Parent(params)
    }

    @Transactional
    def save(Parent parentInstance) {
		
		def dfmt = new SimpleDateFormat("dd-MMM-yyyy HH:mm")
		Office office = Office.list().first()
		
        if (parentInstance == null) {
            notFound()
            return
        }
		parentInstance.clientType = Keywords.findByName("Standard")
		def num = cbcApiService.generateIdNumber(new Date(),5)
		parentInstance.membershipNo = num
		
		Person person1 = new Person(params?.person1) 
		person1.office = office
		person1.username = cbcApiService.generateUsername(person1.firstName.toLowerCase() , person1.lastName.toLowerCase())
		person1.password = person1.username
		person1.enabled = false
		if (person1.save(flush:true)) {
			println person1.errors			
		}
					
		parentInstance.person1 = person1
		
		//Emergency person
		Person person2 = new Person(params.person2)
		person2.office = office
		person2.username = cbcApiService.generateUsername(person2.firstName.toLowerCase() , person2.lastName.toLowerCase())
		person2.password = person2.username
		person2.enabled = false
		
		if(!person2.save(flush:true)){
			println person2.errors
		}else{
			parentInstance.person2 = person2
		}
		
		if(!parentInstance.save(flush:true)){
			println parentInstance.errors
		}
		
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'parent.label', default: 'Parent'), parentInstance.id])
                // redirect parentInstance
				redirect (url:cbcApiService.getBasePath(request) + "parent/show/" + parentInstance?.id, permanent:true)
           }
            '*' { respond parentInstance, [status: CREATED] }
        }
    }

    def edit(Parent parentInstance) {
        respond parentInstance
    }

    @Transactional
    def update(Parent parentInstance) {
        if (parentInstance == null) {
            notFound()
            return
        }

        if (parentInstance.hasErrors()) {
            respond parentInstance.errors, view:'edit'
            return
        }
		def dfmt = new SimpleDateFormat("dd-MMM-yyyy HH:mm")
		Office office = Office.list().first()
		
		//need to add the children 
		def newvisits = [:]
		// save the children
		def i = 1
		while(params.get("child.person.lastname" + i)){
			def child = new Child()
			def p = new Person()
			p.firstName = params.get("child.person.firstname" + i)
			p.lastName = params.get("child.person.lastname" + i)
			if(p.firstName != "" & p.lastName != ""){
				p.dateOfBirth = new Date(params.get("child.person.dateOfBirth" + i))
				p.gender =  Keywords.get(params.get("child.person.gender" + i))
				p.office = office
				p.username = cbcApiService.generateUsername(p.firstName.toLowerCase() , p.lastName.toLowerCase())
				p.password = p.username
				p.enabled = false
				p.mobileNo = parentInstance?.person1?.mobileNo
				p.email = parentInstance?.person1?.email
				if(!p.save(flush:true)){
					println p.errors
					 respond parentInstance.errors, view:'edit'            
					return
				}
				child.person = p
				groupManagerService.addUserToGroup(p,office,"ROLE_USER")
				attachUploadedFilesTo(p,["profilephoto" + i])
				if(parentInstance.children){
					child.accessNumber = parentInstance.children.size() + 1
				}else{
					child.accessNumber = 1
				}
				// is checkin required now? IF NOT ARRAY NOT WORKING:
				println "Processing checkin...'" + params.get("child.checkin" + i) + "'"
				if( params.get("child.checkin" + i) == "Yes" ){
					//println ".. creating a visit now."
					//println "time: " + params.child.visit.time[index]
					//DateTime timein = DateTime.parse(params.child.visit.time[index], DateTimeFormat.forPattern("dd-MMM-yyyy HH:mm")) //.parseDateTime(params.child.visit.time[index])
					Date timein = dfmt.parse(params.get("child.visit.time"+ i))
					def _photokey = "visitphoto" + i
					def visit = new Visit(status:"Active",starttime:timein,timerCheckPoint:timein,photoKey:_photokey)
					child.addToVisits(visit)
					
					//attachUploadedFilesTo(visit,["visitphoto" + index])
					newvisits.put(p?.id , _photokey)
				}
								
				parentInstance.addToChildren(child)
			}// end first check for firstname and lastname
			
			i++
		}
        parentInstance.save flush:true
		newvisits.each {cid,key ->			
			def c = Child.findByPerson(Person?.get(cid))
			if(c != null){
				def v = c.visits.find{ it?.photoKey == key }
				if(v != null){
					attachUploadedFilesTo(v,[key])
				}
			}
		}
		
        request.withFormat {
            form multipartForm {
                flash.message = "Client '" + parentInstance + "' updated successfully! Membership number: '" + parentInstance?.membershipNo + "'"
                //redirect(action: "show", id:parentInstance?.id, permanent:true) //redirect parentInstance, permanent:true
				redirect (url:cbcApiService.getBasePath(request) + "parent/show/" + parentInstance?.id, permanent:true)
            }
            '*'{ respond parentInstance, [status: OK] }
        }
    }

    @Transactional
    def delete(Parent parentInstance) {

        if (parentInstance == null) {
            notFound()
            return
        }

        parentInstance.delete flush:true
		flash.message = "Client '" + parentInstance + "' updated successfully! Membership number: '" + parentInstance?.membershipNo + "'"
		//redirect(action: "show", id:parentInstance?.id)
		redirect (url:cbcApiService.getBasePath(request) + "parent/", permanent:true)
		/*
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'Parent.label', default: 'Parent'), parentInstance.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
        */
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'parent.label', default: 'Parent'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
	@Transactional
	def editcoupon(){
		def coupon = Coupon.get(params?.id)
		render (view:"/parent/editcoupon",model:[couponInstance: coupon]) 
	}
	@Transactional
	def updatecoupon(){
		def result = []
		Map<String, String[]> vars = request.getParameterMap()
		def _couponid = vars.couponid[0]
		Coupon c = Coupon.get(_couponid)
		if(c){
			def _refno = vars.refno[0]
			def _maxvisits = Integer.parseInt(vars.maxvisits[0])
			def _startdate = vars.startdate[0]
			def _expirydate = vars.expirydate[0]
	
			c.refNo = _refno
			c.maxvisits=_maxvisits
			c.startDate=new Date(_startdate)
			c.expiryDate=new Date(_expirydate)
			if(!c.save(flush:true)){
				println(c.errors)
				result = [result:"failure",message:"Failed to save coupon!"]
			}else{
			result = [result:"success",message:"Coupon updated successfully!",id:c?.id]
			}
		}else{
			result = [result:"failure",message:"Could not find a coupon with id '" + _couponid + "'"]
		}
		render result as JSON
	} //
	@Transactional
	def rmcouponvisit(){
		def result = []
		try{
			
			Map<String, String[]> vars = request.getParameterMap()
			def _couponid = vars.cid[0]
			def _visitid = vars.vid[0]
			Coupon c = Coupon.get(_couponid)
			if(c){
				Visit visit = Visit.get(_visitid)
				if(visit){
					c.visits.remove(visit)
					//c.save flush:true
					result = [result:"success",message:"Visit removed from coupon successfully!"]
				}else{
					result = [result:"failure",id:_couponid,message:"Could not find a visit with id '" + _visitid + "'"]
				}
			}else{
				result = [result:"failure",id:_couponid,message:"Could not find a coupon with id '" + _couponid + "'"]
			}
		
		}catch(Exception e){
			result = [result:"failure",message:"Could not find a client with id '" + _couponid + "'"]
		}
		render result as JSON
	} //
	@Transactional
	def updatevisitstatus(){
		def result = []
		try{
			
			Map<String, String[]> vars = request.getParameterMap()
			def _status = vars.status[0]
			def _visitid = vars.vid[0]
			Visit visit = Visit.get(_visitid)
			if(visit){
				visit.status = _status
				if( visit.save(flush:true) ){				
					result = [result:"success",message:"Visit status updated successfully!"]
					if(visit?.status?.equalsIgnoreCase("Cancelled")) cbcApiService.removeVisitFromCoupon(visit)
				}else{
					result = [result:"failure",id:_visitid,message:"Failed to update visit status"]
				}
			}else{
				result = [result:"failure",id:_visitid,message:"Could not find a visit with id '" + _visitid + "'"]
			}
			
		
		}catch(Exception e){
			//e.printStackTrace()
			println e.getMessage()
			result = [result:"failure",message:"Error processing action."]
		}
		render result as JSON
	}
	
	@Transactional
	def addvisittocoupon(){
		def result = []
		try{			
			Map<String, String[]> vars = request.getParameterMap()
			def _visitid = vars.vid[0]
			Visit visit = Visit.get(_visitid)
			if(visit){
				if(cbcApiService.addVisitToCoupon(visit)){
					result = [result:"success",message:"Visit added to coupon successfully!"]
				}else{
					result = [result:"failure",id:_visitid,message:"No matching coupon found for the visit's date."]
				}
			}else{
				result = [result:"failure",id:_visitid,message:"Could not find a visit with id '" + _visitid + "'"]
			}
			
		
		}catch(Exception e){
			result = [result:"failure",message:"Error processing action."]
		}
		render result as JSON
	}
	
	@Transactional
	def rmcoupon(){
		def result = []
		try{			
			
			Map<String, String[]> vars = request.getParameterMap()
			def _couponid = vars.id[0]
			Coupon c = Coupon.get(_couponid)
			if(c){
				c.delete flush:true
				result = [result:"success",message:"Removed coupon successfully!"]
			}else{
				result = [result:"failure",id:_couponid,message:"Could not find a coupon with id '" + _couponid + "'"]
			}
		
		}catch(Exception e){
			result = [result:"failure",message:"Could not find a client with id '" + _couponid + "'"]
		}
		render result as JSON
	} //
	
	@Transactional
	def newcoupon(){
		def result = []
		Map<String, String[]> vars = request.getParameterMap()
		def _parentid = vars.parentid[0]
		def parentInstance = Parent.get(_parentid)
		if(parentInstance){
			def _refno = vars.refno[0]
			def _maxvisits = vars.maxvisits[0]
			def _startdate = vars.startdate[0]
			def _expirydate = vars.expirydate[0]
	
			def coupon = new Coupon(refNo:_refno, maxvisits:_maxvisits,startDate:new Date(_startdate),expiryDate:new Date(_expirydate))
			//if(!coupon.save(flush:true)){
			//	println(coupon.errors)
			//	result = [result:"failure",message:"Failed to save coupon!"]
			//}else{
				parentInstance?.addToCoupons(coupon)
				if(!parentInstance.save(flush:true)){
					println(parentInstance.errors)
					result = [result:"failure",message:"Failed to add coupon to parentInstance coupons list"]
				}else{
					result = [result:"success",id:coupon?.id]
				}
				
		//}
		}else{
			result = [result:"failure",message:"Could not find a client with id '" + parentid + "'"]
		}
		render result as JSON
	}
	
	@Transactional
	def newclient(){
		def dfmt = new SimpleDateFormat("dd-MMM-yyyy HH:mm")
		Office office = Office.list().first()
		
		Parent parentInstance = new Parent(params.parent)
		parentInstance.clientType = Keywords.findByName("Standard")
		def num = cbcApiService.generateIdNumber(new Date(),5)
		parentInstance.membershipNo = num
		Person person1 = new Person(params.parent.person1)
		person1.office = office
		person1.username = cbcApiService.generateUsername(person1.firstName.toLowerCase(), person1.lastName.toLowerCase())
		person1.password = person1.username
		person1.enabled = false
		
		if(!person1.save(flush:true)){
			println person1.errors
			render person1.errors as JSON
			return
		}
		groupManagerService.addUserToGroup(person1,office,"ROLE_USER")
		parentInstance.person1 = person1
		
		//Emergency person
		Person person2 = new Person(params.parent.person2)
		person2.office = office
		person2.username = cbcApiService.generateUsername(person2.firstName.toLowerCase() , person2.lastName.toLowerCase())
		person2.password = person2.username
		person2.enabled = false
		
		if(!person2.save(flush:true)){
			println person2.errors			
		}else{
			parentInstance.person2 = person2
		}
		groupManagerService.addUserToGroup(person2,office,"ROLE_USER")
		def newvisits = [:]
		// save the children
		def i = 1
		while(params.get("child.person.lastname" + i)){
			def child = new Child()
			def p = new Person()
			p.firstName = params.get("child.person.firstname" + i)
			p.lastName = params.get("child.person.lastname" + i)
			if(p.firstName != "" & p.lastName != ""){
				p.dateOfBirth = new Date(params.get("child.person.dateOfBirth" + i))
				p.gender =  Keywords.get(params.get("child.person.gender" + i))
				p.office = office
				p.username = cbcApiService.generateUsername(p.firstName, p.lastName)
				p.password = p.username
				p.enabled = false
				p.mobileNo = person1?.mobileNo
				p.email = person1?.email
				if(!p.save(flush:true)){
					println p.errors
					request.withFormat {
						form multipartForm {
							flash.message = "Error!"
							redirect controller:"home", action: "index", method: "GET"
						}
						'*'{ render status: OK }
					}
					return
				}
				groupManagerService.addUserToGroup(p,office,"ROLE_USER")
				child.person = p
				attachUploadedFilesTo(p,["profilephoto" + i])
				if(parentInstance.children){
					child.accessNumber = parentInstance.children.size() + 1
				}else{
					child.accessNumber = 1
				}
				// is checkin required now? IF NOT ARRAY NOT WORKING:
				println "Processing checkin...'" + params.get("child.checkin" + i) + "'"
				if( params.get("child.checkin" + i) == "Yes" ){					
					Date timein = dfmt.parse(params.get("child.visit.time"+ i))
					def _visitno = params.get("child.visit.visitno"+ i)
					def _photokey = "visitphoto" + i
					def visit = new Visit(status:"Active",starttime:timein,timerCheckPoint:timein,photoKey:_photokey,visitNo:_visitno)
					child.addToVisits(visit)					
					newvisits.put(p?.id , _photokey)
				}
								
				parentInstance.addToChildren(child)
			}// end first check for firstname and lastname
			
			i++
		}
		
		if(!parentInstance.save(flush: true)){
			println parentInstance.errors
			request.withFormat {
		            form multipartForm {
		                flash.message = "Error!"
		                redirect controller:"home", action: "index", method: "GET", permanent:true
		            }
		            '*'{ render status: OK }
		        }
			return
		}
		
		//attachUploadedFilesTo(parentInstance,["profilephoto1","profilephoto2"])
		newvisits.each {cid,key ->
			def c = Child.findByPerson(Person?.get(cid))
			if(c != null){
				def v = c.visits.find{ it?.photoKey == key }
				if(v != null){
					attachUploadedFilesTo(v,[key])
				}
			}
		}	
		
		request.withFormat {
		            form multipartForm {
		                flash.message = "Client '" + parentInstance + "' create successfully! Membership number: '" + parentInstance?.membershipNo + "'"
		                //redirect controller:"home", action: "index", method: "GET", permanent:true
						redirect (url:cbcApiService.getBasePath(request), permanent:true)
		            }
		            '*'{ render status: OK }
		        }
	}
	def search(){	
		def term = "%" + params?.term + "%"
		def results = Parent.createCriteria().list(params) {
			or{
				person1 {
					or{
						ilike('lastName',term)
						ilike('mobileNo',term)
						ilike('email',term)
					}					
				}
				ilike('membershipNo',term)
				
			}
		}
		def selectList = []
		if(results.size()>0){
			results.each {
				selectList.add(it.toAutoCompleteMap())
			}
		}else{
			selectList = [id:-1,label:"No results found!",value:"",	childlist:null,category:"No Result"]
		}

		render selectList as JSON
	} //end search
	@Transactional
	def checkout(params){
		def result = []
		Map<String, String[]> vars = request.getParameterMap()
		def _id = vars.id[0]
		def _endtime = vars.endtime[0]
		def _status = vars.status[0]
		def visit = Visit.get(_id)
		if (visit != null){
			def dfmt = new SimpleDateFormat("dd-MMM-yyyy HH:mm")			
			def dateout = dfmt.parse(_endtime) 			
			visit.endtime = dateout //timeout.toLocalDateTime();
			visit.status = _status
			if(visit.save(flush:true)){
				//add the coupon if status is completed
				if(visit?.status?.equalsIgnoreCase("complete")){
					try{
						def parentInstance = visit?.child?.parent
						if(parentInstance != null) {						
							def coupon = cbcApiService.findActiveCoupon(parentInstance, visit.starttime,0)
							if(coupon != null) {
								coupon?.addToVisits(visit)
								coupon.save()
							}
						}
						
					}catch(Exception e){
						e.printStackTrace()
					}
				}
				result = [result:"success"]
				result.putAll(visit?.toMap())				
			}else{
				result.push([result:"failed", message:"Could not find visit with id '" + _id + "'"])
			}
		}else{
			
		}
		
		render result as JSON
	} //end method checkout
	boolean isCollectionOrArray(object) {
		[Collection, Object[]].any { it.isAssignableFrom(object.getClass()) }
	}
	@Transactional
	def checkin(params){
		def result = []
		def msg = ""		
		def parentInstance = null
		def coupon = null
		def _contactno = params?.get("contactno")
		def _starttime = params?.get("child.searchvisit.time")
		def _children = params?.list("search_children")
		
		_children.each{
			def childInstance = Child.get(Long.parseLong(it))
			if(childInstance){
				
				Date timein = new SimpleDateFormat("dd-MMM-yyyy HH:mm").parse(_starttime)
				def _visitno = params?.get("visitno" + childInstance?.id)
				def visit = new Visit(status:"Active",starttime:timein,timerCheckPoint:timein,contactNo:_contactno,visitNo:_visitno)
				childInstance.addToVisits(visit)								
				
				if(!childInstance.save(flush:true)){
					println(childInstance.errors)
					msg = msg + "Child '" + value + "' failed to save! "
				}
				//add the coupon if available - moved this to point of check-out
				/*
				try{
					if(parentInstance == null) {
						parentInstance = childInstance?.parent
						coupon = cbcApiService.findActiveCoupon(parentInstance, timein,0)
					}
					if(coupon != null) {
						coupon?.addToVisits(visit)
						coupon.save()
					}
				}catch(Exception e){
					e.printStackTrace()
				}
				*/
				attachUploadedFilesTo(visit,["visitphoto" + childInstance?.id])
			}
		}//end looping through all the children id list
				

		result = [result:"success",message:msg]
		render result as JSON
	} //end function checking
	
	@Transactional
	def selfregister(){
		def dfmt = new SimpleDateFormat("dd-MMM-yyyy HH:mm")
		Office office = Office.list().first()
		
		Parent parentInstance = new Parent(params.parent)
		parentInstance.clientType = Keywords.findByName("Standard")
		def num = cbcApiService.generateIdNumber(new Date(),5)
		parentInstance.membershipNo = num
		Person person1 = new Person(params.parent.person1)
		person1.office = office
		person1.username = cbcApiService.generateUsername(person1.firstName.toLowerCase(), person1.lastName.toLowerCase())
		person1.password = person1.username
		person1.enabled = false
		
		if(!person1.save(flush:true)){
			println person1.errors
			render person1.errors as JSON
			return
		}
		groupManagerService.addUserToGroup(person1,office,"ROLE_USER")
		parentInstance.person1 = person1
		
		//Emergency person
		Person person2 = new Person(params.parent.person2)
		person2.office = office
		person2.username = cbcApiService.generateUsername(person2.firstName.toLowerCase() , person2.lastName.toLowerCase())
		person2.password = person2.username
		person2.enabled = false
		
		if(!person2.save(flush:true)){
			println person2.errors
		}else{
			parentInstance.person2 = person2
		}
		groupManagerService.addUserToGroup(person2,office,"ROLE_USER")
		def newvisits = [:]
		// save the children
		def i = 1
		while(params.get("child.person.lastname" + i)){
			def child = new Child()
			def p = new Person()
			p.firstName = params.get("child.person.firstname" + i)
			p.lastName = params.get("child.person.lastname" + i)
			if(p.firstName != "" & p.lastName != ""){
				p.dateOfBirth = new Date(params.get("child.person.dateOfBirth" + i))
				p.gender =  Keywords.get(params.get("child.person.gender" + i))
				p.office = office
				p.username = cbcApiService.generateUsername(p.firstName, p.lastName)
				p.password = p.username
				p.enabled = false
				p.mobileNo = person1?.mobileNo
				p.email = person1?.email
				if(!p.save(flush:true)){
					println p.errors
					request.withFormat {
						form multipartForm {
							flash.message = "Error!"
							redirect controller:"home", action: "index", method: "GET"
						}
						'*'{ render status: OK }
					}
					return
				}
				groupManagerService.addUserToGroup(p,office,"ROLE_USER")
				child.person = p
				//attachUploadedFilesTo(p,["profilephoto" + i])
				if(parentInstance.children){
					child.accessNumber = parentInstance.children.size() + 1
				}else{
					child.accessNumber = 1
				}				
				child.comments = params.get("child.comments" + i)				
				parentInstance.addToChildren(child)
			}// end first check for firstname and lastname
			
			i++
		}
		
		if(!parentInstance.save(flush: true)){
			println parentInstance.errors
			request.withFormat {
					form multipartForm {
						flash.message = "Error!"
						redirect controller:"home", action: "index", method: "GET", permanent:true
					}
					'*'{ render status: OK }
				}
			return
		}
		
		request.withFormat {
					form multipartForm {
						flash.message = "Registration successful for '" + parentInstance + "'! Membership number: '" + parentInstance?.membershipNo + "'"
						//redirect controller:"home", action: "index", method: "GET", permanent:true
						redirect (url:cbcApiService.getBasePath(request) + "selfregister", permanent:true)
					}
					'*'{ render status: OK }
				}
	}
	
	@Transactional
	def newclientajax(){
		println ("======================================")
		println("PARAMS")
		println(params)
		
		println("REQUEST MAP")
		Map<String, String[]> vars = request.getParameterMap()
		println(vars)
		println ("======================================")
		def dfmt = new SimpleDateFormat("dd-MMM-yyyy HH:mm")
		Office office = Office.list().first()
		
		Parent parentInstance = new Parent(params.parent)
		parentInstance.clientType = Keywords.findByName("Standard")
		def num = cbcApiService.generateIdNumber(new Date(),5)
		parentInstance.membershipNo = num
		Person person1 = new Person(params.parent.person1)
		person1.office = office
		person1.username = cbcApiService.generateUsername(person1.firstName.toLowerCase() , person1.lastName.toLowerCase())
		person1.password = person1.username
		person1.enabled = false
		
		if(!person1.save(flush:true)){
			println person1.errors
			render person1.errors as JSON
			return
		}
		parentInstance.person1 = person1
		
		//Emergency person
		Person person2 = new Person(params.parent.person2)
		person2.office = office
		person2.username = cbcApiService.generateUsername(person2.firstName.toLowerCase() , person2.lastName.toLowerCase())
		person2.password = person2.username
		person2.enabled = false
		
		if(!person2.save(flush:true)){
			println person2.errors
		}else{
			parentInstance.person2 = person2
		}
		
		// save the children
		params.child.person.firstname.eachWithIndex { value, index ->
			def child = new Child()
			def p = new Person()
			p.firstName = value
			p.lastName = params.child.person.lastname[index]
			p.dateOfBirth = new Date(params.child.person.dateOfBirth[index])
			p.gender = Keywords.get(params.child.person.gender[index])
			p.office = office
			p.username = cbcApiService.generateUsername(p.firstName.toLowerCase() , p.lastName.toLowerCase())
			p.password = p.username
			p.enabled = false
			p.mobileNo = "-1"
			if(!p.save(flush:true)){
				println p.errors
				render p.errors as JSON
				return
			}
			child.person = p
			if(parentInstance.children){
				child.accessNumber = parentInstance.children.size() + 1
			}else{
				child.accessNumber = 1
			}
			//is checkin required now?
			println "Processing checkin..."
			if( params.child.checkin[index] == "Yes" ){
				//println ".. creating a visit now."
				//println "time: " + params.child.visit.time[index]
				//DateTime timein = DateTime.parse(params.child.visit.time[index], DateTimeFormat.forPattern("dd-MMM-yyyy HH:mm")) //.parseDateTime(params.child.visit.time[index])
				Date timein = dfmt.parse(params.child.visit.time[index])
				def visit = new Visit(status:"Active",starttime:timein,timerCheckPoint:timein)
				attachUploadedFilesTo(visit,["visitphoto" + index])
			
				child.addToVisits(visit)
			}
			
			attachUploadedFilesTo(child,["profilephoto" + index])  //TODO: Add attachment to child
			parentInstance.addToChildren(child)
		}
		if(!parentInstance.save(flush: true)){
			println parentInstance.errors
			render parentInstance.errors as JSON
			return
		}
		
		render parentInstance.toMap() as JSON
	}
} //end class
