package cland.membership

import cland.membership.security.Person

class Parent {
	Person person1
	Person person2
	Date date
	static hasMany = [children:Child] 
    static constraints = {
    }
}
