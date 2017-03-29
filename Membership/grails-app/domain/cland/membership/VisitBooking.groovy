package cland.membership
import java.util.Date;

import org.joda.time.DateTime

import cland.membership.lookup.Keywords
import cland.membership.security.Person
class VisitBooking {
	transient groupManagerService
	transient cbcApiService
	static attachmentable = true
	//Person person
	Parent parent
	Date bookingDate
	String referenceNo
	Office office
	String comments
	
	/** Admin Tracking Information **/
	long createdBy
	long lastUpdatedBy
	Date dateCreated
	Date lastUpdated
	String history
	static transients = ["createdByName","lastUpdatedByName"]
	static hasMany = [children:Child]
    static constraints = {
		lastUpdatedBy nullable:true, editable:false
		createdBy nullable:true, editable:false
		history nullable:true,editable:false		
		comments nullable:true
		office nullable:true
		referenceNo unique:true
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
			bookingdate:bookingDate,
			referenceno:referenceNo,
			comments:comments,
			children:children*.toMap(),
			createdbyname:getCreatedByName(),
			lastupdatedbyname:getLastUpdatedByName()]
	}
	def toAutoCompleteMap(){
		return [id:id,
		label:parent?.toString() + " (" + bookingDate?.format("dd-MMM-yyyy HH:mm") + ") | " + referenceNo,
		value:id,
		office:office,
		category:"Visit Booking"]
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
