class UrlMappings {

	static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }
		
		"/"(controller:"home",action:"index")
		"/htown" (controller:"home",action:"htown")
		"/admin/technical" (view:"/admin/technical")		
		"/selfregister" (view:"/selfregister")
		//"/admin/"(view:"/admin/index")
		
        //"/"(view:"/index")
        "500"(view:'/error')
		"404"(view:'/error')
	}
}
