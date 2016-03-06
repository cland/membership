package cland.membership.security

import cland.membership.Race
import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString

@EqualsAndHashCode(includes='username')
@ToString(includes='username', includeNames=true, includePackage=false)
class Person implements Serializable {
	/** FROM SPRING SECURITY **/
	private static final long serialVersionUID = 1
	transient springSecurityService
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
	String gender
	Race race
	//List phones
	
	static constraints = {
		/*username blank: false, unique: true
		password blank: false
		firstName blank: false*/
		username nullable: false, unique: true
		 password nullable: false
		 firstName nullable: false
		race nullable: true
		accountExpired nullable: true
		knownAs nullable: true
		title nullable: true
		email nullable: true
		gender nullable: true
		lastName nullable: true
		accountExpired nullable: true
		accountLocked nullable: true
		passwordExpired nullable: true
		//springSecurityService nullable: true
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
	}

	def beforeUpdate() {
		if (isDirty('password')) {
			encodePassword()
		}
	}

	protected void encodePassword() {
		password = springSecurityService?.passwordEncoder ? springSecurityService.encodePassword(password) : password
	}

	static transients = ['springSecurityService']

	static mapping = {
		password column: '`password`'
	}
}
