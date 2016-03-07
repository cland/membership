package cland.membership

public enum SystemRoles {
	//SUPER ADMIN
	ROLE_ADMIN("ROLE_ADMIN","System Admin - Full access"),
	ROLE_MANAGER("ROLE_MANAGER","Office manager - Limited privileged rights"),
	ROLE_ASSISTANT("ROLE_MANAGER","Assistant staff - Limited rights"),
	ROLE_DEVELOPER("ROLE_DEVELOPER","System Developer - Full access"),	
	ROLE_USER("ROLE_USER","User Role - Limited access"),
	ROLE_REVIEWER("ROLE_REVIEWER","User Role - Reviewer")

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
		[ROLE_USER,ROLE_ADMIN,ROLE_DEVELOPER,ROLE_REVIEWER]
	}
}