package cland.membership.location

class Suburb {

	String name
	String code
	
	static belongsTo = [mainplace:MainPlace]
    static constraints = {
		name blank:false, unique:['mainplace']
		code unique:true, blank:false
    }
	static mapping = {
		sort name: "asc"
	}
	String toString(){
		return name
	}
}
