package cland.membership

public enum SystemRoles {
	//SUPER ADMIN
	ROLE_ADMIN("ROLE_ADMIN","System Admin - Full access"),
	ROLE_DEVELOPER("ROLE_DEVELOPER","System Developer - Full access"),	
	
	//NATIONAL LEVEL
	ROLE_NCO("ROLE_NCO","National Co-Ordinator - Statistical Information Only"),
	
	//REGIONAL LEVEL
	ROLE_PCO("ROLE_PCO","Provincial Co-Ordinator - Statistical Information Only for a given region"),
	
	//OFFICE LEVEL
	ROLE_OCO("ROLE_OCO","Office Co-Ordinator"),	
	ROLE_CWO("ROLE_CWO","Case Worker Officer"),
	ROLE_SPO("ROLE_SPO","Special Case Worker"),
	ROLE_REVIEWER("ROLE_READER_FULL","Can Read Full Only for a given office"),
	ROLE_READER("ROLE_READER_LIMITED","Can Read Limited Only for a given office"),
	ROLE_PCM("ROLE_PCM","Please Call Me Access")
	final String value;
	final String description;
	SystemRoles(String value) {
		this.value = value;
		this.description = "";
	}
	SystemRoles(String value,String desc) {
		this.value = value;
		this.description = desc;
	}
	String toString(){
		value;
	}
	String getDescription(){
		return description
	}
	String getKey(){
		name()
	}

	static list() {
		[ROLE_REVIEWER,ROLE_ADMIN,ROLE_DEVELOPER,
			ROLE_NCO,
			ROLE_PCO,
			ROLE_OCO,
			ROLE_CWO,
			ROLE_SPO,
			ROLE_READER
			]
	}
}