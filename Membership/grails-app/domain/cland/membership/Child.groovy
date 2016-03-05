package cland.membership

import cland.membership.security.Person

class Child {
	Person person
	static hasMany = [visits:Visit]
	static belongsTo = [parent:Parent]
    static constraints = {
    }
}
