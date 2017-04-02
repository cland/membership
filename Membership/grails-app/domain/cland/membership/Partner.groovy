package cland.membership

import java.util.Date
import cland.membership.lookup.Keywords;
import cland.membership.security.Person

class Partner {
	transient groupManagerService
	transient cbcApiService
	static attachmentable = true
	/** Admin Tracking Information **/
	long createdBy
	long lastUpdatedBy
	Date dateCreated
	Date lastUpdated
	String history
	
	String name
	Double rate
	String contactNo
	String partnerCode //unique key
	String comments
	Keywords partnerIndustry
	
	static transients = ["createdByName","lastUpdatedByName"]
	
    static constraints = {
		partnerCode unique:true
		lastUpdatedBy nullable:true, editable:false
		createdBy nullable:true, editable:false
		history nullable:true,editable:false
		comments nullable: true
		partnerIndustry nullable:true
    }
	static mapping = {
		message type : 'text'
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
			name:name,
			partnercode:partnerCode,
			comments:comments,
			industry:partnerIndustry?.toString(),
			contactno:contactNo,
			createdbyname:getCreatedByName(),
			lastupdatedbyname:getLastUpdatedByName()]
	}
	def toAutoCompleteMap(){
		return [id:id,
		label: name + " (" + partnerCode + ")",
		value:partnerCode,
		id:id,
		industryName:partnerIndustry?.toString(),
		industryId:partnerIndustry?.id,
		category:(partnerIndustry != null ? partnerIndustry?.toString() : "Partner")]
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
		return name
	}
} //end class
