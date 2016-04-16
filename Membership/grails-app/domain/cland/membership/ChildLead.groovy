package cland.membership

import java.util.Date;

import cland.membership.lookup.Keywords
import cland.membership.security.Person

/**
 * Used ONLY for capturing the extra children invited to a booking/birthday
 * @author Tagumi
 *
 */
class ChildLead {
	transient cbcApiService
	transient springSecurityService
	transient groupManagerService
	
	String firstName
	String lastName
	String email
	String gender
	String mobileNo
	String telNo
	Date dateOfBirth
	Keywords status  // ([AttendanceStatus] Attended/Pending/Cancelled)

	long createdBy
	long lastUpdatedBy
	Date dateCreated
	Date lastUpdated
	static transients = ["createdByName","lastUpdatedByName"]

    static constraints = {
		status nullable: true
		lastUpdatedBy nullable:true, editable:false
		createdBy nullable:true, editable:false
		firstName blank: false,nullable: false
		lastName blank: false,nullable: true
		email nullable: true
		gender inList: Gender.list(), nullable: true
		dateOfBirth blank:true, nullable:true		
		telNo nullable:true
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
			firstname:firstName,
			lastName:lastName,
			email:email,
			mobileno: (mobileNo != null?mobileNo:telNo),
			gender:gender,
			age:getAge(),
			status:status?.toMap(),
			lastupdatedbyname:getLastUpdatedByName(),
			params:params]
	}
	def toAutoCompleteMap(){
		return [id:id,
		label:firstName + " " + lastName,
		value:id,
		Child:(this==null?ChildLead.get(id):this),
		category:(status==null?"Unknown":status)]
	}
	String toString(){
		return firstName + " " + lastName
	}
	String getCreatedByName(){
		Person user = Person.get(createdBy)
		return (user==null?"unknown":user?.toString())
	}
	String getLastUpdatedByName(){
		Person user = Person.get(lastUpdatedBy)
		return (user==null?"unknown":user?.toString())
	}
	public getAge(){
		if(dateOfBirth == null){
			return 0
		}
		def now = new GregorianCalendar()
		Integer birthMonth = dateOfBirth.getAt(Calendar.MONTH)
		Integer birthYear = dateOfBirth.getAt(Calendar.YEAR)
		Integer birthDate = dateOfBirth.getAt(Calendar.DATE)
		Integer yearNow = now.get(Calendar.YEAR)

		def offset = new GregorianCalendar(
				yearNow,
				birthMonth-1,
				birthDate)
		return (yearNow - birthYear - (offset > now ? 1 : 0))
	}
}//end class
