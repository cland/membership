<%@ page import="cland.membership.VisitBooking" %>



<div class="fieldcontain ${hasErrors(bean: visitBookingInstance, field: 'lastUpdatedBy', 'error')} required">
	<label for="lastUpdatedBy">
		<g:message code="visitBooking.lastUpdatedBy.label" default="Last Updated By" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="lastUpdatedBy" type="number" value="${visitBookingInstance.lastUpdatedBy}" required=""/>

</div>

<div class="fieldcontain ${hasErrors(bean: visitBookingInstance, field: 'createdBy', 'error')} required">
	<label for="createdBy">
		<g:message code="visitBooking.createdBy.label" default="Created By" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="createdBy" type="number" value="${visitBookingInstance.createdBy}" required=""/>

</div>

<div class="fieldcontain ${hasErrors(bean: visitBookingInstance, field: 'history', 'error')} ">
	<label for="history">
		<g:message code="visitBooking.history.label" default="History" />
		
	</label>
	<g:textField name="history" readonly="readonly" value="${visitBookingInstance?.history}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: visitBookingInstance, field: 'comments', 'error')} ">
	<label for="comments">
		<g:message code="visitBooking.comments.label" default="Comments" />
		
	</label>
	<g:textField name="comments" value="${visitBookingInstance?.comments}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: visitBookingInstance, field: 'office', 'error')} ">
	<label for="office">
		<g:message code="visitBooking.office.label" default="Office" />
		
	</label>
	<g:select id="office" name="office.id" from="${cland.membership.Office.list()}" optionKey="id" value="${visitBookingInstance?.office?.id}" class="many-to-one" noSelection="['null': '']"/>

</div>

<div class="fieldcontain ${hasErrors(bean: visitBookingInstance, field: 'referenceNo', 'error')} required">
	<label for="referenceNo">
		<g:message code="visitBooking.referenceNo.label" default="Reference No" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="referenceNo" required="" value="${visitBookingInstance?.referenceNo}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: visitBookingInstance, field: 'bookingDate', 'error')} required">
	<label for="bookingDate">
		<g:message code="visitBooking.bookingDate.label" default="Booking Date" />
		<span class="required-indicator">*</span>
	</label>
	<g:datePicker name="bookingDate" precision="day"  value="${visitBookingInstance?.bookingDate}"  />

</div>

<div class="fieldcontain ${hasErrors(bean: visitBookingInstance, field: 'children', 'error')} ">
	<label for="children">
		<g:message code="visitBooking.children.label" default="Children" />
		
	</label>
	<g:select name="children" from="${cland.membership.Child.list()}" multiple="multiple" optionKey="id" size="5" value="${visitBookingInstance?.children*.id}" class="many-to-many"/>

</div>

<div class="fieldcontain ${hasErrors(bean: visitBookingInstance, field: 'parent', 'error')} required">
	<label for="parent">
		<g:message code="visitBooking.parent.label" default="Parent" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="parent" name="parent.id" from="${cland.membership.Parent.list()}" optionKey="id" required="" value="${visitBookingInstance?.parent?.id}" class="many-to-one"/>

</div>

