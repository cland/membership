package cland.membership

import javax.servlet.http.HttpServletRequest

import grails.converters.JSON
import grails.transaction.Transactional
import cland.membership.security.Person
import cland.membership.lookup.*
import groovy.json.JsonSlurper
import groovy.ui.text.FindReplaceUtility.ReplaceAllAction
import groovyx.gpars.actor.impl.MessageStream.SendTo

import java.text.DateFormat
import java.text.SimpleDateFormat
import java.util.Date

import org.joda.time.DateTime
import org.joda.time.format.DateTimeFormat

import com.macrobit.grails.plugins.attachmentable.domains.Attachment;

/*
 * Controller for self service. Functions include:
 * 		- SelfRegister
 * 		- User Account Verification
 * 		- PartnerContract Registration
 */
class SelfController {
	def springSecurityService
	def groupManagerService
	def cbcApiService
	def mailService
	
	def allowedMethods = [selfregister:"POST",verify:"GET",selfreset:"POST",resetverify:"GET"]
	
    def index() { 

	}
	def register(){
		Long pnt = 18L
		Long partnerid = 1L
		def partnerContractInstance = PartnerContract.createCriteria().get{
			parent{
				idEq(pnt)
			}
			partner{
				idEq(partnerid)
			}
		}
		println("parnter contract: " + partnerContractInstance)
	}
	@Transactional
	def verify(params){
		//verify the hash code
		if(params?.hash == null | params?.count == null | params?.count == ""){
			render "ST1: Invalid request! "
			return
		}
		def hashcode = params?.hash
		if(hashcode.length() != 27){
			render "ST2: Invalid request! "
			return
		}else{		
			def m = Message.findByHashcode(params?.hash)
			if(m != null){
				def p = Person.get(params?.count)
				if(p != null & params?.count == m.outcome){
					
					p.enabled = true
					m.hashcode = "confirmed"
					if(!p.save(flush:true)){
						println p.errors
						render "err01: verification failed"
						return
					}
					if(!m.save(flush:true)){
						p.enabled = false
						p.save(flush:true)
						println m.errors
						render "err02: verification failed"
						return
					}
					try{
						
						def parentInstance = Parent.findByPerson1(person)
						def partnerInstance = Partner.find{true}
						def partnerContractInstance = PartnerContract.createCriteria().get{
							parent{
								idEq(parentInstance?.id)
							}
							partner{
								idEq(partnerInstance?.id)
							}
						}
						
						if (partnerContractInstance != null){
							partnerContractInstance.isUserVerified = true
							partnerContractInstance.save flush:true
						}else{
							println("Could not find partner contract with parentid: " + parentInstance?.id + " and partnerid " + partnerInstance?.id)
						}
					}catch(Exception e){ //TODO fix this and implement better
						e.printStackTrace()
					}
					
					redirect (url:cbcApiService.getBasePath(request) + "login", permanent:true)
				}else{
					render "ST3: Invalid request! "
					return
				}
			}
		}		
	} //
	@Transactional
	def resetverify(params){
		
		//verify the hash code
		if(params?.hash == null | params?.count == null | params?.count == ""){
			render "ST1: Invalid request! "
			return
		}
		
		def hashcode = params?.hash
		if(hashcode.length() != 27){
			render "ST2: Invalid request! "
			return
		}else{
			def m = Message.findByHashcode(params?.hash)
			
			if(m != null){
				def p = Person.get(params?.count)
				if(p != null & params?.count == m.outcome){
					p.enabled = true
					m.hashcode = "confirmed"
					if(!p.save(flush:true)){
						println p.errors
						render "err01: verification failed"
						return
					}
					if(!m.save(flush:true)){
						p.enabled = false
						p.save(flush:true)
						println m.errors
						render "err02: verification failed"
						return
					}
					try{
						def parentInstance = Parent.findByPerson1(p)
						def partnerInstance = Partner.find{true}
						def partnerContractInstance = PartnerContract.createCriteria().get{
							parent{
								idEq(parentInstance?.id)
							}
							partner{
								idEq(partnerInstance?.id)
							}
						}
						if (partnerContractInstance != null){
							partnerContractInstance.isUserVerified = true
							partnerContractInstance.save flush:true
						}
					}catch(Exception e){ //TODO fix this and implement better
						println(e.getMessage())
					}
					redirect (url:cbcApiService.getBasePath(request) + "login", permanent:true)
				}else{
					render "ST3: Invalid request! "
					return
				}
			}
		}
		
	} //
	def validateEmail(params){
		def result = []
		try{
			def person = Person.findByEmail(params?.e)
			def ans = false
			if (person != null) ans = true
			result = ["result":"success","ison": ans]
		}catch (Exception e){
			result = ["result":"failed","error":"" + e.getMessage() + ""]
		}
		render result as JSON				
	} //end function validating email
	
	@Transactional
	def selfregister(){
		def dfmt = new SimpleDateFormat("dd-MMM-yyyy HH:mm")
		
		Office office = Office.get(params?.office.id)
		
		Parent parentInstance = new Parent(params.parent)
		parentInstance.clientType = Keywords.findByName("GymMember")
		def num = cbcApiService.generateIdNumber(new Date(),5)
		parentInstance.membershipNo = num
		parentInstance.office = office
		Person person1 = new Person(params.parent.person1)
		person1.office = office
		person1.username = params.parent.person1.email //cbcApiService.generateUsername(person1.firstName.toLowerCase(), person1.lastName.toLowerCase())
		person1.password = params.parent.person1.password
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
				child.office = office
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
		
		//create the partner contract
		try{
		def partner = Partner.get(params?.partner?.id)
		def contract = new PartnerContract()
			contract.partner = partner
			contract.parent = parentInstance
			contract.membershipNo=params?.membershipNo
			contract.contractNo = cbcApiService.generateRandomString(new Date(), "yymmdd", 4)
			contract.isUserVerified = false			//set to true when user response the email link with hashcode
			contract.isValidPartnerMember = false	//set to true when user presents membership card at a Wiggly Toe Centre
			contract.dateRegistered = new Date()
			contract.comments = "created via self service by user"
			if(!contract.save(flush:true)){
				println(contract.errors)
			}
		}catch(Exception e){
			//TODO handle the partner contract section better
			e.printStackTrace()
		}
		//end email
		if(sendEmail(person1, "Registration","")){
			print "Error: Failed to Save and Sent Message"
		}
		
		request.withFormat {
					form multipartForm {
						flash.message = "Registration successful for '" + parentInstance + "'! Membership number: '" + parentInstance?.membershipNo + "' an email has been sent to your inbox with a link to the final step of the registration process."
						//redirect controller:"home", action: "index", method: "GET", permanent:true
						redirect (url:cbcApiService.getBasePath(request) + "self/register", permanent:true)
					}
					'*'{ render status: OK }
				}
	}
	
	@Transactional
	def selfreset(){
		def result = ""
		Map<String, String[]> vars = request.getParameterMap()
		def clientkey = vars.resetemail[0]
		def salt = ""
		def captcha = vars.captcha[0]
		
		def realPersonHash = vars.border[0]
		def testHash = rpHash(captcha + salt)
		def partnerid = vars.membershipno[0]
		def membershipNo = vars.partnerid[0]
		if (testHash.equals(realPersonHash)) {			
			// Now check if email is available
			try{
				def person = Person.findByEmail(clientkey)				
				if (person == null) {
					result=[result:"failed",message:"Email ['" + clientkey + "'] not found in our system. Please contact any Wiggly Toes IPC center for assistance."]
				}else{
					//get the parent
					def parent = Parent.findByPerson1(person)
					if(parent != null){
						parent.clientType = Keywords.findByName("GymMember")
						parent.save(flush:true)
						def pwd = cbcApiService.generateRandomString(null, "", 8)
						person.password = pwd
						person.username = person.email
						
						//create the partner contract
						try{
							def partner = Partner.get(partnerid)
							def contract = new PartnerContract()
							contract.partner = partner
							contract.parent = parent
							contract.membershipNo=membershipNo
							contract.contractNo = cbcApiService.generateRandomString(new Date(), "yymmdd", 4)
							contract.isUserVerified = false			//set to true when user response the email link with hashcode
							contract.isValidPartnerMember = false	//set to true when user presents membership card at a Wiggly Toe Centre
							contract.dateRegistered = new Date()
							contract.comments = "created via self service by user"
							if(!contract.save(flush:true)){
								println(contract.errors)
							}
						}catch(Exception e){
							//TODO handle the partner contract section better
							e.printStackTrace()
						}
						
						
						if(sendEmail(person, "Reset", pwd)){
							print "Error: Failed to Save and Sent Message"
						}
						result = ["result":"success","id": person.id]
					}else{
						result = ["result":"failed","message": "Could not locate valid details with the supplied email address"]
					}
				}
			}catch (Exception e){
				result = ["result":"failed","error":"" + e.getMessage() + ""]
			}
			
			
		}else{
			result = [result:"failedcaptcha",message:"Incorrect characters entered. Please try again."]
		}
		render result as JSON
	}
	
	//*** Mailing Functions
	boolean sendEmail(Person p, String templateName, String pwd){
		def hashcode = cbcApiService.generateIdNumber(new Date(),21)
		def m = new Message(
			sendTo:p.email,
			sendBlindCopyTo:'',
			senderName:'Wiggly Toes IPC',
			senderEmail:'',
			senderTel:'',
			outcome:p.id,
			senderIpAddress:'0.0.0.0',
			hashcode:hashcode
			)
		
		def site = Website.findBySitename(templateName)
		if(site != null){
			if(m.sendTo == ""  ) m.sendTo = site.sendTo
			if(site.sendCopyTo != ""  ) m.sendCopyTo = site.sendCopyTo
			m.sendBlindCopyTo = site.sendBlindCopyTo
			m.sendFrom = site.sendFrom
			m.senderEmail = site.sendFrom
			m.senderName = "Wiggly Toes IPC"
			m.senderTel = "0895 242 074"
			m.message = site.bodyTemplate
			.replace("{{fullname}}", p.fullname)
			.replace("{{username}}", p.username)
			.replace("{{pwd}}",pwd)
			.replace("{{personid}}", p.id.toString())
			.replace("{{verificationcode}}",hashcode)
			m.subject = site.subjectTemplate
		}else{
			if(m.SendTo == "" ) m.sendTo = "solutions@tagumiinvestments.com"
		}
		
		if(!m.save(flush:true)){
			println m.errors	
			return false		
		}else{
			if(sendMessage(m)){
				//success. save the message status
				m.status="sent"
				if(!m.save(flush:true)){
					println m.errors
					return false
				}
			}		
		}
		
		return true
	} //end sendEmail
	
	private String rpHash(String value) {
		int hash = 5381;
		value = value.toUpperCase();
		for(int i = 0; i < value.length(); i++) {
			hash = ((hash << 5) + hash) + value.charAt(i);
		}
		return String.valueOf(hash);
	}
	
	private boolean sendMessage(Message m){
		//TODO: need to implement the code replacement building a template-specific email message.
		
		/*
		 * {{sendermsg}} 	= m.message
		 * {{sendername}} 	= m.senderName
		 * {{senderemail}}	= m.senderEmail
		 * {{sendertel}}	= m.senderTel
		 * {{sendersubject}}= m.subject
		 */
		try{
			def _body = m.message
						
			mailService.sendMail {
				to m.sendTo
				bcc m.sendBlindCopyTo
				from m.sendFrom
				subject m.subject
				html _body
			 }
			return true
			}catch(Exception e){
				e.printStackTrace();
			}
		return false
	} //
	
	private String getBasePath(HttpServletRequest request){
		def _protocol = request.protocol
		def _servername = request.getServerName()
		def _port = ""
		if(_servername.equalsIgnoreCase("localhost")) _port = ":" + request.localPort
		return 'http://' + _servername + _port + request.contextPath +"/"
	}
	
	def sendmail() {
		def result = ""
		Map<String, String[]> vars = request.getParameterMap()
		//println (vars)
		def source = vars.source[0]
		def message = vars.body[0]
		def subject = vars.subject[0]
		def tel = vars.tel[0]
		def captcha = vars.captcha[0]
		def senderEmail = vars.from[0]
		def sender = vars.name[0]
		def ipAddress = "0.0.0.0"
		def basic = vars.basic[0]
		def salt = ""
		def realPersonHash = vars.border[0]
		def testHash = rpHash(captcha + salt);
		def sitename = vars.sitename[0]
		if (testHash.equals(realPersonHash)) {
			println("Correct hash, not a robot!")
			// Now save the message to database
			
			def m = new Message(
				sendTo:'',
				sendBlindCopyTo:'',
				subject:subject,
				message:message,
				senderName:sender,
				senderEmail:senderEmail,
				senderTel:tel,
				senderIpAddress:ipAddress,
				)
			
			def site = Website.findBySitename(sitename)
			if(site != null){
				m.sendTo = site.sendTo
				m.sendCopyTo = site.sendCopyTo
				m.sendBlindCopyTo = site.sendBlindCopyTo
				m.sendFrom = site.sendFrom
				m.message = site.bodyTemplate
				m.subject = site.subjectTemplate
			}else{
				m.sendTo = "solutions@tagumiinvestments.com"
			}
			
			if(!m.save(flush:true)){
				println m.errors
				result = [result:"fail",message:"Failed to send message."]
			}else{
				if(sendMessage(m)){
					//success. save the message status
					m.status="sent"
					if(!m.save(flush:true)){
						println m.errors
					}
				}
				result = [result:"success"]
			}
		}else{
			result = [result:"fail",message:"captcha"]
		}
		
		render result as JSON
	}
	
	def forwardemail(params){
		def result = ""
		def m = Message.get(params?.id)
		
		if(m != null){
			if(sendMessage(m)){
				//success. save the message status
				m.status="sent"
				if(!m.save(flush:true)){
					println m.errors
					result = [result:"success",message:"Failed to update message"]
					flash.message = "Failed to update message!"
					
				}else{
					result = [result:"success"]
					flash.message = "Message '" + m + "' updated successfully!"
				}
				redirect (url:getBasePath(request) + "message/show/" + m?.id, permanent:true)
			}else{
				//failed to send.
				result = [result:"fail",message:"Failed to send message."]
				flash.message = "Failed to send message!"
			}
		}else{
			result = [result:"fail",message:"Failed to send message. Message not found!"]
			flash.message = "Failed to send message. Message not found!"
			redirect (url:getBasePath(request) + "message/", permanent:true)
		}
	} //end forwardemail method
} //end controller
