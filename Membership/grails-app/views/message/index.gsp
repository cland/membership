
<%@ page import="cland.membership.Message" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'message.label', default: 'Message')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-message" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-message" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
					
						<g:sortableColumn property="sendTo" title="${message(code: 'message.sendTo.label', default: 'Send To')}" />
					
						<g:sortableColumn property="sendBlindCopyTo" title="${message(code: 'message.sendBlindCopyTo.label', default: 'Send Blind Copy To')}" />
						<g:sortableColumn property="status" title="${message(code: 'message.status.label', default: 'Status')}" />
						<g:sortableColumn property="dateSent" title="${message(code: 'message.dateSent.label', default: 'Date Sent')}" />
						<g:sortableColumn property="hashcode" title="${message(code: 'message.hashcode.label', default: 'Hash Code')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${messageInstanceList}" status="i" var="messageInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${messageInstance.id}">${fieldValue(bean: messageInstance, field: "sendTo")}</g:link></td>					
						<td>${fieldValue(bean: messageInstance, field: "sendBlindCopyTo")}</td>					
						<td>${fieldValue(bean: messageInstance, field: "status")}</td>					
						<td><g:formatDate date="${messageInstance.dateSent}" /></td>					
						<td>${fieldValue(bean: messageInstance, field: "hashcode")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${messageInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
