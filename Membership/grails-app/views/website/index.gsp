
<%@ page import="cland.membership.Website" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'website.label', default: 'Website')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-website" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-website" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
						<g:sortableColumn property="sendTo" title="${message(code: 'website.sendTo.label', default: 'Send To')}" />
						<g:sortableColumn property="sendBlindCopyTo" title="${message(code: 'website.sendBlindCopyTo.label', default: 'Send Blind Copy To')}" />					
						<g:sortableColumn property="sendFrom" title="${message(code: 'website.sendFrom.label', default: 'Send From')}" />
					
						<g:sortableColumn property="subjectTemplate" title="${message(code: 'website.subjectTemplate.label', default: 'Subject Template')}" />
					
						
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${websiteInstanceList}" status="i" var="websiteInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
						
						<td><g:link action="show" id="${websiteInstance.id}">${fieldValue(bean: websiteInstance, field: "sendTo")}</g:link></td>					
						<td>${fieldValue(bean: websiteInstance, field: "sendBlindCopyTo")}</td>
						<td>${fieldValue(bean: websiteInstance, field: "sendFrom")}</td>					
						<td>${fieldValue(bean: websiteInstance, field: "subjectTemplate")}</td>				
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${websiteInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
