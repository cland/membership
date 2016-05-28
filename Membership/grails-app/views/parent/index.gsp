
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
		<div class="nav navpage" role="navigation">
			<ul>				
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-parent" class="content scaffold-list" role="main">
			<h1>Client List (Parents/Guardians)</h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
					
						<th><g:message code="parent.person1.label" default="Name" /></th>
						<th><g:message code="parent.person1.mobile" default="Contact No." /></th>
						<th><g:message code="parent.person1.email" default="Email" /></th>
						<th><g:message code="parent.person1.membershipno" default="Membership No." /></th>
						<th><g:message code="parent.person2.childcount" default="No. of Children" /></th>
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${parentInstanceList}" status="i" var="parentInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${parentInstance.id}">${fieldValue(bean: parentInstance.person1, field: "lastName")},  ${fieldValue(bean: parentInstance.person1, field: "firstName")}</g:link></td>					
						<td>${fieldValue(bean: parentInstance, field: "person1.mobileNo")}</td>
						<td>${fieldValue(bean: parentInstance, field: "person1.email")}</td>	
						<td>${fieldValue(bean: parentInstance, field: "membershipNo")}</td>					
						<td>${parentInstance?.children?.size()}</td>
					
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
