package cland.membership.location

class District {
	String name
	String code
	
	static hasMany = [municipalities:Municipality]
	static belongsTo = [region:Region]
    static constraints = {
		name blank:false, unique:['region']
		code blank:false, unique:true
    }
	static mapping = {
		sort name: "asc"
	}
	String toString(){
		"${name}"
	}
}
