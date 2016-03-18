
<%@ page import="cland.membership.lookup.Keywords" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'keywords.label', default: 'Keywords')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-keywords" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav navpage" role="navigation">
			<ul>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-keywords" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
					
						<g:sortableColumn property="name" title="${message(code: 'keywords.name.label', default: 'Name')}" />
					
						<g:sortableColumn property="category" title="${message(code: 'keywords.category.label', default: 'Category')}" />
					
						<g:sortableColumn property="description" title="${message(code: 'keywords.description.label', default: 'Description')}" />
					
						<g:sortableColumn property="label" title="${message(code: 'keywords.label.label', default: 'Label')}" />
					
						<g:sortableColumn property="lastUpdatedBy" title="${message(code: 'keywords.lastUpdatedBy.label', default: 'Last Updated By')}" />
					
						<g:sortableColumn property="createdBy" title="${message(code: 'keywords.createdBy.label', default: 'Created By')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${keywordsInstanceList}" status="i" var="keywordsInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${keywordsInstance.id}">${fieldValue(bean: keywordsInstance, field: "name")}</g:link></td>
					
						<td>${fieldValue(bean: keywordsInstance, field: "category")}</td>
					
						<td>${fieldValue(bean: keywordsInstance, field: "description")}</td>
					
						<td>${fieldValue(bean: keywordsInstance, field: "label")}</td>
					
						<td>${fieldValue(bean: keywordsInstance, field: "lastUpdatedBy")}</td>
					
						<td>${fieldValue(bean: keywordsInstance, field: "createdBy")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${keywordsInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
