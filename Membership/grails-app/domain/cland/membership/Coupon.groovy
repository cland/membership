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
	Office office
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
		office nullable:true
    }
	static mapping = {
		visits lazy:false
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
			startdate:startDate?.format("dd MMM yyyy"),
			expirydate:expiryDate?.format("dd MMM yyyy"),
			visits:visits*.toMap(),
			visitcount:visits?.size(),
			balance:getVisitsLeft(),
			maxvisits:maxvisits,
			createdbyname:getCreatedByName(),
			lastupdatedbyname:getLastUpdatedByName(),
			parentname:parent?.person1?.fullname,
			membershipno:parent?.membershipNo,
			params:params]
	}
	def toReportMap(){
		[id:id,
			refno:refNo,
			startdate:startDate?.format("dd MMM yyyy"),
			expirydate:expiryDate?.format("dd MMM yyyy"),
			visitcount:visits?.size(),
			balance:getVisitsLeft(),
			maxvisits:maxvisits,
			parentname:parent?.person1?.fullname,
			membershipno:parent?.membershipNo]
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
		Settings settingsInstance = Settings.list().first()		
		return getVisitsLeft(settingsInstance?.mincutoff,settingsInstance?.minmodulo)
	}
	Long getVisitsLeft(Integer cutoffMinutes,Integer modulo){
		if(cutoffMinutes == null) cutoffMinutes = 12
		if(modulo == null) modulo = 60
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

