package cland.membership.security

import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString

@EqualsAndHashCode(includes='name')
@ToString(includes='name', includeNames=true, includePackage=false)
class RoleGroup implements Serializable {

	private static final long serialVersionUID = 1

	String name
	String description
	RoleGroup(String name) {
		this()
		this.name = name
	}
	RoleGroup(String name,String description){
		this()
		this.name = name
		this.description = description
	}

	Set<Role> getAuthorities() {
		RoleGroupRole.findAllByRoleGroup(this)*.role
	}

	static constraints = {
		name blank: false, unique: true
	}

	static mapping = {
		cache true
	}
	def toAutoCompleteMap(){
		
		return [id:id,
			label:name + " | " + description ,
			value:id,
			category:"Group",rolegroup:this]
	}
	String toString(){
		return name
	}
}
