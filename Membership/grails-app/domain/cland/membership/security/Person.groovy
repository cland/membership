package cland.membership.security

import java.util.Date;
import java.util.Set;

import cland.membership.*
import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString
import cland.membership.lookup.*
//import org.apache.commons.collections.list.LazyList;
//import org.apache.commons.collections.FactoryUtils;

@EqualsAndHashCode(includes='username')
@ToString(includes='username', includeNames=true, includePackage=false)
class Person implements Serializable {
	transient cbcApiService
	transient springSecurityService
	def groupManagerService
	static attachmentable = true
	/** FROM SPRING SECURITY **/
	private static final long serialVersionUID = 1
	String username
	String password
	boolean enabled = true
	boolean accountExpired
	boolean accountLocked
	boolean passwordExpired
	
	/** CUSTOM FIELDS **/
	String firstName
	String lastName
	String knownAs
	String title
	String email
	Keywords gender
	Race race
	String idNumber
	String mobileNo
	String telNo
	Date dateOfBirth
	Integer birthweek
	Integer birthmonth
	Integer birthyear
	Integer birthday
	Integer birthdayofyear
	//List phones
	/** Admin Tracking Information **/
	long createdBy
	long lastUpdatedBy
	Date dateCreated
	Date lastUpdated
	String history
	static belongsTo = [office:Office]
	static transients = ['springSecurityService','authorities',"createdByName","lastUpdatedByName","fullname",
		'age','staffMemberStatus','profilePhotoId']
	//static hasMany = [phones:Phone]
	static constraints = {		
		username blank: false,nullable: false, unique: true
		password blank: false,nullable: false
		firstName blank: false,nullable: false
		lastName blank: false,nullable: true
		race nullable: true
		accountExpired nullable: true
		knownAs nullable: true
		title nullable: true
		email nullable: true
		gender nullable: true		
		accountExpired nullable: true
		accountLocked nullable: true
		passwordExpired nullable: true
		idNumber  blank:true, nullable:true
		dateOfBirth blank:true, nullable:true
		lastUpdatedBy nullable:true, editable:false
		createdBy nullable:true, editable:false
		history nullable:true,editable:false
		telNo nullable:true
	}
	static mapping = {
		
		birthday formula:'DAYOFMONTH(date_of_birth)'
		birthweek formula: 'WEEK(date_of_birth)'
		birthmonth formula: 'MONTH(date_of_birth)'
		birthyear formula: 'YEAR(date_of_birth)'
		birthdayofyear formula:'DAYOFYEAR(date_of_birth)'	
		
		password column: '`password`'
		//phones cascade:"all-delete-orphan"
		office lazy: false
		dateOfBirth defaultValue: "now()"
		
	}
	Person(String username, String password) {
		this()
		this.username = username
		this.password = password
	}

	Set<RoleGroup> getAuthorities() {
		PersonRoleGroup.findAllByPerson(this)*.roleGroup
	}

	def beforeInsert() {
		encodePassword()
		long curId = groupManagerService.getCurrentUserId()
		createdBy = curId
		lastUpdatedBy = curId
		if(idNumber == null || idNumber?.equals("")){
			idNumber = cbcApiService.generateIdNumber(dateOfBirth,5)
		}
	}

	def beforeUpdate() {
		if (isDirty('password')) {
			encodePassword()
		}
		lastUpdatedBy = groupManagerService.getCurrentUserId()
	}

	protected void encodePassword() {
		password = springSecurityService?.passwordEncoder ? springSecurityService.encodePassword(password) : password
	}


	
	String toString(){
		return firstName + " " + lastName
	}
	String getFullname(){
		return this.toString()
	}
	String getCreatedByName(){
		Person user = Person.get(createdBy)
		return (user==null?"unknown":user?.toString())
	}
	String getLastUpdatedByName(){
		Person user = Person.get(lastUpdatedBy)
		return (user==null?"unknown":user?.toString())
	}
	String getRoles(){
		Set<RoleGroup> grps = getAuthorities() //getUserGroups(user)
		List<Role>rolelist = []
		grps.each{grp ->
			Set<Role> roles = grp.getAuthorities() //RoleGroupRole.findAllByRoleGroup(grp)
			rolelist.addAll(roles.iterator().toList())
		}
		return rolelist?.unique()?.iterator().join(",")
	}
	def toMap(params = null){
		return [id:id,
			firstname:firstName,
			lastname:lastName,
			fullname:fullname,
			username:username,
			email:email,
			mobileno: mobileNo,
			enabled:enabled,
			gender:(gender==null?"":gender),
			idnum:(idNumber==null?"":idNumber),
			age:getAge(),
			datecreated:dateCreated?.format("dd-MMM-yyyy"),
			datelastupdated:lastUpdated?.format("dd-MMM-yyyy"),
			createdbyname:getCreatedByName(),
			lastupdatedbyname:getLastUpdatedByName(),
			birthdate:dateOfBirth?.format("dd-MMM"),
			birthyear:dateOfBirth?.format("yyyy"),
			numbirthmonth:birthmonth,
			numbirthday :birthday,
			isstaff:staffMemberStatus,
			photoid:getProfilePhotoId(),
			params:params]
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
	def toAutoCompleteMap(){
		Office office = null //getPrimaryOffice()
		return [id:id,
		label:firstName + " " + lastName + " | " + idNumber + " | " + dateOfBirth?.format("dd MMM yyyy"),
		value:id,
		person:(this==null?Person.get(id):this),
		category:(gender==null?"Unknown":gender),
		usergroups:getAuthorities(),
		officegroups:(office==null?null:office.getOfficeGroups())]
	}
	def getStaffMemberStatus(){
		return groupManagerService.isStaff(office,this) //  office?.staff?.contains(this)
	}
	/*
	def getPhonesList() {
		return LazyList.decorate(
		phones,
		FactoryUtils.instantiateFactory(Phone.class))
	}
	*/
	/**
	 * To ensure that all attachments are removed when the "owner" domain is deleted.
	 */
	transient def beforeDelete = {
		withNewSession{
		  removeAttachments()
		}
	 }
	Long getProfilePhotoId(String key=null){
		Long pid = null
		if(this.attachments?.size() > 0){
			def tmp = this.attachments[0]
			pid = tmp?.id
		}
		return pid
	}
} //end class
