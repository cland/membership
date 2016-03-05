package cland.membership


class SideMenuTagLib {
	def cbcApiService
	def sideMenu = {attrs, body ->
		def menuLink = "../layouts/" + cbcApiService.getSideMenuName(attrs?.default)
		out << render(template:menuLink)
		
	}
}
