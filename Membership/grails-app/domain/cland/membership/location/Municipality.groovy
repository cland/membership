package cland.membership.location

class Municipality {
	String name
	String code
	static hasMany = [places:MainPlace]
	static belongsTo = [district:District]
    static constraints = {
		name blank:false, unique:['district']
		code blank:false, unique:true
    }
	static mapping = {
		sort name: "asc"
	}
	String toString(){
		"${name}"
	}
}
