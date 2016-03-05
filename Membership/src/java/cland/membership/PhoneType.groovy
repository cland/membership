package cland.membership


public enum PhoneType{
	H("Home"),
	M("Mobile"),
	W("Work"),
	F("Fax"),
	O("Other")
	final String value;
	PhoneType(String value) {
	this.value = value;
	}
	String toString(){
	value;
	}
	String getKey(){
		name()
	}
	static list() {
		[H, M, W, F, O]
	}
	static listValues() {
		[H.toString(), M.toString(), W.toString(), F.toString(),O.toString()]
	}
	static stringKeyValuePair(){
		H.toString() +":" + H.getKey() + ";" +
		M.toString() +":" + M.getKey() + ";" +
		W.toString() +":" + W.getKey() + ";" +
		F.toString() +":" + F.getKey() + ";" +
		O.toString() +":" + O.getKey() + ";"
	}
	static listKeys() {
		[H.getKey(),M.getKey(),W.getKey(),F.getKey(),O.getKey()]
	}
}
