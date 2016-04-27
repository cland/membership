package cland.membership

import java.util.Date;

import cland.membership.lookup.Keywords;
import cland.membership.security.Person

class Parent {
	transient groupManagerService
	transient cbcApiService
	static attachmentable = true
	Person person1
	Person person2
	String membershipNo
	Keywords clientType
	String comments
	String relationship
	/** Admin Tracking Information **/
	long createdBy
	long lastUpdatedBy
	Date dateCreated
	Date lastUpdated
	String history
	static transients = ["createdByName","lastUpdatedByName"]
	static hasMany = [children:Child, contracts:Contract] 
    static constraints = {
		person2 nullable: true
		comments nullable: true
		membershipNo unique: true
		relationship nullable:true
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
			person1:person1.toMap(),
			person2:person2,
			membershipno:membershipNo,
			clienttype:clientType,
			comments:comments,
			relationship:relationship,
			childlist:children*.toMap(),
			createdbyname:getCreatedByName(),
			lastupdatedbyname:getLastUpdatedByName()]
	}
	def toAutoCompleteMap(){
		return [id:id,
		label:person1.toString() + " (" + relationship + ") | " + person1?.email,
		value:id,
		contactno:person1?.mobileNo,
		childlist:children*.toMap(),
		office:[name: person1?.office?.name,id:person1?.office?.id],
		category:(relationship != "" ? relationship : "Client")]
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
		return person1.toString()
	}
} //end class
