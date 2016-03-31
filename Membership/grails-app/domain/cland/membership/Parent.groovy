package cland.membership

import cland.membership.security.Person

class Parent {
	Person person1
	Person person2
	String membershipNo
	String clientType
	String comments
	String relationship
	static hasMany = [children:Child] 
    static constraints = {
		person2 nullable: true
		comments nullable: true
		membershipNo unique: true
		relationship nullable:true
    }
}
