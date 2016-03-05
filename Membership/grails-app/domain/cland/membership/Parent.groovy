package cland.membership

class Parent {
	Person person1
	Person person2
	Date date
	static hasMany = [children:Child] 
    static constraints = {
    }
}
