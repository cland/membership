package cland.membership.lookup

import cland.membership.security.Person
import java.util.Date;

import javax.management.modelmbean.RequiredModelMBean;
 
class Keywords {
	//transient cbcApiService
	transient groupManagerService
	String name
	String label
	String category
	String description
	long createdBy
	long lastUpdatedBy
	Date dateCreated
	Date lastUpdated
	Keywords keyword
	static belongsTo = [Keywords]
	static hasMany = [values:Keywords]
	static transients = ["createdByName","lastUpdatedByName"]
	static constraints = {
		name(unique:['keyword'])
		category(nullable:true)
		description(nullable:true) 
		label blank:true,nullable:true		
		lastUpdatedBy nullable:true, editable:false
		createdBy nullable:true, editable:false
	}
	static mapping = {
		sort name: "asc"
	}
	def beforeInsert = {
		long curId = groupManagerService.getCurrentUserId()
		createdBy = curId
		lastUpdatedBy = curId	
		if(label == "" | label == null) label = name
	}
	def beforeUpdate = {
		lastUpdatedBy = groupManagerService.getCurrentUserId()
		if(!label) label = name
	}
	def beforeDelete = {
		// your code goes here
	}
	def onLoad = {
		// your code goes here
	}

	String toString(){
		(label?label:name)
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