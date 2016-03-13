<%@ page import="cland.membership.Child" %>



<div class="fieldcontain ${hasErrors(bean: childInstance, field: 'parent', 'error')} required">
	<label for="parent">
		<g:message code="child.parent.label" default="Parent" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="parent" name="parent" from="${cland.membership.Parent.list()}" optionKey="id" required="" value="${childInstance?.parent?.id}" class="many-to-one"/>

</div>
<div class="fieldcontain ${hasErrors(bean: childInstance, field: 'comments', 'error')} ">
			<label for="comments">
				<g:message code="child.comments.label" default="Comments" />
				
			</label>
			<g:textField name="comments" value="${childInstance?.comments}"/>
		
		</div>
		
		<div class="fieldcontain ${hasErrors(bean: childInstance, field: 'medicalComments', 'error')} ">
			<label for="medicalComments">
				<g:message code="child.medicalComments.label" default="Medical Comments" />
				
			</label>
			<g:textField name="medicalComments" value="${childInstance?.medicalComments}"/>
		
		</div>
		
		<div class="fieldcontain ${hasErrors(bean: childInstance, field: 'accessNumber', 'error')} ">
			<label for="accessNumber">
				<g:message code="child.accessNumber.label" default="Access Number" />
				
			</label>
			<g:textField name="accessNumber" value="${childInstance?.accessNumber}"/>
		
		</div>
		
		

<%--div class="fieldcontain ${hasErrors(bean: childInstance, field: 'person', 'error')} required">
	<label for="person">
		<g:message code="child.person.label" default="Person" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="person" name="person.id" from="${cland.membership.security.Person.list()}" optionKey="id" required="" value="${childInstance?.person?.id}" class="many-to-one"/>

</div--%>

<div class="fieldcontain ${hasErrors(bean: childInstance, field: 'visits', 'error')} ">
	<label for="visits">
		<g:message code="child.visits.label" default="Visits" />
		
	</label>
	
<ul class="one-to-many">
<g:each in="${childInstance?.visits?}" var="v">
    <li><g:link controller="visit" action="show" id="${v.id}">${v?.encodeAsHTML()}</g:link></li>
</g:each>
<li class="add">
<g:link controller="visit" action="create" params="['child.id': childInstance?.id]">${message(code: 'default.add.label', args: [message(code: 'visit.label', default: 'Visit')])}</g:link>
</li>
</ul>


</div>

