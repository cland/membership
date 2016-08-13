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
	String debug
	String smsTestNumber
	String smsFrom
	Integer mincutoff	//the number of minutes at which point a visit is regarded as a full hour payable
	Integer minmodulo	//the value used to compute the modulo value in when computing the modulus minutes
	Integer reportminmonth 	//default months to go back to report on.
	boolean visitPhotoEnabled = false
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
		debug nullable:true
		smsTestNumber nullable:true
		smsFrom nullable:true, maxSize: 11
		mincutoff nullable:true
		minmodulo nullable:true
		reportminmonth nullable:true
    }
	def beforeInsert() {
		long curId = groupManagerService.getCurrentUserId()
		if(newchildcount == null) newchildcount = 3
		if(maxbooking == null) maxbooking = 12
		if(debug == null) debug = "0"
		if(smsTestNumber == null) smsTestNumber="+61411111111"
		if(smsFrom == null) smsFrom = "WigglyToesI" //Max length from API is 11 characters
		if(mincutoff == null) mincutoff = 12
		if(minmodulo == null) minmodulo = 60
		if(reportminmonth == null) reportminmonth = 1
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
