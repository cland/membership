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
	Integer bookingDuration
	String referenceNo
	Office office
	String comments
	String status		// new / in-progress / done / cancelled
	
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
		bookingDuration min:1, max:5
		status nullable:true
    }
	static mapping = {
		comments type : 'text'
	}
	def beforeInsert = {
		long curId = groupManagerService.getCurrentUserId()
		createdBy = curId
		lastUpdatedBy = curId
		status = "new"
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
			parentid:parent.id,
			parentname: parent.toString(),			
			bookingdate:bookingDate?.format("dd-MMM-yyyy HH:mm"),
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
