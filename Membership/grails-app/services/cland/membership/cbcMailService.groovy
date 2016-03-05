package cland.membership

class cbcMailService {
	static transactional = false
	def mailService
    def sendMail(String to,String subject, String htmlBody, String from) {
		def _subject = subject
		def _body = htmlBody
		def _to = to
		def _from = from
		try{
		mailService.sendMail {
			to _to
			from _from
			subject _subject
			html _body
		}
		}catch(Exception ex){
			println("Failed to send mail: ...")
			ex.printStackTrace()
		}
    }
} //end service
