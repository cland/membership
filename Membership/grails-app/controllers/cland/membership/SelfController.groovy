package cland.membership

import javax.servlet.http.HttpServletRequest
import grails.converters.JSON

/*
 * Controller for self service. Functions include:
 * 		- SelfRegister
 * 		- User Account Verification
 * 		- PartnerContract Registration
 */
class SelfController {

    def index() { 
		render "Test only"
	}
	def register(){
		
	}
	
	//*** Mailing Functions
	
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
	
	private String rpHash(String value) {
		int hash = 5381;
		value = value.toUpperCase();
		for(int i = 0; i < value.length(); i++) {
			hash = ((hash << 5) + hash) + value.charAt(i);
		}
		return String.valueOf(hash);
	}
	
	private boolean sendMessage(Message m){
		//TODO: need to implement the code replacement building a website-specific email message.
		
		/*
		 * {{sendermsg}} 	= m.message
		 * {{sendername}} 	= m.senderName
		 * {{senderemail}}	= m.senderEmail
		 * {{sendertel}}	= m.senderTel
		 * {{sendersubject}}= m.subject
		 */
		try{
			def _body = "Hi Team WigglyToesIPC,<br/><br/>" + m.message + "<br/><br/><b>Sender: </b>" + m.senderName + "<br/>"
			_body = _body + "<b>Email: </b>" + m.senderEmail + "<br/>"
			_body = _body + "<b>Tel: </b>" + m.senderTel + "<br/>"
						
			mailService.sendMail {
				to m.sendTo
				bcc m.sendBlindCopyTo
				from m.sendFrom
				subject "Wiggly Message from " + m.senderName + ": " + m.subject
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
	
} //end controller
