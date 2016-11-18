<%@ page import="cland.membership.SystemRoles" %>
<%@ page import="cland.membership.Visit" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'visit.label', default: 'Visit')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-visit" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav navpage" role="navigation">
			<ul>
				
			</ul>
		</div>
		<div id="list-visit" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table class="inner-table">
			<thead>
					<tr>
					
						<th>Name</th>
						<th>Date</th>
						<th>Time-in</th>
						<th>Time-out</th>
						<th>Duration</th>
						<th>Effective Hours</th>
						<th>Contact No.</th>
						<th>Status</th>							
						<th>Wrist Band No.</th>
						<th>Office</th>
						<th>Actions</th>
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${visitInstanceList}" status="i" var="v">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link controller="child" action="show" id="${v?.child?.id}">${v?.child?.person }</g:link></td>						
						<td>${v?.starttime?.format("dd MMM yyyy")}</td>
						<td>${v?.starttime?.format("HH:mm")}</td>
						<td>${v?.endtime?.format("HH:mm")}</td>
						<td>${v?.durationText}</td>
						<td>${v?.getVisitHours()}</td>
						<td>${v?.contactNo}</td>
						<td id="row-visit-status-${c?.id}" class="status-${v?.status }">${v?.status}</td>									
						<td>
							${v?.visitNo }																
						</td>
						<td>${v?.office }</td>
						<td>
						<g:link controller="visit" action="show" id="${v?.id}">View</g:link>
						</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${visitInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
