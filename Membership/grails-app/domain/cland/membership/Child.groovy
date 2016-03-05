package cland.membership

class Child {
	Person person
	static hasMany = [visits:Visit]
	static belongsTo = [parent:Parent]
    static constraints = {
    }
}
