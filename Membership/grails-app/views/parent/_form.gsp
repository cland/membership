<%@ page import="cland.membership.Parent" %>



<div class="fieldcontain ${hasErrors(bean: parentInstance, field: 'children', 'error')} ">
	<label for="children">
		<g:message code="parent.children.label" default="Children" />
		
	</label>
	
<ul class="one-to-many">
<g:each in="${parentInstance?.children?}" var="c">
    <li><g:link controller="child" action="show" id="${c.id}">${c?.encodeAsHTML()}</g:link></li>
</g:each>
<li class="add">
<g:link controller="child" action="create" params="['parent.id': parentInstance?.id]">${message(code: 'default.add.label', args: [message(code: 'child.label', default: 'Child')])}</g:link>
</li>
</ul>


</div>

<div class="fieldcontain ${hasErrors(bean: parentInstance, field: 'date', 'error')} required">
	<label for="date">
		<g:message code="parent.date.label" default="Date" />
		<span class="required-indicator">*</span>
	</label>
	<g:datePicker name="date" precision="day"  value="${parentInstance?.date}"  />

</div>

<div class="fieldcontain ${hasErrors(bean: parentInstance, field: 'person1', 'error')} required">
	<label for="person1">
		<g:message code="parent.person1.label" default="Person1" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="person1" name="person1.id" from="${cland.membership.security.Person.list()}" optionKey="id" required="" value="${parentInstance?.person1?.id}" class="many-to-one"/>

</div>

<div class="fieldcontain ${hasErrors(bean: parentInstance, field: 'person2', 'error')} required">
	<label for="person2">
		<g:message code="parent.person2.label" default="Person2" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="person2" name="person2.id" from="${cland.membership.security.Person.list()}" optionKey="id" required="" value="${parentInstance?.person2?.id}" class="many-to-one"/>

</div>

