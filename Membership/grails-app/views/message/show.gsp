
<%@ page import="cland.membership.Message" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'message.label', default: 'Message')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-message" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-message" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list message">
			
				<g:if test="${messageInstance?.sendCopyTo}">
				<li class="fieldcontain">
					<span id="sendCopyTo-label" class="property-label"><g:message code="message.sendCopyTo.label" default="Send Copy To" /></span>
					
						<span class="property-value" aria-labelledby="sendCopyTo-label"><g:fieldValue bean="${messageInstance}" field="sendCopyTo"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${messageInstance?.sendBlindCopyTo}">
				<li class="fieldcontain">
					<span id="sendBlindCopyTo-label" class="property-label"><g:message code="message.sendBlindCopyTo.label" default="Send Blind Copy To" /></span>
					
						<span class="property-value" aria-labelledby="sendBlindCopyTo-label"><g:fieldValue bean="${messageInstance}" field="sendBlindCopyTo"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${messageInstance?.outcome}">
				<li class="fieldcontain">
					<span id="outcome-label" class="property-label"><g:message code="message.outcome.label" default="Outcome" /></span>
					
						<span class="property-value" aria-labelledby="outcome-label"><g:fieldValue bean="${messageInstance}" field="outcome"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${messageInstance?.status}">
				<li class="fieldcontain">
					<span id="status-label" class="property-label"><g:message code="message.status.label" default="Status" /></span>
					
						<span class="property-value" aria-labelledby="status-label"><g:fieldValue bean="${messageInstance}" field="status"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${messageInstance?.dateSent}">
				<li class="fieldcontain">
					<span id="dateSent-label" class="property-label"><g:message code="message.dateSent.label" default="Date Sent" /></span>
					
						<span class="property-value" aria-labelledby="dateSent-label"><g:formatDate date="${messageInstance?.dateSent}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${messageInstance?.sendFrom}">
				<li class="fieldcontain">
					<span id="sendFrom-label" class="property-label"><g:message code="message.sendFrom.label" default="Send From" /></span>
					
						<span class="property-value" aria-labelledby="sendFrom-label"><g:fieldValue bean="${messageInstance}" field="sendFrom"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${messageInstance?.dateCreated}">
				<li class="fieldcontain">
					<span id="dateCreated-label" class="property-label"><g:message code="message.dateCreated.label" default="Date Created" /></span>
					
						<span class="property-value" aria-labelledby="dateCreated-label"><g:formatDate date="${messageInstance?.dateCreated}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${messageInstance?.hashcode}">
				<li class="fieldcontain">
					<span id="hashcode-label" class="property-label"><g:message code="message.hashcode.label" default="Hashcode" /></span>
					
						<span class="property-value" aria-labelledby="hashcode-label"><g:fieldValue bean="${messageInstance}" field="hashcode"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${messageInstance?.lastUpdated}">
				<li class="fieldcontain">
					<span id="lastUpdated-label" class="property-label"><g:message code="message.lastUpdated.label" default="Last Updated" /></span>
					
						<span class="property-value" aria-labelledby="lastUpdated-label"><g:formatDate date="${messageInstance?.lastUpdated}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${messageInstance?.message}">
				<li class="fieldcontain">
					<span id="message-label" class="property-label"><g:message code="message.message.label" default="Message" /></span>
					
						<span class="property-value" aria-labelledby="message-label"><g:fieldValue bean="${messageInstance}" field="message"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${messageInstance?.sendTo}">
				<li class="fieldcontain">
					<span id="sendTo-label" class="property-label"><g:message code="message.sendTo.label" default="Send To" /></span>
					
						<span class="property-value" aria-labelledby="sendTo-label"><g:fieldValue bean="${messageInstance}" field="sendTo"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${messageInstance?.senderEmail}">
				<li class="fieldcontain">
					<span id="senderEmail-label" class="property-label"><g:message code="message.senderEmail.label" default="Sender Email" /></span>
					
						<span class="property-value" aria-labelledby="senderEmail-label"><g:fieldValue bean="${messageInstance}" field="senderEmail"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${messageInstance?.senderIpAddress}">
				<li class="fieldcontain">
					<span id="senderIpAddress-label" class="property-label"><g:message code="message.senderIpAddress.label" default="Sender Ip Address" /></span>
					
						<span class="property-value" aria-labelledby="senderIpAddress-label"><g:fieldValue bean="${messageInstance}" field="senderIpAddress"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${messageInstance?.senderName}">
				<li class="fieldcontain">
					<span id="senderName-label" class="property-label"><g:message code="message.senderName.label" default="Sender Name" /></span>
					
						<span class="property-value" aria-labelledby="senderName-label"><g:fieldValue bean="${messageInstance}" field="senderName"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${messageInstance?.senderTel}">
				<li class="fieldcontain">
					<span id="senderTel-label" class="property-label"><g:message code="message.senderTel.label" default="Sender Tel" /></span>
					
						<span class="property-value" aria-labelledby="senderTel-label"><g:fieldValue bean="${messageInstance}" field="senderTel"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${messageInstance?.subject}">
				<li class="fieldcontain">
					<span id="subject-label" class="property-label"><g:message code="message.subject.label" default="Subject" /></span>
					
						<span class="property-value" aria-labelledby="subject-label"><g:fieldValue bean="${messageInstance}" field="subject"/></span>
					
				</li>
				</g:if>
			
			</ol>
			<g:form url="[resource:messageInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${messageInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
