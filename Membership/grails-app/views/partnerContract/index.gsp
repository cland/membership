
<%@ page import="cland.membership.PartnerContract" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'partnerContract.label', default: 'PartnerContract')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-partnerContract" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav navpage" role="navigation">
			<ul>
				
			</ul>
		</div>
		<div id="list-partnerContract" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>											
						<g:sortableColumn property="contractNo" title="${message(code: 'partnerContract.contractNo.label', default: 'Contract No')}" />
						<th>Parent</th>
						<th>Partner</th>					
						<g:sortableColumn property="dateCreated" title="${message(code: 'partnerContract.dateCreated.label', default: 'Date Created')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${partnerContractInstanceList}" status="i" var="partnerContractInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${partnerContractInstance.id}">${fieldValue(bean: partnerContractInstance, field: "contractNo")}</g:link></td>
						<td><g:link controller="parent" action="show" id="${partnerContractInstance?.parent.id}">${partnerContractInstance?.parent }</g:link></td>
						<td><g:link controller="partner" action="show" id="${partnerContractInstance?.partner.id}">${partnerContractInstance?.partner }</g:link></td>
						<td><g:formatDate date="${partnerContractInstance.dateCreated}" /></td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${partnerContractInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
