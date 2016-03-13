package cland.membership

import cland.membership.security.Person

class Parent {
	Person person1
	Person person2
	static hasMany = [children:Child] 
    static constraints = {
		person2 nullable: true
    }
}
