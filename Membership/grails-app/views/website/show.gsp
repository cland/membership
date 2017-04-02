
<%@ page import="cland.membership.Website" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'website.label', default: 'Website')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-website" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-website" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list website">
			
				<g:if test="${websiteInstance?.sendCopyTo}">
				<li class="fieldcontain">
					<span id="sendCopyTo-label" class="property-label"><g:message code="website.sendCopyTo.label" default="Send Copy To" /></span>
					
						<span class="property-value" aria-labelledby="sendCopyTo-label"><g:fieldValue bean="${websiteInstance}" field="sendCopyTo"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${websiteInstance?.sendBlindCopyTo}">
				<li class="fieldcontain">
					<span id="sendBlindCopyTo-label" class="property-label"><g:message code="website.sendBlindCopyTo.label" default="Send Blind Copy To" /></span>
					
						<span class="property-value" aria-labelledby="sendBlindCopyTo-label"><g:fieldValue bean="${websiteInstance}" field="sendBlindCopyTo"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${websiteInstance?.bodyTemplate}">
				<li class="fieldcontain">
					<span id="bodyTemplate-label" class="property-label"><g:message code="website.bodyTemplate.label" default="Body Template" /></span>
					
						<span class="property-value" aria-labelledby="bodyTemplate-label"><g:fieldValue bean="${websiteInstance}" field="bodyTemplate"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${websiteInstance?.sendFrom}">
				<li class="fieldcontain">
					<span id="sendFrom-label" class="property-label"><g:message code="website.sendFrom.label" default="Send From" /></span>
					
						<span class="property-value" aria-labelledby="sendFrom-label"><g:fieldValue bean="${websiteInstance}" field="sendFrom"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${websiteInstance?.subjectTemplate}">
				<li class="fieldcontain">
					<span id="subjectTemplate-label" class="property-label"><g:message code="website.subjectTemplate.label" default="Subject Template" /></span>
					
						<span class="property-value" aria-labelledby="subjectTemplate-label"><g:fieldValue bean="${websiteInstance}" field="subjectTemplate"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${websiteInstance?.sendTo}">
				<li class="fieldcontain">
					<span id="sendTo-label" class="property-label"><g:message code="website.sendTo.label" default="Send To" /></span>
					
						<span class="property-value" aria-labelledby="sendTo-label"><g:fieldValue bean="${websiteInstance}" field="sendTo"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${websiteInstance?.sitename}">
				<li class="fieldcontain">
					<span id="sitename-label" class="property-label"><g:message code="website.sitename.label" default="Sitename" /></span>
					
						<span class="property-value" aria-labelledby="sitename-label"><g:fieldValue bean="${websiteInstance}" field="sitename"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${websiteInstance?.siteurl}">
				<li class="fieldcontain">
					<span id="siteurl-label" class="property-label"><g:message code="website.siteurl.label" default="Siteurl" /></span>
					
						<span class="property-value" aria-labelledby="siteurl-label"><g:fieldValue bean="${websiteInstance}" field="siteurl"/></span>
					
				</li>
				</g:if>
			
			</ol>
			<g:form url="[resource:websiteInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${websiteInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
