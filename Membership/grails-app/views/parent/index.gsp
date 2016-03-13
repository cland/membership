
<%@ page import="cland.membership.Parent" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'parent.label', default: 'Parent')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-parent" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-parent" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
					
						<g:sortableColumn property="date" title="${message(code: 'parent.date.label', default: 'Date')}" />
					
						<th><g:message code="parent.person1.label" default="Person1" /></th>
					
						<th><g:message code="parent.person2.label" default="Person2" /></th>
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${parentInstanceList}" status="i" var="parentInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${parentInstance.id}">${fieldValue(bean: parentInstance.person1, field: "firstName")}</g:link></td>
					
						<td>${fieldValue(bean: parentInstance, field: "person1")}</td>
					
						<td>${fieldValue(bean: parentInstance, field: "person2")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${parentInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
