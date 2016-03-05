package cland.membership

class UserTagTagLib {
	def cbcApiService
	def userFullname = { attrs, body ->
			Long id = attrs?.id?.toLong()
			def value = cbcApiService.getUserFullname(id)
			if(value.equals("")) value = attrs?.default
		  out << value
		
	  }	
} //
