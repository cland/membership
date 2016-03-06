package cland.membership.location

class MainPlace {
	String name
	String code
	static hasMany = [suburbs:Suburb]
	static belongsTo = [municipality:Municipality]
	static constraints = {
		name blank:false, unique:['municipality']
		code blank:false, unique:true
	}
	static mapping = {
		sort name: "asc"
	}
	String toString(){
		"${name}"
	}    
}
