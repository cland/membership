package cland.membership

import cland.membership.lookup.Keywords
import cland.membership.security.*
import java.util.Date;
import java.util.List;

class Organisation {
	transient cbcApiService
	static attachmentable = true
	String name
	String status
	String phoneNo
	String email
	
	boolean isMember
	boolean isHost
	boolean isLabourBroker
	Integer staffCount
	long createdBy
	long lastUpdatedBy
	Date dateCreated
	Date lastUpdated
	static transients = ['adviceOfficeList',"createdByName","lastUpdatedByName"]
	static hasMany = [staff:Person,sector:Keywords]
	
    static constraints = {
		name unique:true, blank:false
		status blank:false, inList:["Active", "Inactive"]
		phoneNo nullable:true, blank:true, matches: "[0-9 ]*"
		email nullable:true, email:true
		lastUpdatedBy nullable:true, editable:false
		createdBy nullable:true, editable:false
		email nullable:true,email:true
    }
	def beforeInsert = {
		uniqueHost()
		createdBy = cbcApiService.getCurrentUserId()
	}
	def beforeUpdate = {
		uniqueHost()
		lastUpdatedBy = cbcApiService.getCurrentUserId()
	}
	def uniqueHost(){
		
		def orgs = Organisation.findAll{isHost==true}
		if(orgs.size()> 0) {
			isHost = false
		}
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
	String toString(){
		return name 
	}
	def toMap(params=null){
		return [id:id,
			datecreated:dateCreated?.format("dd-MMM-yyyy"),
			createdby:getCreatedByName(),
			datelastupdated:lastUpdated?.format("dd-MMM-yyyy"),
			lastupdatedby:getLastUpdatedByName(),
			params:params]
	}
	def toAutoCompleteMap(){
		return [id:id,
		label:name + " | " + phoneNo + " | " + email + " | " + status, 
		value:id,
		org:this,
		category:(isMember?"Member":"Non-Member")]
	}
	List getAdviceOfficeList(){
		//List of offices affiliated with this organisation
		def list = Office.createCriteria().list(){
			createAlias('affiliates',"a")
			eq('a.id',id)
		}
		
		return list
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
