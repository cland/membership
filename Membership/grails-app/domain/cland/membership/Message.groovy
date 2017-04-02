package cland.membership

import java.util.Date;

class Message {
	/** Mailing Envelope **/
	String sendTo
	String sendCopyTo
	String sendBlindCopyTo
	String sendFrom
	String subject
	String message
	
	/** extra statistical data **/
	String senderName
	String senderEmail
	String senderTel
	String senderIpAddress
	
	String status
	Date dateSent	
	String outcome
	Date dateCreated
	Date lastUpdated
	String hashcode
    static constraints = {
		sendCopyTo nullable:true
		sendBlindCopyTo nullable:true
		outcome nullable:true
		status nullable:true
		dateSent nullable:true	
		sendFrom nullable:true	
    }
	static mapping = {
		message type : 'text'
	}
}
