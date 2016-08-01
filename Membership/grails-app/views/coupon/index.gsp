<%@ page import="cland.membership.SystemRoles" %>
<%@ page import="cland.membership.Parent" %>
<%@ page import="cland.membership.Coupon" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'coupon.label', default: 'Coupon')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-coupon" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav  navpage" role="navigation">
			<ul>				
				
			</ul>
		</div>
		<div id="list-coupon" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table class="inner-table">
			<thead>
					<tr>
						<th>Client</th>											
						<th>Coupon No.</th>
						<th>Date Activated</th>								
						<th>Total Visits</th>																
						<th>Visits Left</th>
						<th>Expiry Date</th>
						<th class="hide">Actions</th>
					</tr>
				</thead>
				<tbody>
				<g:each in="${couponInstanceList}" status="i" var="couponInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">	
						<td><g:link controller="parent" action="show" id="${couponInstance?.parent?.id}" params="[tab:4]">${couponInstance?.parent?.person1 }</g:link></td>									
						<td>${couponInstance?.refNo }</td>
						<td>${couponInstance?.startDate?.format("dd MMM yyyy")}</td>
						<td>${couponInstance?.maxvisits}</td>							
						<td>${couponInstance?.visitsLeft}</td>
						<td>${couponInstance?.expiryDate?.format("dd MMM yyyy")}</td>
						<td class="hide">
							<sec:ifAnyGranted roles="${SystemRoles.ROLE_ADMIN },${SystemRoles.ROLE_DEVELOPER },${SystemRoles.ROLE_MANAGER },${SystemRoles.ROLE_ASSISTANT }">
								<asset:image src="skin/icon_delete.png" class="delete-coupon-icon" onClick="rmCoupon('${note?.id }');" id="del_${note?.id }" title="Delete this entry" alt="Delete this entry!"/>
								<asset:image src="spinner.gif" class="spinner-wait hide" id="spinner-wait-${note?.id }" title="Processing, please wait..." alt="Processing, please wait...!"/>
								<asset:image src="skin/database_edit.png" class="edit-coupon-icon" onClick="editCoupon('${note?.id }');" id="edit_${note?.id }" title="Edit this entry" alt="Edit entry!"/>											
							</sec:ifAnyGranted>
						</td>					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${couponInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
