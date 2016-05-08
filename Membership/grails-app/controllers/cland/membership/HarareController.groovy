package cland.membership


//import groovyx.net.http.RESTClient
//import static groovyx.net.http.ContentType.JSON
import groovy.json.JsonSlurper
import groovy.json.JsonOutput
import grails.converters.JSON

class HarareController {
	def springSecurityService
	def cbcApiService
	def mailService //emailService
	def nexmoService

	static allowedMethods = [htown: "POST",savenote:"POST"]
    def htown(params) {
		
		println(params)
		return;
		/*
		sendMail {
		 to "dembaremba@gmail.com"
		 subject "Notification"
		 body "Hello this is to verify that your account has been created"
	   } */
		mailService.sendMail {
			to "dembaremba@gmail.com","tagumi.solutions@gmail.com"
			from "tagumi.solutions@gmail.com"
			cc "ti@tagumiinvestments.com"
			subject "Hello Test"
			body 'this is some text send from test application.'
		 }
		render '{"status:"success"}' as JSON
	 /*try{
		 smsResult = nexmoService.sendSms("0621347734", "Hello Bo, This is a notification of a new person in " +
			 "Membership call Lungelo Ndaba when you get this sms", "0791623651")
	 }catch(e){
		 println e
		 render(contentType: "text/json"){
			 e
		 }
	 }*/
	}
	/*
	def ctown(){
		//@Grab (group = 'org.codehaus.groovy.modules.http-builder', module = 'http-builder', version = '0.5.0')
		def client = new RESTClient("https://rest.clicksend.com/v3")
		
		def emptyHeaders = [:]
		emptyHeaders."Content-Type" = "application/json"
		emptyHeaders."Authorization" = "Basic YXBpLXVzZXJuYW1lOmFwaS1wYXNzd29yZA=="
		
		def msgs = '{"messages": [{ "source": "php", "from": "sendmobile", "body": "Jelly liquorice marshmallow candy carrot cake 4Eyffjs1vL.", "to": "+61411111111", "schedule": 1436874701,"custom_string": "this is a test"}]}'
		def jsonObj = new JsonSlurper().parseText(msgs)
		response = client.post( path : "/sms/send",
								body : jsonObj,
								headers: emptyHeaders,
								contentType : JSON )
		
		println("Status:" + response.status)
		
		if (response.data) {
		  println("Content Type: " + response.contentType)
		  println("Body:\n" + JsonOutput.prettyPrint(JsonOutput.toJson(response.data)))
		}
	
	} */
	
	def savenote(){	
		def result = ["response_code":"failure","response_msg":"Could not locate the CHILD/VISIT instances."]
		boolean processed = false
		try{
			def jsonSlurper = new JsonSlurper()			
			params.eachWithIndex { v,i ->								
				def data = jsonSlurper.parseText(v.toString())				
				if(data?.childid){					
					if(!processed){
						def child = Child.get(data?.childid)
						def visit = Visit.get(data?.visitid)
						if (child != null & visit != null){		
							def _body = data?.body
							def _sendto = data?.sendto
							def _response_code = data?.response_code
							def _response_msg = data?.response_msg
							def _queued_count = data?.queued_count 
							def _total_price = data?.total_price
							def _total_count = data?.total_count
							def _template = Template.get(data?.templateid)
							
							def notification = new Notification(
									child:child,
									visit:visit,
									template:_template,
									responseCode:_response_code,
									responseMsg:_response_msg,
									sendTo:_sendto,
									body:_body,
									totalPrice:_total_price,
									totalCount:_total_count,
									queuedCount:_queued_count
								)																				
							processed = true
							if(!notification.save(flush:true)){
								println(notification.errors)
								result = ["response_code":"failure","response_msg":"Failed to save the notification"]
							}else{
								def parent = child?.parent
								parent.addToNotifications(notification)
								parent.save(flush:true)
								result = ["response_code":"success","response_msg":"Message saved and queued for delivery."]
							}
							
							render result as JSON
							return
						}
					}
				}
				
			} //end params
			
		}catch(Exception e){
			//println (e.printStackTrace())
		}
		
	
		render result as JSON
	}
	def smsdialogcreate() {
		def visit = Visit.get(params?.vid)	
		render (view:"/home/htown",model:[childInstance: Child.get(params?.cid), id:params?.cid,visitInstance:visit,templateInstanceList:Template.list()]) //new Child(params)
	}
} //end class
