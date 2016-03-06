
package cland.membership.location

class Location {
	Country country
	Region region
	District district
	Municipality municipality
	MainPlace mainplace
	Suburb suburb
	String township
	String description
	String longitude
	String latitude
    static constraints = {
		township blank:true, nullable:true
		description blank:true,nullable:true
		longitude blank:true, nullable:true
		latitude blank:true, nullable:true
		district blank:true, nullable:true
		municipality  blank:true, nullable:true
		mainplace blank:true, nullable:true
		suburb blank:true, nullable:true
		
	}
	String toString(){
		"Country:${country},Region:${region},District:${district},Municipality:${municipality},MainPlace:${mainplace},Suburb:${suburb}"
	}
	def beforeInsert = {
		
	}
	def beforeUpdate = {
		
	}

	def toMap(){
		return [id:id,
			country:country?.name,
			region:region?.name,
			district:district?.name,
			municipality:municipality?.name,
			mainplace:mainplace?.name,
			suburb:suburb?.name,
			township:township,
			description:description,
			longitude:longitude,
			latitude:latitude]
	}
	def onLoad = {
		// your code goes here
	}
	
	
} //end class

