package cland.membership

import java.util.Date;

import cland.membership.security.Person

class Child {
	transient cbcApiService
	transient springSecurityService
	transient groupManagerService
	
	Person person
	BigInteger accessNumber
	String comments
	String medicalComments
	
	long createdBy
	long lastUpdatedBy
	Date dateCreated
	Date lastUpdated
	static transients = ['visitCount',"createdByName","lastUpdatedByName"]
	static hasMany = [visits:Visit]
	static belongsTo = [parent:Parent]
    static constraints = {
		accessNumber unique: true
		comments nullable: true
		medicalComments nullable: true
		lastUpdatedBy nullable:true, editable:false
		createdBy nullable:true, editable:false
    }
	def beforeInsert() {
		long curId = groupManagerService.getCurrentUserId()
		createdBy = curId
		lastUpdatedBy = curId
	}

	def beforeUpdate() {
		lastUpdatedBy = groupManagerService.getCurrentUserId()
	}
	def toMap(params = null){
		return [id:id,
			parent:parent,
			person:person,
			accessnumber:accessNumber,
			comments:comments,
			medicalcomments:medicalComments,
			visits:visits,
			lastupdatedbyname:getLastUpdatedByName(),
			params:params]
	}
	def toAutoCompleteMap(){
		return [id:id,
		label:person?.toString() + " Visits: " + visits?.size(),
		value:id,
		Child:(this==null?Child.get(id):this),
		category:(accessNumber==null?"Unknown":accessNumber)]
	}
	String toString(){
		return person?.toString()
	}
	String getCreatedByName(){
		Person user = Person.get(createdBy)
		return (user==null?"unknown":user?.toString())
	}
	String getLastUpdatedByName(){
		Person user = Person.get(lastUpdatedBy)
		return (user==null?"unknown":user?.toString())
	}
	Integer getVisitCount(){
		return visits?.size()
	}
}//end class
