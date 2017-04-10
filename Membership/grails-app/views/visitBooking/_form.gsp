<%@ page import="cland.membership.VisitBooking" %>
<%@ page import="cland.membership.SystemRoles" %>

<div class="fieldcontain ${hasErrors(bean: visitBookingInstance, field: 'bookingDate', 'error')} required">
	<label for="bookingDate">
		<g:message code="visitBooking.bookingDate.label" default="Date" />
		<span class="required-indicator">*</span>
	</label>	
	
	<g:textField name="bookingDate" required="" id="booking-date" class="datepick_single_past" value="${visitBookingInstance?.bookingDate?.format('dd-MMM-yyyy HH:mm')}"/>
	
</div>
<div class="fieldcontain ${hasErrors(bean: visitBookingInstance, field: 'bookingDuration', 'error')} required">
	<label for="bookingDuration">
		<g:message code="visitBooking.bookingDuration.label" default="For how many hours?" />
		<span class="required-indicator">*</span>
	</label>	
	<g:textField name="bookingDuration" required="" id="booking-duration" value="${visitBookingInstance?.bookingDuration}"/>
</div>
<div class="fieldcontain ${hasErrors(bean: visitBookingInstance, field: 'office', 'error')} ">
	<label for="office">
		<g:message code="visitBooking.office.label" default="Wiggly Play Centre" />		
	</label>
	<g:select id="office" name="office.id" from="${cland.membership.Office.findAll{code!='WA101'}}" optionKey="id" value="${visitBookingInstance?.office?.id}" required="" class="many-to-one" noSelection="['null': '']"/>

</div>
<div class="fieldcontain ${hasErrors(bean: visitBookingInstance, field: 'children', 'error')} ">
	<label for="children">
		<g:message code="visitBooking.children.label" default="Who are you bringing play?" />
		
	</label>
	
	<g:each var="child" in="${visitBookingInstance?.parent?.children}">
		<g:checkBox name="children" value="${child.id}" checked="${visitBookingInstance?.children?.contains(child)}"/> ${child }		
	</g:each>

</div>

<sec:ifAnyGranted roles="${SystemRoles.ROLE_ADMIN },${SystemRoles.ROLE_DEVELOPER },${SystemRoles.ROLE_MANAGER },${SystemRoles.ROLE_ASSISTANT }">
	<div class="fieldcontain ${hasErrors(bean: visitBookingInstance, field: 'parent', 'error')} required">
		<label for="parent">
			<g:message code="visitBooking.parent.label" default="Parent" />
			<span class="required-indicator">*</span>
		</label>	
		<g:select id="parent" name="parent.id" from="${cland.membership.Parent.list()}" optionKey="id" required="" value="${visitBookingInstance?.parent?.id}" class="many-to-one"/>			
	</div>
	<div class="fieldcontain ${hasErrors(bean: visitBookingInstance, field: 'status', 'error')} required">
		<label for="status">
			<g:message code="visitBooking.status.label" default="Status" />
		</label>	
	<g:textField name="status" id="status" value="${visitBookingInstance?.status}"/>
</div>
</sec:ifAnyGranted>
<sec:ifNotGranted roles="${SystemRoles.ROLE_ADMIN },${SystemRoles.ROLE_DEVELOPER },${SystemRoles.ROLE_MANAGER },${SystemRoles.ROLE_ASSISTANT }">
	<input type="hidden" id="parent" name="parent.id" value="${visitBookingInstance?.parent?.id}"/>
</sec:ifNotGranted>
<div class="fieldcontain ${hasErrors(bean: visitBookingInstance, field: 'comments', 'error')} ">
	<label for="comments">
		<g:message code="visitBooking.comments.label" default="Comments" />
		
	</label>	
	<g:textArea name="comments">${visitBookingInstance?.comments}</g:textArea>
</div>
<script>
	$(document).ready(function() {	
		//setup the time pickers			
		initTimePicker($("#booking-date"),"")	
		$(document).on("change","#booking-date",function(){
			
			var now = new Date()
			var timenow = now.getHours() + ":" + now.getMinutes();
			var selected = $(this).prop("value").split(" ")
			var datesel = selected[0]
			var timesel = selected[1]
			
		})														               
	});  
	function initTimePicker(el,def){	
				
		el.datetimepicker({
			controlType: 'select',
			oneLine: true,
			timeFormat: 'HH:mm', // 'hh:mm tt',
			dateFormat: "dd-M-yy",
			minDate:"0d",
			maxDate:"14d",
			altFormat: "yy-mm-dd",
			altTimeFormat : "HH:mm",
			altFieldTimeOnly: false,			
			minTime:"09:00",
			maxtime:"12:00",
			stepMinute: 5
		});
		//el.prop("value",getAussieDate("DD-MMM-YYYY HH:mm"))
	}
</script>	