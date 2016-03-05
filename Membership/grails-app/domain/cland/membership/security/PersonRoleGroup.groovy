package cland.membership.security

import grails.gorm.DetachedCriteria
import groovy.transform.ToString

import org.apache.commons.lang.builder.HashCodeBuilder

@ToString(cache=true, includeNames=true, includePackage=false)
class PersonRoleGroup implements Serializable {

	private static final long serialVersionUID = 1

	Person person
	RoleGroup roleGroup

	PersonRoleGroup(Person u, RoleGroup rg) {
		this()
		person = u
		roleGroup = rg
	}

	@Override
	boolean equals(other) {
		if (!(other instanceof PersonRoleGroup)) {
			return false
		}

		other.person?.id == person?.id && other.roleGroup?.id == roleGroup?.id
	}

	@Override
	int hashCode() {
		def builder = new HashCodeBuilder()
		if (person) builder.append(person.id)
		if (roleGroup) builder.append(roleGroup.id)
		builder.toHashCode()
	}

	static PersonRoleGroup get(long personId, long roleGroupId) {
		criteriaFor(personId, roleGroupId).get()
	}

	static boolean exists(long personId, long roleGroupId) {
		criteriaFor(personId, roleGroupId).count()
	}

	private static DetachedCriteria criteriaFor(long personId, long roleGroupId) {
		PersonRoleGroup.where {
			person == Person.load(personId) &&
			roleGroup == RoleGroup.load(roleGroupId)
		}
	}

	static PersonRoleGroup create(Person person, RoleGroup roleGroup, boolean flush = false) {
		def instance = new PersonRoleGroup(person: person, roleGroup: roleGroup)
		instance.save(flush: flush, insert: true)
		instance
	}

	static boolean remove(Person u, RoleGroup rg, boolean flush = false) {
		if (u == null || rg == null) return false

		int rowCount = PersonRoleGroup.where { person == u && roleGroup == rg }.deleteAll()

		if (flush) { PersonRoleGroup.withSession { it.flush() } }

		rowCount
	}

	static void removeAll(Person u, boolean flush = false) {
		if (u == null) return

		PersonRoleGroup.where { person == u }.deleteAll()

		if (flush) { PersonRoleGroup.withSession { it.flush() } }
	}

	static void removeAll(RoleGroup rg, boolean flush = false) {
		if (rg == null) return

		PersonRoleGroup.where { roleGroup == rg }.deleteAll()

		if (flush) { PersonRoleGroup.withSession { it.flush() } }
	}

	static constraints = {
		person validator: { Person u, PersonRoleGroup ug ->
			if (ug.roleGroup == null || ug.roleGroup.id == null) return
			boolean existing = false
			PersonRoleGroup.withNewSession {
				existing = PersonRoleGroup.exists(u.id, ug.roleGroup.id)
			}
			if (existing) {
				return 'userGroup.exists'
			}
		}
	}

	static mapping = {
		id composite: ['roleGroup', 'person']
		version false
	}
}
