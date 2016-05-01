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
	Integer notifytime	//minutes after which warning indicator appears
	Integer donetime	//minutes when standard time is up
	Integer newchildcount //when adding children inline, the default number of fields to display
	Integer maxbooking //maximum number of kids to be included in a book
	long createdBy
	long lastUpdatedBy
	Date dateCreated
	Date lastUpdated
    static constraints = {
		description nullable:true
		visitcount nullable:true
		notifytime nullable:true
		donetime nullable:true		
		newchildcount nullable:true
		maxbooking nullable:true
		lastUpdatedBy nullable:true, editable:false
		createdBy nullable:true, editable:false
    }
	def beforeInsert() {
		long curId = groupManagerService.getCurrentUserId()
		if(newchildcount == null) newchildcount = 3
		if(maxbooking == null) maxbooking = 12
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
