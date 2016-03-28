<%@ page import="cland.membership.Booking" %>



<div class="fieldcontain ${hasErrors(bean: bookingInstance, field: 'numKids', 'error')} ">
	<label for="numKids">
		<g:message code="booking.numKids.label" default="Num Kids" />
		
	</label>
	<g:field name="numKids" type="number" value="${bookingInstance.numKids}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: bookingInstance, field: 'numAduls', 'error')} ">
	<label for="numAduls">
		<g:message code="booking.numAduls.label" default="Num Aduls" />
		
	</label>
	<g:field name="numAduls" type="number" value="${bookingInstance.numAduls}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: bookingInstance, field: 'person', 'error')} required">
	<label for="person">
		<g:message code="booking.person.label" default="Person" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="person" name="person.id" from="${cland.membership.security.Person.list()}" optionKey="id" required="" value="${bookingInstance?.person?.id}" class="many-to-one"/>

</div>

