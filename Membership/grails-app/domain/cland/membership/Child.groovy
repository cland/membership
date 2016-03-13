package cland.membership

import cland.membership.security.Person

class Child {
	Person person
	BigInteger accessNumber
	String comments
	String medicalComments
	
	static hasMany = [visits:Visit]
	static belongsTo = [parent:Parent]
    static constraints = {
		accessNumber unique: true
		comments nullable: true
		medicalComments nullable: true
    }
}
