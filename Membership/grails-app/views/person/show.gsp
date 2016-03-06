
<%@ page import="cland.membership.security.Person" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'person.label', default: 'Person')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-person" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-person" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list person">
			
				<g:if test="${personInstance?.username}">
				<li class="fieldcontain">
					<span id="username-label" class="property-label"><g:message code="person.username.label" default="Username" /></span>
					
						<span class="property-value" aria-labelledby="username-label"><g:fieldValue bean="${personInstance}" field="username"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${personInstance?.password}">
				<li class="fieldcontain">
					<span id="password-label" class="property-label"><g:message code="person.password.label" default="Password" /></span>
					
						<span class="property-value" aria-labelledby="password-label"><g:fieldValue bean="${personInstance}" field="password"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${personInstance?.firstName}">
				<li class="fieldcontain">
					<span id="firstName-label" class="property-label"><g:message code="person.firstName.label" default="First Name" /></span>
					
						<span class="property-value" aria-labelledby="firstName-label"><g:fieldValue bean="${personInstance}" field="firstName"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${personInstance?.race}">
				<li class="fieldcontain">
					<span id="race-label" class="property-label"><g:message code="person.race.label" default="Race" /></span>
					
						<span class="property-value" aria-labelledby="race-label"><g:link controller="race" action="show" id="${personInstance?.race?.id}">${personInstance?.race?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				<g:if test="${personInstance?.accountExpired}">
				<li class="fieldcontain">
					<span id="accountExpired-label" class="property-label"><g:message code="person.accountExpired.label" default="Account Expired" /></span>
					
						<span class="property-value" aria-labelledby="accountExpired-label"><g:formatBoolean boolean="${personInstance?.accountExpired}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${personInstance?.knownAs}">
				<li class="fieldcontain">
					<span id="knownAs-label" class="property-label"><g:message code="person.knownAs.label" default="Known As" /></span>
					
						<span class="property-value" aria-labelledby="knownAs-label"><g:fieldValue bean="${personInstance}" field="knownAs"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${personInstance?.title}">
				<li class="fieldcontain">
					<span id="title-label" class="property-label"><g:message code="person.title.label" default="Title" /></span>
					
						<span class="property-value" aria-labelledby="title-label"><g:fieldValue bean="${personInstance}" field="title"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${personInstance?.email}">
				<li class="fieldcontain">
					<span id="email-label" class="property-label"><g:message code="person.email.label" default="Email" /></span>
					
						<span class="property-value" aria-labelledby="email-label"><g:fieldValue bean="${personInstance}" field="email"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${personInstance?.gender}">
				<li class="fieldcontain">
					<span id="gender-label" class="property-label"><g:message code="person.gender.label" default="Gender" /></span>
					
						<span class="property-value" aria-labelledby="gender-label"><g:fieldValue bean="${personInstance}" field="gender"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${personInstance?.lastName}">
				<li class="fieldcontain">
					<span id="lastName-label" class="property-label"><g:message code="person.lastName.label" default="Last Name" /></span>
					
						<span class="property-value" aria-labelledby="lastName-label"><g:fieldValue bean="${personInstance}" field="lastName"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${personInstance?.accountLocked}">
				<li class="fieldcontain">
					<span id="accountLocked-label" class="property-label"><g:message code="person.accountLocked.label" default="Account Locked" /></span>
					
						<span class="property-value" aria-labelledby="accountLocked-label"><g:formatBoolean boolean="${personInstance?.accountLocked}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${personInstance?.passwordExpired}">
				<li class="fieldcontain">
					<span id="passwordExpired-label" class="property-label"><g:message code="person.passwordExpired.label" default="Password Expired" /></span>
					
						<span class="property-value" aria-labelledby="passwordExpired-label"><g:formatBoolean boolean="${personInstance?.passwordExpired}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${personInstance?.enabled}">
				<li class="fieldcontain">
					<span id="enabled-label" class="property-label"><g:message code="person.enabled.label" default="Enabled" /></span>
					
						<span class="property-value" aria-labelledby="enabled-label"><g:formatBoolean boolean="${personInstance?.enabled}" /></span>
					
				</li>
				</g:if>
			
			</ol>
			<g:form url="[resource:personInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${personInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>