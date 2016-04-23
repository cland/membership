package cland.membership

import cland.membership.security.Person
import java.util.Date;

class Contract {
	transient groupManagerService
	transient cbcApiService
	String contractNo
	String status
	/** Admin Tracking Information **/
	long createdBy
	long lastUpdatedBy
	Date dateCreated
	Date lastUpdated
	static transients = ["createdByName","lastUpdatedByName"]
	static belongsTo = [parent:Parent]
    static constraints = {
		lastUpdatedBy nullable:true, editable:false
		createdBy nullable:true, editable:false
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
	String getCreatedByName(){
		Person user = Person.get(createdBy)
		return (user==null?"unknown":user?.toString())
	}
	String getLastUpdatedByName(){
		Person user = Person.get(lastUpdatedBy)
		return (user==null?"unknown":user?.toString())
	}
	String toString(){
		return contractNo
	}
} //end class
