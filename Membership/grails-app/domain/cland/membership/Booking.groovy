package cland.membership

import java.util.Date;

import org.joda.time.DateTime

import cland.membership.security.Person

class Booking {
	transient groupManagerService
	transient cbcApiService
	static attachmentable = true
	Person person
	Child birthdayChild
	DateTime bookingDate
	Integer numKids
	Integer numAdults
	String comments
	String bookingType
	/** Admin Tracking Information **/
	long createdBy
	long lastUpdatedBy
	Date dateCreated
	Date lastUpdated
	String history
	static transients = ["createdByName","lastUpdatedByName"]
    static constraints = {
		numKids nullable: true
		numAdults nullable: true
		lastUpdatedBy nullable:true, editable:false
		createdBy nullable:true, editable:false
		history nullable:true,editable:false		
    }
	def beforeInsert = {
		long curId = groupManagerService.getCurrentUserId()
		createdBy = curId
		lastUpdatedBy = curId
	}
	def beforeUpdate = {
		lastUpdatedBy = groupManagerService.getCurrentUserId()
	}
	/**
	 * To ensure that all attachments are removed when the "owner" domain is deleted.
	 */
	transient def beforeDelete = {
		withNewSession{
		  removeAttachments()
		}
	 }
	def onLoad = {
		// your code goes here
	}
	def toMap(){
		return [id:id,
			person:person.toMap(),
			birthdaychild:birthdayChild.toMap(),
			bookingdate:bookingDate,
			numkids:numKids,
			numadults:numAdults,
			comments:comments,
			createdbyname:getCreatedByName(),
			lastupdatedbyname:getLastUpdatedByName()]
	}
	def toAutoCompleteMap(){
		return [id:id,
		label:person.toString() + " (" + bookingDate?.format("dd-MMM-yyyy HH:mm") + ") | " + person?.mobileNo + " | " + person?.email,
		value:id,
		office:person?.office,
		category:"Booking"]
	}
	String getCreatedByName(){
		Person user = Person.get(createdBy)
		return (user==null?"unknown":user?.toString())
	}
	String getLastUpdatedByName(){
		Person user = Person.get(lastUpdatedBy)
		return (user==null?"unknown":user?.toString())
	}
}//end class
