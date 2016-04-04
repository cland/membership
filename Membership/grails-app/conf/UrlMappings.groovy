class UrlMappings {

	static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }
		
		//"/"(controller:"home",action:"index")
		"/admin/technical" (view:"/admin/technical")
		"/livepanel" (view:"/livepanel")
		"/htown" (view:"htown")
		//"/admin/"(view:"/admin/index")
		
        "/"(view:"/index")
        "500"(view:'/error')
	}
}
