
<%@ page import="cland.membership.VisitBooking" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'visitBooking.label', default: 'VisitBooking')}" />
		<title>Visit Bookings</title>
	</head>
	<body>
		<a href="#list-visitBooking" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav navpage" role="navigation">
			<ul>
				<li><g:link class="create" action="create">Book a Visit</g:link></li>
			</ul>
		</div>
		<div id="list-visitBooking" class="content scaffold-list" role="main">
			<h1>My Bookings</h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table class="inner-table">
			<thead>
					<tr>
						<g:sortableColumn property="bookingDate" title="${message(code: 'visitBooking.bookingDate.label', default: 'Date/Time')}" />
						<g:sortableColumn property="bookingDuration" title="${message(code: 'visitBooking.bookingDuration.label', default: 'Hours')}" />
						<th><g:message code="visitBooking.office.label" default="Play Centre" /></th>
						<g:sortableColumn property="referenceNo" title="${message(code: 'visitBooking.referenceNo.label', default: 'Reference No')}" />
						<g:sortableColumn property="dateCreated" title="${message(code: 'visitBooking.children.label', default: 'Child')}" />
					</tr>
				</thead>
				<tbody>
				<g:each in="${visitBookingInstanceList}" status="i" var="visitBookingInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${visitBookingInstance.id}">${visitBookingInstance?.bookingDate?.format('dd-MMM-yyyy HH:mm')}Hrs</g:link></td>
						<td>${fieldValue(bean: visitBookingInstance, field: "bookingDuration")}</td>					
						<td>${fieldValue(bean: visitBookingInstance, field: "office")}</td>	
						<td>${fieldValue(bean: visitBookingInstance, field: "referenceNo")}</td>				
						<td>${visitBookingInstance?.children*.toString()}</td>					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${visitBookingInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
