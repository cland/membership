package cland.membership.lookup

import java.util.Date;

import javax.management.modelmbean.RequiredModelMBean;

class Keywords {
	transient cbcApiService
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
		createdBy = cbcApiService.getCurrentUserId()
		if(label == "" | label == null) label = name
	}
	def beforeUpdate = {
		lastUpdatedBy = cbcApiService.getCurrentUserId()
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
} //end class