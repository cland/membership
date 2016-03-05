package cland.membership

class Parent {
	Person person1
	Person person2
	
	static hasMany = [children:Child] 
    static constraints = {
    }
}
