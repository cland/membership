
<%@ page import="cland.membership.Settings" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'settings.label', default: 'Settings')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-settings" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav pagenav" role="navigation">
			<ul>				
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-settings" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
					
						<g:sortableColumn property="description" title="${message(code: 'settings.description.label', default: 'Description')}" />
					
						<g:sortableColumn property="visitcount" title="${message(code: 'settings.visitcount.label', default: 'Visitcount')}" />
					
						<g:sortableColumn property="notifytime" title="${message(code: 'settings.notifytime.label', default: 'Notifytime')}" />
					
						<g:sortableColumn property="timereminder" title="${message(code: 'settings.timereminder.label', default: 'Timereminder')}" />
					
						<g:sortableColumn property="sickchild" title="${message(code: 'settings.sickchild.label', default: 'Sickchild')}" />
					
						<g:sortableColumn property="problemchild" title="${message(code: 'settings.problemchild.label', default: 'Problemchild')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${settingsInstanceList}" status="i" var="settingsInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${settingsInstance.id}">${fieldValue(bean: settingsInstance, field: "description")}</g:link></td>
					
						<td>${fieldValue(bean: settingsInstance, field: "visitcount")}</td>
					
						<td>${fieldValue(bean: settingsInstance, field: "notifytime")}</td>
					
						<td>${fieldValue(bean: settingsInstance, field: "timereminder")}</td>
					
						<td>${fieldValue(bean: settingsInstance, field: "sickchild")}</td>
					
						<td>${fieldValue(bean: settingsInstance, field: "problemchild")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${settingsInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
