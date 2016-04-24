
<%@ page import="cland.membership.Booking" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'booking.label', default: 'Booking')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-booking" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav navpage"  style="display:none" role="navigation">
			<ul>
				<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-booking" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list booking">
			
				<g:if test="${bookingInstance?.numKids}">
				<li class="fieldcontain">
					<span id="numKids-label" class="property-label"><g:message code="booking.numKids.label" default="Num Kids" /></span>
					
						<span class="property-value" aria-labelledby="numKids-label"><g:fieldValue bean="${bookingInstance}" field="numKids"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bookingInstance?.numAdults}">
				<li class="fieldcontain">
					<span id="numAduls-label" class="property-label"><g:message code="booking.numAduls.label" default="Num Aduls" /></span>
					
						<span class="property-value" aria-labelledby="numAduls-label"><g:fieldValue bean="${bookingInstance}" field="numAdults"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bookingInstance?.parent}">
				<li class="fieldcontain">
					<span id="person-label" class="property-label"><g:message code="booking.person.label" default="Contact person" /></span>
					
						<span class="property-value" aria-labelledby="person-label"><g:link controller="person" action="show" id="${bookingInstance?.parent?.id}">${bookingInstance?.parent?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
			</ol>
			<g:form url="[resource:bookingInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${bookingInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
