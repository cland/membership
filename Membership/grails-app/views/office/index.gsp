
<%@ page import="cland.membership.Office" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'office.label', default: 'Office')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-office" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-office" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
					
						<g:sortableColumn property="name" title="${message(code: 'office.name.label', default: 'Name')}" />
					
						<g:sortableColumn property="code" title="${message(code: 'office.code.label', default: 'Code')}" />
					
						<g:sortableColumn property="status" title="${message(code: 'office.status.label', default: 'Status')}" />
					
						<g:sortableColumn property="email" title="${message(code: 'office.email.label', default: 'Email')}" />
					
						<g:sortableColumn property="contactNumber" title="${message(code: 'office.contactNumber.label', default: 'Contact Number')}" />
					
						<g:sortableColumn property="cellphoneNumber" title="${message(code: 'office.cellphoneNumber.label', default: 'Cellphone Number')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${officeInstanceList}" status="i" var="officeInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${officeInstance.id}">${fieldValue(bean: officeInstance, field: "name")}</g:link></td>
					
						<td>${fieldValue(bean: officeInstance, field: "code")}</td>
					
						<td>${fieldValue(bean: officeInstance, field: "status")}</td>
					
						<td>${fieldValue(bean: officeInstance, field: "email")}</td>
					
						<td>${fieldValue(bean: officeInstance, field: "contactNumber")}</td>
					
						<td>${fieldValue(bean: officeInstance, field: "cellphoneNumber")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${officeInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
