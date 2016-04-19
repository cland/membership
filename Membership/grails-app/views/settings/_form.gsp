<%@ page import="cland.membership.Settings" %>

<div class="fieldcontain ${hasErrors(bean: settingsInstance, field: 'Application name', 'error')} required">
	<label for="name">
		<g:message code="settings.name.label" default="Name" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="name" required="" value="${settingsInstance?.name}"/>

</div>
<div class="fieldcontain ${hasErrors(bean: settingsInstance, field: 'Title', 'error')} required">
	<label for="title">
		<g:message code="settings.title.label" default="Title" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="title" required="" value="${settingsInstance?.title}"/>

</div>
<div class="fieldcontain ${hasErrors(bean: settingsInstance, field: 'Sub Title', 'error')} required">
	<label for="subtitle">
		<g:message code="settings.subtitle.label" default="Subtitle" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="subtitle" required="" value="${settingsInstance?.subtitle}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: settingsInstance, field: 'description', 'error')} ">
	<label for="description">
		<g:message code="settings.description.label" default="Description" />
		
	</label>
	<g:textArea name="description" value="${settingsInstance?.description}"  rows="5" cols="40"/>

</div>

<div class="fieldcontain ${hasErrors(bean: settingsInstance, field: 'visitcount', 'error')} ">
	<label for="visitcount">
		<g:message code="settings.visitcount.label" default="Discount after how many visits? If say 5 then the 6th visit will be discounted." />
		
	</label>
	<g:field name="visitcount" type="number" value="${settingsInstance.visitcount}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: settingsInstance, field: 'notifytime', 'error')} ">
	<label for="notifytime">
		<g:message code="settings.notifytime.label" default="Minutes after which to send reminder message (Warning/Orange)" />
		
	</label>
	<g:field name="notifytime" type="number" value="${settingsInstance.notifytime}"/>

</div>
<div class="fieldcontain ${hasErrors(bean: settingsInstance, field: 'donetime', 'error')} ">
	<label for="notifytime">
		<g:message code="settings.donetime.label" default="Standard time up (Done/Red) after:" />
		
	</label>
	<g:field name="donetime" type="number" value="${settingsInstance.donetime}"/>

</div>






