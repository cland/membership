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
		<g:message code="settings.visitcount.label" default="Visitcount" />
		
	</label>
	<g:field name="visitcount" type="number" value="${settingsInstance.visitcount}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: settingsInstance, field: 'Minutes left to send time reminder message', 'error')} ">
	<label for="notifytime">
		<g:message code="settings.notifytime.label" default="Notifytime" />
		
	</label>
	<g:field name="notifytime" type="number" value="${settingsInstance.notifytime}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: settingsInstance, field: 'Time reminder message', 'error')} ">
	<label for="timereminder">
		<g:message code="settings.timereminder.label" default="Timereminder" />
		
	</label>
	<g:textArea name="timereminder" value="${settingsInstance?.timereminder}"  rows="5" cols="40"/>

</div>

<div class="fieldcontain ${hasErrors(bean: settingsInstance, field: 'Sick/Injured child message', 'error')} ">
	<label for="sickchild">
		<g:message code="settings.sickchild.label" default="Sickchild" />
		
	</label>
	<g:textArea name="sickchild" value="${settingsInstance?.sickchild}"  rows="5" cols="40"/>

</div>

<div class="fieldcontain ${hasErrors(bean: settingsInstance, field: 'Problem child message', 'error')} ">
	<label for="problemchild">
		<g:message code="settings.problemchild.label" default="Problemchild" />
		
	</label>
	<g:textArea name="problemchild" value="${settingsInstance?.problemchild}"  rows="5" cols="40"/>

</div>





