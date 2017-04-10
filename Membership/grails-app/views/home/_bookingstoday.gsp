<%@ page import="cland.membership.lookup.*" %>
<%@ page import="cland.membership.SystemRoles" %>
<%@ page import="cland.membership.VisitBooking" %>
<% def grpchildcount=settings?.maxbooking %>

<table class="inner-table">
	<thead>
		<tr>
			<g:sortableColumn property="bookingDate" title="${message(code: 'visitBooking.bookingDate.label', default: 'Date/Time')}"/>
			<g:sortableColumn property="bookingDuration" title="${message(code: 'visitBooking.bookingDuration.label', default: 'Hours')}" class="col-not-important"/>
			<th class="col-not-important"><g:message code="visitBooking.office.label" default="Play Centre" /></th>
			<g:sortableColumn property="referenceNo" title="${message(code: 'visitBooking.referenceNo.label', default: 'Reference No')}" />
			<g:sortableColumn property="children" title="${message(code: 'visitBooking.children.label', default: 'Child')}" />
			<th class="col-not-important" style="width:30%;">Comments</th>
		</tr>
	</thead>
	<tbody>
	<g:each in="${visitBookingInstanceList}" status="i" var="visitBookingInstance">
		<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
		
			<td><g:link controller="visitBooking" action="show" id="${visitBookingInstance.id}">${visitBookingInstance?.bookingDate?.format('dd-MMM-yyyy HH:mm')}Hrs</g:link></td>
			<td class="col-not-important">${fieldValue(bean: visitBookingInstance, field: "bookingDuration")}</td>					
			<td class="col-not-important">${fieldValue(bean: visitBookingInstance, field: "office")}</td>	
			<td>${fieldValue(bean: visitBookingInstance, field: "referenceNo")}</td>				
			<td>${visitBookingInstance?.children*.toString()}</td>	
			<td class="col-not-important">${visitBookingInstance?.comments}</td>				
		</tr>
	</g:each>
	</tbody>
</table>
