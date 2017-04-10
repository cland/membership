<%@ page import="cland.membership.SystemRoles" %>
<%@ page import="cland.membership.VisitBooking" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'visitBooking.label', default: 'VisitBooking')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-visitBooking" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav navpage" role="navigation">
			<ul>
				<li><g:link class="create" action="create">Book a Visit</g:link></li>
			</ul>
		</div>
		<div id="show-visitBooking" class="content scaffold-show" role="main">
			<h1>Booking</h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list visitBooking">
				<g:if test="${visitBookingInstance?.referenceNo}">
					<li class="fieldcontain">
						<span id="referenceNo-label" class="property-label"><g:message code="visitBooking.referenceNo.label" default="Reference No" /></span>
						
							<span class="property-value" aria-labelledby="referenceNo-label"><g:fieldValue bean="${visitBookingInstance}" field="referenceNo"/></span>
						
					</li>
				</g:if>
				<g:if test="${visitBookingInstance?.bookingDate}">
				<li class="fieldcontain">
					<span id="bookingDate-label" class="property-label"><g:message code="visitBooking.bookingDate.label" default="Booking Date" /></span>
					
						<span class="property-value" aria-labelledby="bookingDate-label"><g:formatDate date="${visitBookingInstance?.bookingDate}" /></span>
					
				</li>
				</g:if>
				<g:if test="${visitBookingInstance?.bookingDuration}">
					<li class="fieldcontain">
						<span id="bookingDuration-label" class="property-label"><g:message code="visitBooking.bookingDuration.label" default="Duration (Hours)" /></span>
						
							<span class="property-value" aria-labelledby="referenceNo-label"><g:fieldValue bean="${visitBookingInstance}" field="bookingDuration"/></span>
						
					</li>
				</g:if>
				<g:if test="${visitBookingInstance?.office}">
				<li class="fieldcontain">
					<span id="office-label" class="property-label"><g:message code="visitBooking.office.label" default="Wiggly Toes Play Centre" /></span>
					
						<span class="property-value" aria-labelledby="office-label">${visitBookingInstance?.office?.encodeAsHTML()}</span>
					
				</li>
				</g:if>
				<g:if test="${visitBookingInstance?.parent}">
				<li class="fieldcontain">
					<span id="parent-label" class="property-label"><g:message code="visitBooking.parent.label" default="Parent/Guardian" /></span>
					
						<span class="property-value" aria-labelledby="parent-label"><g:link controller="parent" action="show" id="${visitBookingInstance?.parent?.id}">${visitBookingInstance?.parent?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
				<g:if test="${visitBookingInstance?.children}">
				<li class="fieldcontain">
					<span id="children-label" class="property-label"><g:message code="visitBooking.children.label" default="Children" /></span>
					
						<g:each in="${visitBookingInstance.children}" var="c">
						<span class="property-value" aria-labelledby="children-label"><g:link controller="child" action="show" id="${c.id}">${c?.encodeAsHTML()}</g:link></span>
						</g:each>
					
				</li>
				</g:if>
				<g:if test="${visitBookingInstance?.status}">
					<li class="fieldcontain">
						<span id="children-label" class="property-label"><g:message code="visitBooking.status.label" default="Status" /></span>
						<span class="property-value" aria-labelledby="status-label"><g:fieldValue bean="${visitBookingInstance}" field="status"/></span>
					</li>
				</g:if>
				<g:if test="${visitBookingInstance?.comments}">
				<li class="fieldcontain">
					<span id="comments-label" class="property-label"><g:message code="visitBooking.comments.label" default="Comments" /></span>
					
						<span class="property-value" aria-labelledby="comments-label"><g:fieldValue bean="${visitBookingInstance}" field="comments"/></span>
					
				</li>
				</g:if>
				<g:if test="${visitBookingInstance?.dateCreated}">
				<li class="fieldcontain">
					<span id="dateCreated-label" class="property-label"><g:message code="visitBooking.dateCreated.label" default="Date Created" /></span>
					
						<span class="property-value" aria-labelledby="dateCreated-label"><g:formatDate date="${visitBookingInstance?.dateCreated}" /></span>
					
				</li>
				</g:if>

			</ol>
			<g:form url="[resource:visitBookingInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${visitBookingInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<sec:ifAnyGranted roles="${SystemRoles.ROLE_ADMIN },${SystemRoles.ROLE_DEVELOPER },${SystemRoles.ROLE_MANAGER },${SystemRoles.ROLE_ASSISTANT }">
						<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
					</sec:ifAnyGranted>
					
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
