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
			child:child?.toMap(),
			date:starttime?.toDate()?.format("dd-MMM-yyyy"),
			starttime:starttime,
			endtime:endtime,
			status:status,
			createdbyname:getCreatedByName(),
			lastupdatedbyname:getLastUpdatedByName(),
			params:params]
	}
	def toAutoCompleteMap(){		
		return [id:id,
		label:visitDate?.format("dd-MMM-yyyy") + " " + starttime + " to " + endtime + " | " + status,
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
