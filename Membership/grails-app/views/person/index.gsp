
<%@ page import="cland.membership.security.Person" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'person.label', default: 'Person')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-person" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-person" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
					
						<g:sortableColumn property="username" title="${message(code: 'person.username.label', default: 'Username')}" />
					
						<g:sortableColumn property="firstName" title="${message(code: 'person.firstName.label', default: 'First Name')}" />
					
						<th><g:message code="person.race.label" default="Race" /></th>
					
						<g:sortableColumn property="accountExpired" title="${message(code: 'person.accountExpired.label', default: 'Account Expired')}" />
					
						<g:sortableColumn property="knownAs" title="${message(code: 'person.knownAs.label', default: 'Known As')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${personInstanceList}" status="i" var="personInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${personInstance.id}">${fieldValue(bean: personInstance, field: "username")}</g:link></td>
					
						<td>${fieldValue(bean: personInstance, field: "firstName")}</td>
					
						<td>${fieldValue(bean: personInstance, field: "race")}</td>
					
						<td><g:formatBoolean boolean="${personInstance.accountExpired}" /></td>
					
						<td>${fieldValue(bean: personInstance, field: "knownAs")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${personInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
