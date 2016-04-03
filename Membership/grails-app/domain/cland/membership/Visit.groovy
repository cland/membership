package cland.membership

import cland.membership.security.Person
import java.util.Date;

import org.joda.time.DateTime

class Visit {
	transient cbcApiService
	transient springSecurityService
	transient groupManagerService
	//Date visitDate
	Date starttime
	Date endtime
	Date timerCheckPoint
	String status
	static belongsTo = [child:Child]
	long createdBy
	long lastUpdatedBy
	Date dateCreated
	Date lastUpdated
	static transients = ["createdByName","lastUpdatedByName"]
    static constraints = {
		lastUpdatedBy nullable:true, editable:false
		createdBy nullable:true, editable:false
		endtime nullable:true
    }
	def beforeInsert() {
		long curId = groupManagerService.getCurrentUserId()
		createdBy = curId
		lastUpdatedBy = curId	
		timerCheckPoint = starttime	
	}

	def beforeUpdate() {
		lastUpdatedBy = groupManagerService.getCurrentUserId()
	}
	def toMap(params = null){
		return [id:id,
			child:[id:child.id,
				person:child?.person?.toMap(),
				accessno:child?.accessNumber,
				comments:child?.comments,
				medical:child?.medicalComments,
				parent:[
					person1:child?.parent?.person1?.toMap(),
					person2:child?.parent?.person2?.toMap(),
					membershipno:child?.parent?.membershipNo,
					clienttype:child?.parent?.clientType,
					comments:child?.parent?.comments,
					relationship:child?.parent?.relationship
					]
				],			
			date:starttime?.format("dd MMM yyyy"),
			starttime:starttime?.format("dd MMM yyyy HH:mm"),
			endtime:endtime?.format("dd MMM yyyy HH:mm"),
			status:status,
			createdbyname:getCreatedByName(),
			lastupdatedbyname:getLastUpdatedByName(),
			params:params]
	}
	def toAutoCompleteMap(){		
		return [id:id,
		label:starttime?.format("dd-MMM-yyyy") + " " + starttime?.format("HH:mm") + " to " + endtime?.format("HH:mm") + " | " + status,
		value:id,
		child:(this==null?Child.get(id):this),
		category:(status==null?"Unknown":status)]
	}
	String toString(){
		return starttime + " - " + endtime
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
