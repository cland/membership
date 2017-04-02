
<%@ page import="cland.membership.Partner" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'partner.label', default: 'Partner')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-partner" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav navpage" role="navigation">
			<ul>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-partner" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
						<g:sortableColumn property="partnerCode" title="${message(code: 'partner.name.label', default: 'Name')}" />
						<g:sortableColumn property="partnerCode" title="${message(code: 'partner.partnerCode.label', default: 'Partner Code')}" />											
						<th><g:message code="partner.partnerIndustry.label" default="Partner Industry" /></th>
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${partnerInstanceList}" status="i" var="partnerInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${partnerInstance.id}">${fieldValue(bean: partnerInstance, field: "name")}</g:link></td>
						<td><g:link action="show" id="${partnerInstance.id}">${fieldValue(bean: partnerInstance, field: "partnerCode")}</g:link></td>
										
						<td>${fieldValue(bean: partnerInstance, field: "partnerIndustry")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${partnerInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>