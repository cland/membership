package cland.membership

import java.util.Date;

import org.joda.time.DateTime

import cland.membership.lookup.Keywords
import cland.membership.security.Person

class Booking {
	transient groupManagerService
	transient cbcApiService
	static attachmentable = true
	//Person person
	Parent parent
	Child birthdayChild
	Date bookingDate
		
	Integer numKids
	Integer numAdults
	String comments
	
	Keywords timeslot  		// [PartyTimeSlots] 10:00 - 11:30  |  11:30 - 13:00 | 13:00 - 14:30
	Keywords bookingType  	// [BookingType]	birthday | group
	Keywords room			// [Room]			red | yellow
	Keywords partyPackage 	// [PartyPackage]	STANDARD | Wiggly Party
	Keywords partyTheme		// [PartyTheme]		Fairy | Children's Jungle | Happy Birthday | Princess | Under The Sea
	
	/** Admin Tracking Information **/
	long createdBy
	long lastUpdatedBy
	Date dateCreated
	Date lastUpdated
	String history
	static transients = ["createdByName","lastUpdatedByName"]
	static hasMany = [children:ChildLead]
    static constraints = {
		numKids nullable: true
		numAdults nullable: true
		lastUpdatedBy nullable:true, editable:false
		createdBy nullable:true, editable:false
		history nullable:true,editable:false	
		partyPackage nullable:true
		partyTheme nullable:true
		comments nullable:true	
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
			parent:parent.toMap(),
			birthdaychild:birthdayChild.toMap(),
			bookingdate:bookingDate,
			timeslot:timeslot?.toMap(),
			numkids:numKids,
			numadults:numAdults,
			comments:comments,
			children:children*.toMap(),
			bookingtype:bookingType?.toMap(),
			room:room?.toMap(),
			theme:partyTheme?.toMap(),
			partypackage: partyPackage?.toMap(),
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
