package cland.membership

import cland.membership.security.Person

class Parent {
	Person person1
	Person person2
	BigInteger membershipNo
	String clientType
	String comments
	static hasMany = [children:Child] 
    static constraints = {
		person2 nullable: true
		clientType inList: ["Standard","Member"]
		comments nullable: true
		membershipNo unique: true
    }
}
