package cland.membership

import cland.membership.security.Person
import java.util.Date;

import org.joda.time.DateTime

class Template {
	transient cbcApiService
	transient springSecurityService
	transient groupManagerService
	//Date visitDate
	String title
	String body
	String status
	long createdBy
	long lastUpdatedBy
	Date dateCreated
	Date lastUpdated
	static transients = ["createdByName","lastUpdatedByName"]
    static constraints = {
		lastUpdatedBy nullable:true, editable:false
		createdBy nullable:true, editable:false		
		status blank:true, nullable:true
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
			title:title,			
			body:body,
			status:status,
			createdbyname:getCreatedByName(),
			lastupdatedbyname:getLastUpdatedByName(),
			params:params]
	}
	def toAutoCompleteMap(){		
		return [id:id,
		label:title,
		value:id,
		category:(status==null?"Unknown":status)]
	}
	String toString(){
		return title
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

