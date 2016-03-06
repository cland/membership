package cland.membership

public enum SystemRoles {
	//SUPER ADMIN
	ROLE_ADMIN("ROLE_ADMIN","System Admin - Full access"),
	ROLE_DEVELOPER("ROLE_DEVELOPER","System Developer - Full access"),	
	ROLE_USER("ROLE_USER","User Role - Limited access")

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
		[ROLE_USER,ROLE_ADMIN,ROLE_DEVELOPER]
	}
}