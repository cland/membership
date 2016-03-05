package cland.membership

import cland.membership.lookup.Keywords

class Person {
	String firstName
	String lastName
	String knownAs
	String title
	String email

	Date dateOfBirth
	String idNumber
	Keywords maritalStatus
	//Office office
	/** Tab2: Person Profile **/
	String gender
	Race race
    static constraints = {
    }
}
