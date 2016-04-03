package cland.membership

import cland.membership.security.Person
import java.util.Date;

class Settings {
	transient groupManagerService
	String name
	String title
	String subtitle
	String description
	Integer visitcount	//The number of visits that allows for discount
	Integer notifytime	//minutes left to trigger notification
	String timereminder //message template to be send to the parent for time remaining
	String sickchild 	//message related to injury/sickness
	String problemchild //message related to problem with a child
	long createdBy
	long lastUpdatedBy
	Date dateCreated
	Date lastUpdated
    static constraints = {
		description nullable:true
		visitcount nullable:true
		notifytime nullable:true
		timereminder nullable:true
		sickchild nullable:true
		problemchild nullable:true
		lastUpdatedBy nullable:true, editable:false
		createdBy nullable:true, editable:false
    }
	def beforeInsert() {
		long curId = groupManagerService.getCurrentUserId()
		createdBy = curId
		lastUpdatedBy = curId		
	}

	def beforeUpdate() {
		lastUpdatedBy = groupManagerService.getCurrentUserId()
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
