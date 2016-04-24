<%@ page import="cland.membership.Booking" %>



<div class="fieldcontain ${hasErrors(bean: bookingInstance, field: 'numKids', 'error')} ">
	<label for="numKids">
		<g:message code="booking.numKids.label" default="Num Kids" />
		
	</label>
	<g:field name="numKids" type="number" value="${bookingInstance.numKids}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: bookingInstance, field: 'numAduls', 'error')} ">
	<label for="numAduls">
		<g:message code="booking.numAdults.label" default="Num Adults" />
		
	</label>
	<g:field name="numAduls" type="number" value="${bookingInstance.numAdults}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: bookingInstance, field: 'person', 'error')} required">
	<label for="parent">
		<g:message code="booking.parent.label" default="Contact parent" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="parent" name="parent.id" from="${cland.membership.Parent.list()}" optionKey="id" required="" value="${bookingInstance?.parent?.id}" class="many-to-one"/>

</div>

