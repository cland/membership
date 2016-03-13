package cland.membership

class Settings {
	String name
	String title
	String subtitle
	String description
	Integer visitcount	//The number of visits that allows for discount
	Integer notifytime	//minutes left to trigger notification
	String timereminder //message template to be send to the parent for time remaining
	String sickchild 	//message related to injury/sickness
	String problemchild //message related to problem with a child
	 
    static constraints = {
		description nullable:true
		visitcount nullable:true
		notifytime nullable:true
		timereminder nullable:true
		sickchild nullable:true
		problemchild nullable:true
    }
}
