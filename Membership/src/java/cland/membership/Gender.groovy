package cland.membership

public enum Gender {
	MALE("Male"),
	FEMALE("Female"),
	UNKNOWN("Unknown")
	final String value;
	
	Gender(String value) {
		this.value = value;
	}
	
	String toString(){
		this.value;
	}
	
	String getKey(){
		name()
	}

	static list() {
		[MALE.toString(),FEMALE.toString(),UNKNOWN.toString()]
	}
	static stringKeyValuePair(){
		MALE.toString() +":" + MALE.getKey() + ";" +
		FEMALE.toString() +":" + FEMALE.getKey() + ";" +
		UNKNOWN.toString() +":" + UNKNOWN.getKey() + ";"
	}
	static listKeys() {
		[MALE.getKey(),FEMALE.getKey(),UNKNOWN.getKey()]
	}
}
