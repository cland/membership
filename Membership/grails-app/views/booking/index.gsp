
<%@ page import="cland.membership.Booking" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'booking.label', default: 'Booking')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-booking" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav navpage" style="display:none" role="navigation">
			<ul>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-booking" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /> (Birthdays/Group)</h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
						<th><g:message code="booking.person.label" default="Contact Person" /></th>
						<th><g:message code="booking.date.label" default="Date" />	
						<th><g:message code="booking.timeslot.label" default="Time" />	
						<th><g:message code="booking.mobile.label" default="Contact No." />												
						<g:sortableColumn property="numKids" title="${message(code: 'booking.numKids.label', default: 'No. of Kids')}" />					
						<g:sortableColumn property="numAduls" title="${message(code: 'booking.numAdults.label', default: 'No. of Adults')}" />					
						<th><g:message code="booking.person.label" default="Birthday Child" /></th>
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${bookingInstanceList}" status="i" var="bookingInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
						<td><g:link action="show" id="${bookingInstance.id}">${fieldValue(bean: bookingInstance, field: "parent")}</g:link></td>
						<td>${bookingInstance?.bookingDate?.format("dd MMM yyyy") }</td>
						<td>${bookingInstance?.timeslot?.label}</td>
						<td>${bookingInstance?.parent?.person1?.mobileNo}</td>							
						<td>${fieldValue(bean: bookingInstance, field: "numKids")}</td>					
						<td>${fieldValue(bean: bookingInstance, field: "numAdults")}</td>
						<td>${fieldValue(bean: bookingInstance, field: "birthdayChild")}</td>									
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${bookingInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
