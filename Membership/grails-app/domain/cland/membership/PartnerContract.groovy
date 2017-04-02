package cland.membership
import java.util.Date

import cland.membership.lookup.Keywords;
import cland.membership.security.Person

class PartnerContract {

	transient groupManagerService
	transient cbcApiService
	static attachmentable = true
	/** Admin Tracking Information **/
	long createdBy
	long lastUpdatedBy
	Date dateCreated
	Date lastUpdated
	String history
	String comments
	
	Parent parent
	Partner partner
	String membershipNo
	boolean isUserVerified
	boolean isValidPartnerMember
	Date dateRegistered
	String contractNo
	
	static transients = ["createdByName","lastUpdatedByName"]
    static constraints = {
		lastUpdatedBy nullable:true, editable:false
		createdBy nullable:true, editable:false
		history nullable:true,editable:false
		comments nullable: true
		contractNo unique:true
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
			clientname:parent?.toString(),
			contractno:contractNo,
			membershipno:membershipNo,
			isuserverified:isUserVerified,
			isvalidmember:isValidPartnerMember,
			createdbyname:getCreatedByName(),
			lastupdatedbyname:getLastUpdatedByName()]
	}
	def toAutoCompleteMap(){
		return [id:id,
		label: parent?.toString() + " (" + membershipNo + ")",
		value:contractNo,
		membershipno:membershipNo,
		isvalidmember:isValidPartnerMember,
		isuserverified:isUserVerified,
		category:"Partner Contract"]
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
