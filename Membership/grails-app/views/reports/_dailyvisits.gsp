<%@ page import="cland.membership.SystemRoles" %>
<%@ page import="cland.membership.Visit" %>

<h1>Daily Visits Report</h1>
<g:if test="${flash.message}">
	<div class="message" role="status">${flash.message}</div>
</g:if>
<fieldset><legend>Filter Report</legend>
		<div class="filter-div">				
			<g:formRemote class="ExportForm" id="searchform" name="searchform"  url="[controller:'visit',action:'dailyreportdata']" 				
			onSuccess="onSuccess(data)"
			onFailure="onFailure(data)">
				<fieldset class="form">
					<table class="dataTable">						
					<tr>
						<td>
							From Date: <g:textField name="startDate_open" class="datepick_single_future" id="start-date" value=""/> &nbsp;
							To Date: <g:textField name="endDate_open" class="datepick_single_future" id="end-date" value=""/>	
						</td>
						<td>Office: </td>						
						<td>
							<g:select id="office" name="office.id" from="${cland.membership.Office.list()}" optionKey="id" required="" value="0" class="many-to-one" noSelection="['0': 'All']"/>
						</td>
					</tr>
					</table>	
					<input type="hidden" value="Complete" name="status"/>				
					<g:submitButton id="export_btn" name="export" class="button export" onclick="getdata('Complete');return false" value="Generate Report" />					
				</fieldset>
			</g:formRemote>	
		</div>
	</fieldset>
<div id="dailyreportwait" class="hide">
	Generating report, please wait ....
</div>
<table class="inner-table">
<thead>
		<tr id="daily-report-header">
			<th>Date</th>
			<th>Hours</th>
			<th>Coupon Hrs Used</th>
			<th>Visits</th>							
			<th>Coupon Visits</th>
			<th>Client Type: Gym Member</th>
			<th>Client Type: Standard</th>									
		</tr>
	</thead>
	<tbody id="dailyreportdata">
		
	</tbody>
</table>
<script>
  $(document).ready(function() {	
  //getdata("Complete"); //Cancelled
  var today = new Date();
  $( "#start-date" ).datepicker({
		 dateFormat: "dd-M-yy",
			maxDate:"+0",
			minDate:"-3m",
			defaultDate: new Date(today.getFullYear(), today.getMonth()-1, today.getDate()),
			onSelect: function(dateText, inst) {
			      // var actualDate = new Date(dateText);
			      // var newDate = new Date(actualDate.getFullYear(), actualDate.getMonth(), actualDate.getDate()+1);
			      //  $('#end-date').datepicker('option', 'minDate', newDate );
			  }
		 });
	 $( "#end-date" ).datepicker({
		 	dateFormat: "dd-M-yy",
			maxDate:"+0",
			defaultDate: new Date(),
			onSelect: function(dateText, inst) {
				//make sure that start-date is less that end-date  
			  }
		 });
});
  function getdata(status){
   	var _tbody = $("#dailyreportdata");
	var _waitrow = $("#dailyreportwait");
	_waitrow.show();
	_tbody.html("")
	var _form = $("#searchform");
	var postdata = _form.serialize(); //{ 'status':status };			
	var jqxhr = $.ajax({ 
		url: "${request.contextPath}/visit/dailyreportdata",
		data:postdata,				
		cache: false
	 })
	  .done(function(data) {
		  onSuccess(data)
	  })
	  .fail(function() {
		  onFailure();
	  })
	  .always(function() {
	    	//console.log( "complete!" );
	  });

	return false;
} //end function
function onSuccess(data){
	var _tbody = $("#dailyreportdata");
	var _waitrow = $("#dailyreportwait");
	 var jsonData = {};
	 $.each(data,function(i,elem){
		 
		 var _key = elem.datestring
		 var _hours = elem.businesshours
		 
		 var _visitcount = elem
		 var thisentry = (jsonData[_key] ? jsonData[_key] : {"hours":0,"visitcount":0,"couponhrs":0,"couponvisits":0,"Gym Member":0,"Standard":0})
		// console.log(i + " : " + _key)
		 thisentry["hours"] = thisentry["hours"] + _hours;
		 thisentry["visitcount"] = thisentry["visitcount"] + 1; 
		 if(elem.coupon!=null){					 
			 thisentry["couponhrs"] = thisentry["couponhrs"] + elem.businesshours
			 thisentry["couponvisits"] = thisentry["couponvisits"] + 1;
		 }
		 thisentry[elem.clienttype.name] = (thisentry[elem.clienttype.name]? thisentry[elem.clienttype.name] + 1: 1);
		 jsonData[_key] = thisentry 
	 });

	 $.each(jsonData,function(i,row){			
		 _tbody.append("<tr><td>" + i + "</td><td>" + row.hours + "</td><td>" + row.couponhrs + "</td><td>" + row.visitcount + "</td><td>" + row.couponvisits + "</td><td>" + row["Gym Member"] + "</td><td>" + row["Standard"] + "</td></tr>")				 			
		});
		_waitrow.hide();	
} //end 
function onFailure(){
	alert( "error" );
}

  </script>