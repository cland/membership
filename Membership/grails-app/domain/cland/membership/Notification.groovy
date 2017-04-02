package cland.membership

import cland.membership.security.Person
import java.util.Date;

import org.joda.time.DateTime

class Notification {
	transient cbcApiService
	transient springSecurityService
	transient groupManagerService
	Child child
	Visit visit
	Template template
	
	String responseCode
	String responseMsg
	String sendTo	
	String body
	Double totalPrice
	Integer totalCount
	Integer queuedCount
	Office office
	long createdBy
	long lastUpdatedBy
	Date dateCreated
	Date lastUpdated
	static transients = ["createdByName","lastUpdatedByName"]
    static constraints = {
		lastUpdatedBy nullable:true, editable:false
		createdBy nullable:true, editable:false		
		office nullable:true
    }
	static mapping = {
		body type : 'text'
	}
	def beforeInsert() {
		long curId = groupManagerService.getCurrentUserId()
		createdBy = curId
		lastUpdatedBy = curId			
	}

	def beforeUpdate() {
		lastUpdatedBy = groupManagerService.getCurrentUserId()
	}
	def toMap(params = null){
		return [id:id,
			title:"Notification sent to ${sendTo} [${child?.person}]",			
			body:body,
			status:responseCode,
			visitid:visit?.id,
			parentid:child?.parent?.id,
			createdbyname:getCreatedByName(),
			lastupdatedbyname:getLastUpdatedByName(),
			params:params]
	}
	def toAutoCompleteMap(){		
		return [id:id,
		label:"Notification sent to ${sendTo} [${child?.person}]",
		value:id,
		category:(responseCode==null?"Unknown":responseCode)]
	}
	String toString(){
		return "Notification sent to ${sendTo}"
	}
	String getCreatedByName(){
		Person user = Person.get(createdBy)
		return (user==null?"unknown":user?.toString())
	}
	String getLastUpdatedByName(){
		Person user = Person.get(lastUpdatedBy)
		return (user==null?"unknown":user?.toString())
	}
} //end class

