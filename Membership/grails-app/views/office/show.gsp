
<%@ page import="cland.membership.Office" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'office.label', default: 'Office')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-office" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-office" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list office">
			
				<g:if test="${officeInstance?.name}">
				<li class="fieldcontain">
					<span id="name-label" class="property-label"><g:message code="office.name.label" default="Name" /></span>
					
						<span class="property-value" aria-labelledby="name-label"><g:fieldValue bean="${officeInstance}" field="name"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${officeInstance?.code}">
				<li class="fieldcontain">
					<span id="code-label" class="property-label"><g:message code="office.code.label" default="Code" /></span>
					
						<span class="property-value" aria-labelledby="code-label"><g:fieldValue bean="${officeInstance}" field="code"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${officeInstance?.status}">
				<li class="fieldcontain">
					<span id="status-label" class="property-label"><g:message code="office.status.label" default="Status" /></span>
					
						<span class="property-value" aria-labelledby="status-label"><g:fieldValue bean="${officeInstance}" field="status"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${officeInstance?.email}">
				<li class="fieldcontain">
					<span id="email-label" class="property-label"><g:message code="office.email.label" default="Email" /></span>
					
						<span class="property-value" aria-labelledby="email-label"><g:fieldValue bean="${officeInstance}" field="email"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${officeInstance?.contactNumber}">
				<li class="fieldcontain">
					<span id="contactNumber-label" class="property-label"><g:message code="office.contactNumber.label" default="Contact Number" /></span>
					
						<span class="property-value" aria-labelledby="contactNumber-label"><g:fieldValue bean="${officeInstance}" field="contactNumber"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${officeInstance?.cellphoneNumber}">
				<li class="fieldcontain">
					<span id="cellphoneNumber-label" class="property-label"><g:message code="office.cellphoneNumber.label" default="Cellphone Number" /></span>
					
						<span class="property-value" aria-labelledby="cellphoneNumber-label"><g:fieldValue bean="${officeInstance}" field="cellphoneNumber"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${officeInstance?.faxNumber}">
				<li class="fieldcontain">
					<span id="faxNumber-label" class="property-label"><g:message code="office.faxNumber.label" default="Fax Number" /></span>
					
						<span class="property-value" aria-labelledby="faxNumber-label"><g:fieldValue bean="${officeInstance}" field="faxNumber"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${officeInstance?.lastUpdatedBy}">
				<li class="fieldcontain">
					<span id="lastUpdatedBy-label" class="property-label"><g:message code="office.lastUpdatedBy.label" default="Last Updated By" /></span>
					
						<span class="property-value" aria-labelledby="lastUpdatedBy-label"><g:fieldValue bean="${officeInstance}" field="lastUpdatedBy"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${officeInstance?.createdBy}">
				<li class="fieldcontain">
					<span id="createdBy-label" class="property-label"><g:message code="office.createdBy.label" default="Created By" /></span>
					
						<span class="property-value" aria-labelledby="createdBy-label"><g:fieldValue bean="${officeInstance}" field="createdBy"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${officeInstance?.history}">
				<li class="fieldcontain">
					<span id="history-label" class="property-label"><g:message code="office.history.label" default="History" /></span>
					
						<span class="property-value" aria-labelledby="history-label"><g:fieldValue bean="${officeInstance}" field="history"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${officeInstance?.location}">
				<li class="fieldcontain">
					<span id="location-label" class="property-label"><g:message code="office.location.label" default="Location" /></span>
					
						<span class="property-value" aria-labelledby="location-label"><g:link controller="location" action="show" id="${officeInstance?.location?.id}">${officeInstance?.location?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				<g:if test="${officeInstance?.affiliates}">
				<li class="fieldcontain">
					<span id="affiliates-label" class="property-label"><g:message code="office.affiliates.label" default="Affiliates" /></span>
					
						<g:each in="${officeInstance.affiliates}" var="a">
						<span class="property-value" aria-labelledby="affiliates-label"><g:link controller="organisation" action="show" id="${a.id}">${a?.encodeAsHTML()}</g:link></span>
						</g:each>
					
				</li>
				</g:if>
			
				<g:if test="${officeInstance?.dateCreated}">
				<li class="fieldcontain">
					<span id="dateCreated-label" class="property-label"><g:message code="office.dateCreated.label" default="Date Created" /></span>
					
						<span class="property-value" aria-labelledby="dateCreated-label"><g:formatDate date="${officeInstance?.dateCreated}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${officeInstance?.lastUpdated}">
				<li class="fieldcontain">
					<span id="lastUpdated-label" class="property-label"><g:message code="office.lastUpdated.label" default="Last Updated" /></span>
					
						<span class="property-value" aria-labelledby="lastUpdated-label"><g:formatDate date="${officeInstance?.lastUpdated}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${officeInstance?.staff}">
				<li class="fieldcontain">
					<span id="staff-label" class="property-label"><g:message code="office.staff.label" default="Staff" /></span>
					
						<g:each in="${officeInstance.staff}" var="s">
						<span class="property-value" aria-labelledby="staff-label"><g:link controller="person" action="show" id="${s.id}">${s?.encodeAsHTML()}</g:link></span>
						</g:each>
					
				</li>
				</g:if>
			
			</ol>
			<g:form url="[resource:officeInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${officeInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
