package cland.membership

class Website {
	String sitename		//tagumisolutions.com
	String siteurl		//www.tagumisolutions.com
	String sendTo
	String sendCopyTo
	String sendBlindCopyTo
	String bodyTemplate
	String subjectTemplate
	String sendFrom
    static constraints = {
		sendCopyTo nullable:true
		sendBlindCopyTo nullable:true
		bodyTemplate nullable:true
		sendFrom nullable:true
		subjectTemplate nullable:true
    }
	
	static mapping = {
		bodyTemplate type:'text'
	}
}
