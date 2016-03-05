package cland.membership


class PageTitleTagLib {
	def appTitle = {attrs, body ->
		try{
			def org = Organisation.find{isHost==true}
			def prefix = "cBc: "
			if(org?.name) prefix = org?.name + ": "
			out << prefix  + attrs.title
			out << " " + body()
		}catch(Exception e){
		}
	}
}
