
<%@ page import="cland.membership.Child" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'child.label', default: 'Child')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-child" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav navpage" role="navigation">
			<ul>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-child" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
						<th><g:message code="child.person.label" default="Child Name" /></th>
						<th>Access Number</th>						
						<th>Age</th>
						<th>Gender</th>
						<th>Visits</th>
						<th><g:message code="child.parent.label" default="Parent" /></th>
						<th>Mobile</th>
						<th>Email</th>
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${childInstanceList}" status="i" var="childInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
						<td><g:link action="show" id="${childInstance.id}">${fieldValue(bean: childInstance, field: "person")}</g:link></td>
						<td>${fieldValue(bean: childInstance, field: "person.accessNumber")}</td>
						<td>${fieldValue(bean: childInstance, field: "person.age")}</td>
						<td>${fieldValue(bean: childInstance, field: "person.gender")}</td>
						<td>${fieldValue(bean: childInstance, field: "parent.person.mobileNo")}</td>
						<td><g:link action="show" id="${childInstance.parent.id}">${fieldValue(bean: childInstance, field: "parent")}</g:link></td>
						<td>${fieldValue(bean: childInstance, field: "parent.person.mobileNo")}</td>
						<td>${fieldValue(bean: childInstance, field: "parent.person.email")}</td>
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${childInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
