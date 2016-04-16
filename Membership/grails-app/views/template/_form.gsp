<%@ page import="cland.membership.Template" %>

<div class="fieldcontain ${hasErrors(bean: templateInstance, field: 'title', 'error')} required">
	<label for="title">
		<g:message code="template.title.label" default="Title" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="title" required="" value="${templateInstance?.title}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: templateInstance, field: 'body', 'error')} required">
	<label for="body">
		<g:message code="template.body.label" default="Body" />
		<span class="required-indicator">*</span>
	</label>	
	<g:textArea name="body" value="${templateInstance?.body}" required="" rows="5" cols="40"/>

</div>
<div class="fieldcontain ${hasErrors(bean: templateInstance, field: 'status', 'error')} required">
	<label for="status">
		<g:message code="template.status.label" default="Status" />
		
	</label>
	<g:textField name="status"  value="${templateInstance?.status}"/>

</div>
