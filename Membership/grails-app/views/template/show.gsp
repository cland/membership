
<%@ page import="cland.membership.Template" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'template.label', default: 'Template')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-template" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav navpage" role="navigation">
			<ul>
				<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-template" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list template">
			<g:if test="${templateInstance?.title}">
				<li class="fieldcontain">
					<span id="title-label" class="property-label"><g:message code="template.title.label" default="Title" /></span>
					
						<span class="property-value" aria-labelledby="title-label"><g:fieldValue bean="${templateInstance}" field="title"/></span>
					
				</li>
				</g:if>
				
				<g:if test="${templateInstance?.body}">
				<li class="fieldcontain">
					<span id="body-label" class="property-label"><g:message code="template.body.label" default="Body" /></span>
					
						<span class="property-value" aria-labelledby="body-label"><g:fieldValue bean="${templateInstance}" field="body"/></span>
					
				</li>
				</g:if>
			
			
				<g:if test="${templateInstance?.status}">
				<li class="fieldcontain">
					<span id="status-label" class="property-label"><g:message code="template.status.label" default="Status" /></span>
					
						<span class="property-value" aria-labelledby="status-label"><g:fieldValue bean="${templateInstance}" field="status"/></span>
					
				</li>
				</g:if>						
			
			</ol>
			<g:form url="[resource:templateInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${templateInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
