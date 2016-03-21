package cland.membership

import cland.membership.security.Person

class Booking {
	Person person
	Integer numKids
	Integer numAduls
	// date start-time, end-time
    static constraints = {
		numKids nullable: true
		numAduls nullable: true
    }
}
