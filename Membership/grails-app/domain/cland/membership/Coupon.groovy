package cland.membership

import cland.membership.security.Person
import java.util.Date;

import org.joda.time.DateTime

class Coupon {

	transient springSecurityService
	transient groupManagerService
	
	Integer maxvisits //hrs
	Date startDate
	Date expiryDate
	String refNo
	long createdBy
	long lastUpdatedBy
	Date dateCreated
	Date lastUpdated
	static transients = ["createdByName","lastUpdatedByName","visitsLeft"]
	static hasMany = [visits:Visit]
	static belongsTo = [parent:Parent]
	
    static constraints = {
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
			title:"Coupon ${refNo} [${startDate}]",			
			refno:refNo,
			startdate:startDate,
			expirydate:expiryDate,
			visits:visits*.toMap(),
			balance:getVisitsLeft(),
			createdbyname:getCreatedByName(),
			lastupdatedbyname:getLastUpdatedByName(),
			params:params]
	}
	def toAutoCompleteMap(){		
		return [id:id,
		label:"Coupon ${refNo} [${startDate}]",
		value:id,
		category:(refNo==null?"Unknown":"Coupon")]
	}
	String toString(){
		return "Coupon ${refNo} [${startDate}]"
	}
	Long getVisitsLeft(){
		def completevisits = visits?.findAll{it.isCompleted == true}
		
		if(completevisits){			
			return maxvisits - (completevisits*.totalMinutes?.sum()/60)
		}
		
		return maxvisits
	}
	Long getVisitsLeft(Integer cutoffMinutes,Integer modulo){
		def completevisits = visits?.findAll{it.isCompleted == true}
		
		if(completevisits){
			Integer total_min = completevisits*.totalMinutes?.sum()
			Integer hrs = (total_min/modulo)
			Integer mod = total_min % modulo
			if(mod >= cutoffMinutes) hrs++
			return maxvisits - hrs
		}
		return maxvisits
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

