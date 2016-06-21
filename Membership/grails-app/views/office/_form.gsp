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


