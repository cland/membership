package cland.membership
/** example usage
 * <g:isOwner owner="${post?.author}"> ... </g:isOwner>
 * @author Cland
 *
 */
class AuthTagLib {
	def springSecurityService
	
	  def isOwner = { attrs, body ->
		def loggedInUser = springSecurityService.currentUser
		def owner = attrs?.owner
	
		if(loggedInUser?.id == owner?.id) {
		  out << body()
		}
	  }
}
