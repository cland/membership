
<%@ page import="cland.membership.Settings" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'settings.label', default: 'Settings')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-settings" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		
		<div id="show-settings" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list settings">
				<g:if test="${settingsInstance?.name}">
				<li class="fieldcontain">
					<span id="name-label" class="property-label"><g:message code="settings.name.label" default="Name" /></span>
					
						<span class="property-value" aria-labelledby="name-label"><g:fieldValue bean="${settingsInstance}" field="name"/></span>
					
				</li>
				</g:if>
			<g:if test="${settingsInstance?.title}">
				<li class="fieldcontain">
					<span id="title-label" class="property-label"><g:message code="settings.title.label" default="Title" /></span>
					
						<span class="property-value" aria-labelledby="title-label"><g:fieldValue bean="${settingsInstance}" field="title"/></span>
					
				</li>
				</g:if>
			<g:if test="${settingsInstance?.subtitle}">
				<li class="fieldcontain">
					<span id="subtitle-label" class="property-label"><g:message code="settings.subtitle.label" default="Subtitle" /></span>
					
						<span class="property-value" aria-labelledby="subtitle-label"><g:fieldValue bean="${settingsInstance}" field="subtitle"/></span>
					
				</li>
				</g:if>
							
				<g:if test="${settingsInstance?.description}">
				<li class="fieldcontain">
					<span id="description-label" class="property-label"><g:message code="settings.description.label" default="Description" /></span>
					
						<span class="property-value" aria-labelledby="description-label"><g:fieldValue bean="${settingsInstance}" field="description"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${settingsInstance?.visitcount}">
				<li class="fieldcontain">
					<span id="visitcount-label" class="property-label"><g:message code="settings.visitcount.label" default="Visitcount" /></span>
					
						<span class="property-value" aria-labelledby="visitcount-label"><g:fieldValue bean="${settingsInstance}" field="visitcount"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${settingsInstance?.notifytime}">
				<li class="fieldcontain">
					<span id="notifytime-label" class="property-label"><g:message code="settings.notifytime.label" default="Notifytime" /></span>
					
						<span class="property-value" aria-labelledby="notifytime-label"><g:fieldValue bean="${settingsInstance}" field="notifytime"/></span>
					
				</li>
				</g:if>													
							
			
			</ol>
			<g:form url="[resource:settingsInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${settingsInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
