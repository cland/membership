
<%@ page import="cland.membership.VisitBooking" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'visitBooking.label', default: 'VisitBooking')}" />
		<title>All Bookings</title>
	</head>
	<body>
		<a href="#list-visitBooking" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav navpage" role="navigation">
			<ul>
				<li><g:link class="create" action="create">Book a Visit</g:link></li>
				<li><g:link class="list" action="index">Upcoming Bookings</g:link></li>
			</ul>
		</div>
		<div id="list-visitBooking" class="content scaffold-list" role="main">
			<h1>All Bookings</h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table class="inner-table">
			<thead>
					<tr>
						<g:sortableColumn property="bookingDate" title="${message(code: 'visitBooking.bookingDate.label', default: 'Date/Time')}"/>
						<g:sortableColumn property="bookingDuration" title="${message(code: 'visitBooking.bookingDuration.label', default: 'Hours')}" class="col-not-important"/>
						<th class="col-not-important"><g:message code="visitBooking.office.label" default="Play Centre" /></th>
						<g:sortableColumn property="referenceNo" title="${message(code: 'visitBooking.referenceNo.label', default: 'Reference No')}" />
						<th class="col-not-important"><g:message code="visitBooking.children.label" default="Child" /></th>						
						<g:sortableColumn property="status" title="${message(code: 'visitBooking.status.label', default: 'Status')}" />
						<th>Actions</th>
					</tr>
				</thead>
				<tbody>
				<g:each in="${visitBookingInstanceList}" status="i" var="visitBookingInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${visitBookingInstance.id}">${visitBookingInstance?.bookingDate?.format('dd-MMM-yyyy HH:mm')}Hrs</g:link></td>
						<td class="col-not-important">${fieldValue(bean: visitBookingInstance, field: "bookingDuration")}</td>					
						<td class="col-not-important">${fieldValue(bean: visitBookingInstance, field: "office")}</td>	
						<td>${fieldValue(bean: visitBookingInstance, field: "referenceNo")}</td>				
						<td class="col-not-important">${visitBookingInstance?.children*.toString()}</td>
						<td id="cell-booking-status-${visitBookingInstance?.id}">${visitBookingInstance?.status }</td>	
						<td>
							<g:if test="${visitBookingInstance?.status?.equalsIgnoreCase('new')}">							
								<asset:image src="skin/icon_cross.png" class="cancel-icon" onClick="setBookingStatus('${visitBookingInstance?.id }','cancelled');return false;" id="rm-booking-${visitBookingInstance?.id }" title="Cancel this booking!" alt="Cancel this booking!"/>
								&nbsp;
								<img src='${fam.icon(name: 'tick')}' class="done-icon" onClick="setBookingStatus('${visitBookingInstance?.id }','done');return false;" id="done-booking_${visitBookingInstance?.id }" title="Mark this as done" alt="Mark this as done!"/>
								
							</g:if>
							<asset:image src="spinner.gif" class="spinner-booking-wait hide" id="spinner-booking-wait-${visitBookingInstance?.id }" title="Processing, please wait..." alt="Processing, please wait...!"/>
						</td>				
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${visitBookingInstanceCount ?: 0}" />
			</div>
		</div>
		<script>
function setBookingStatus(_id, _status){
	var answer = confirm("Are you sure want to set the status of this booking to '" + _status + "'?");
	var waitEl = $("spinner-booking-wait-"+_id)
	if(answer){
		waitEl.show();
		var url = "${g.createLink(controller: 'visitBooking', action: 'updatebookingstatus')}";
		var postdata = {
				  'status': _status,
				  'bookingid': _id,			 							 
				  'basic':'d2lnZ2x5dG9lTUFJTEVSc2017p3aWdnbHl0b2VzaXBjMjAxNm1BSUxFUg=='
				}
		//ajax call here
		var jqxhr = $.ajax({
			  method: "POST",
			  url: url,
			  data: postdata
			})
		  .done(function(data) {
			  	if(data.result == "success"){
					$("#cell-booking-status-" + _id).html(_status);
			  	}else{
				  	alert(data.message)
				  }		
		  })
		  .fail(function() {
		   		alert("Failed to change status to '" + _status + "'")
		  })
		  .always(function() { waitEl.hide();});
	}	  
	return false;
}
</script>

	</body>
</html>
