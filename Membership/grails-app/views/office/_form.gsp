<%@ page import="cland.membership.Office" %>


<legend>Office Details</legend>
<div class="fieldcontain ${hasErrors(bean: officeInstance, field: 'name', 'error')} required">
	<label for="name">
		<g:message code="office.name.label" default="Name" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="name" required="" value="${officeInstance?.name}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: officeInstance, field: 'code', 'error')} required">
	<label for="code">
		<g:message code="office.code.label" default="Code" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="code" required="" value="${officeInstance?.code}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: officeInstance, field: 'status', 'error')} required">
	<label for="status">
		<g:message code="office.status.label" default="Status" />
		<span class="required-indicator">*</span>
	</label>
	<g:select name="status" from="${['Active', 'Inactive']}" required="" value="${officeInstance?.status}" valueMessagePrefix="office.status"/>

</div>

<div class="fieldcontain ${hasErrors(bean: officeInstance, field: 'email', 'error')} ">
	<label for="email">
		<g:message code="office.email.label" default="Email" />
		
	</label>
	<g:field type="email" name="email" value="${officeInstance?.email}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: officeInstance, field: 'contactNumber', 'error')} ">
	<label for="contactNumber">
		<g:message code="office.contactNumber.label" default="Contact Number" />
		
	</label>
	<g:textField name="contactNumber" matches="${'[0-9 ]*'}" value="${officeInstance?.contactNumber}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: officeInstance, field: 'cellphoneNumber', 'error')} ">
	<label for="cellphoneNumber">
		<g:message code="office.cellphoneNumber.label" default="Cellphone Number" />
		
	</label>
	<g:textField name="cellphoneNumber" matches="${'[0-9 ]*'}" value="${officeInstance?.cellphoneNumber}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: officeInstance, field: 'faxNumber', 'error')} ">
	<label for="faxNumber">
		<g:message code="office.faxNumber.label" default="Fax Number" />
		
	</label>
	<g:textField name="faxNumber" matches="${'[0-9 ]*'}" value="${officeInstance?.faxNumber}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: officeInstance, field: 'lastUpdatedBy', 'error')} required">
	<label for="lastUpdatedBy">
		<g:message code="office.lastUpdatedBy.label" default="Last Updated By" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="lastUpdatedBy" type="number" value="${officeInstance?.lastUpdatedBy}" required=""/>

</div>

<div class="fieldcontain ${hasErrors(bean: officeInstance, field: 'createdBy', 'error')} required">
	<label for="createdBy">
		<g:message code="office.createdBy.label" default="Created By" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="createdBy" type="number" value="${officeInstance?.createdBy}" required=""/>

</div>

<div class="fieldcontain ${hasErrors(bean: officeInstance, field: 'history', 'error')} ">
	<label for="history">
		<g:message code="office.history.label" default="History" />
		
	</label>
	<g:textField name="history" readonly="readonly" value="${officeInstance?.history}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: officeInstance, field: 'location', 'error')} ">
	<label for="location">
		<g:message code="office.location.label" default="Location" />
		
	</label>
	<g:select id="location" name="location.id" from="${cland.membership.location.Location.list()}" optionKey="id" value="${officeInstance?.location?.id}" class="many-to-one" noSelection="['null': '']"/>

</div>

<div class="fieldcontain ${hasErrors(bean: officeInstance, field: 'affiliates', 'error')} ">
	<label for="affiliates">
		<g:message code="office.affiliates.label" default="Affiliates" />
		
	</label>
	<g:select name="affiliates" from="${cland.membership.Organisation.list()}" multiple="multiple" optionKey="id" size="5" value="${officeInstance?.affiliates*.id}" class="many-to-many"/>

</div>

<div class="fieldcontain ${hasErrors(bean: officeInstance, field: 'staff', 'error')} ">
	<label for="staff">
		<g:message code="office.staff.label" default="Staff" />
		
	</label>
	
<ul class="one-to-many">
<g:each in="${officeInstance?.staff?}" var="s">
    <li><g:link controller="person" action="show" id="${s.id}">${s?.encodeAsHTML()}</g:link></li>
</g:each>
<li class="add">
<g:link controller="person" action="create" params="['office.id': officeInstance?.id]">${message(code: 'default.add.label', args: [message(code: 'person.label', default: 'Person')])}</g:link>
</li>
</ul>


</div>

