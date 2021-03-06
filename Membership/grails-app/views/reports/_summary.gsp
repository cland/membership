<%@ page import="cland.membership.SystemRoles" %>
<h1>Summary Report</h1>
			
<fieldset><legend>MONTH-TO-DATE SUMMARY</legend>
	<div id="statsmsg"></div>
	<table class="dataTable" style="width:90%;padding-left:10px;border:none">
		<tbody>
			<tr valign="top">
				<td bgcolor="#000000" width="122">&nbsp;</td>
				<td style="color:white;font-weight:bold;font-size:9pt;white-space:nowrap" bgcolor="#000000" width="122">New This Month</td>
				<td style="color:white;font-weight:bold;font-size:9pt;white-space:nowrap" bgcolor="#000000" width="159">Total</td>							
				<td bgcolor="#000000" width="35"></td>
			</tr>				
			<tr valign="top">
				<td width="122"><label>Clients</label></td>
				<td width="122"><div id="new_clients">--</div></td>
				<td width="159"><div id="total_clients">--</div></td>						
				<td width="35"><img class="wait" id="wait_clients" src="${assetPath(src: 'spinner.gif')}" title="loading..." alt="loading..." style="display: none;"/>&nbsp;</td>
			</tr>				
			<tr valign="top">
				<td width="122"><label>Children</label></td>
				<td width="122"><div id="new_children">--</div></td>
				<td width="159"><div id="total_children">--</div></td>
				<td width="35"><img class="wait" id="wait_children" src="${assetPath(src: 'spinner.gif')}" title="loading..." alt="loading..." style="display: none;"/>&nbsp;</td></tr>				
			<tr valign="top">
				<td width="122"><label>Visits</label></td>
				<td width="122"><div id="new_visits">--</div></td>							
				<td width="159"><div id="total_visits">--</div></td>
				<td width="35"><img class="wait" id="wait_visits" src="${assetPath(src: 'spinner.gif')}" title="loading..." alt="loading..." style="display: none;"/>&nbsp;</td>
			</tr>	
			<tr valign="top">
				<td width="122"><label>Coupons</label></td>
				<td width="122"><div id="new_coupons">--</div></td>							
				<td width="159"><div id="total_coupons">--</div></td>
				<td width="35"><img class="wait" id="wait_coupons" src="${assetPath(src: 'spinner.gif')}" title="loading..." alt="loading..." style="display: none;"/>&nbsp;</td>
			</tr>			
		</tbody>
	</table>
	<div class="key"></div>
	
	
	
</fieldset>

<sec:ifAnyGranted roles="${SystemRoles.ROLE_DEVELOPER }">
	<br/>
	<fieldset><legend>Export to Excel</legend>
		<div class="filter-div">				
			<g:formRemote class="ExportForm" id="searchform" name="searchform"  url="[controller:'reports',action:'export']" 				
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
							<g:select id="office" name="office.id" from="${cland.membership.Office.list()}" optionKey="id" required="" value="1" class="many-to-one" noSelection="['': 'All']"/>
						</td>
					</tr>
					</table>					
					<g:submitButton id="export_btn" name="export" class="button export" onclick="exportReport('export');return false" value="Search & Export" />					
				</fieldset>
			</g:formRemote>	
		</div>
	</fieldset>
</sec:ifAnyGranted>

<script>
$(document).ready(function() {	
	birthdaylist()
	var ThisOfficeID = 0
	var today = new Date();
	var mon = (today.getMonth()+1);
	var year = today.getFullYear()
	var frmdate = "1/" +  mon  + "/" +  year
	var todate =  today.getDate()  + "/" + mon  + "/" + year
	var params =  "frmdate=" + frmdate + "&todate=" + todate + "&office=" + ThisOfficeID + "&sFor=clients,children,visits"
	var url = "${request.contextPath}/reports/officeSummaryStats"
	loadStats(url,params,$("#statsmsg"))
		
	$("#tabs").tabs(
					{
					active:cbc_params.active_tab(),
					create: function (event,ui){	
						//executed after is created								
						$('#tabs').show()
					},
					show: function(event,ui){
						//on every tabs clicked
					},
					beforeLoad : function(event, ui) {
							ui.jqXHR.error(function() {
								ui.panel
								.html("Couldn't load this tab. We'll try to fix this as soon as possible. ");
							});
						}
			});	

	$("#export_btn").on("click", "form.ExportForm", function() {
		$("#clicked-button").prop("value",'export');
        $.fileDownload($(this).attr('href'), {
            preparingMessageHtml: "We are preparing your report, please wait...",
            failMessageHtml: "There was a problem generating your report, please try again."
        });
        return false; //this is critical to stop the click event which will trigger a normal file download!
    });
	
	var today=new Date();
	 $( "#start-date" ).datepicker({
		 dateFormat: "dd-M-yy",
			maxDate:"+0",
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
function exportReport(button){
	$("#clicked-button").prop("value",button);
	var _form = $("#searchform");
    $.fileDownload(_form.prop('action'), {
        preparingMessageHtml: "We are preparing your report, please wait...",
        failMessageHtml: "There was a problem generating your report, please try again.",
        httpMethod: "POST",            
        data: _form.serialize()
    }).done(function(){
        console.log("Success...");
      	 $(".ui-dialog-content").html("<span>Done!</span>");
       });
    return false; //this is critical to stop the click event which will trigger a normal file download!
}
function loadStats(actionUrl, params, dspEl){
	wait(true)
	 $.ajax({  
			   type: "post",  
				  url: actionUrl,
				  data: params,
				  timeout: 120000,  //20 sec
			   // callback handler that will be called on error
		        error: function(jqXHR, textStatus, errorThrown){
	            // log the error to the console	 		            		           
      			// console.log("The following error occured: "+ textStatus, errorThrown);
      			wait(false)
				 if(textStatus=="timeout") dspEl.html("Timeout: please try again."); else dspEl.html(textStatus + ": " + errorThrown);
				 		
    				},		
			   success: function(data) {  
			   		if (data.error != "" ){
			   			alert(data.error);
			   			wait(false)
			   			return
			   		}
				   	setDivValue("#new_clients",data.statsdata.num_new_clients)
				   	setDivValue("#total_clients",data.statsdata.num_clients)
				   	setDivValue("#new_children",data.statsdata.num_new_children)
				   	setDivValue("#total_children",data.statsdata.num_children)
				   	setDivValue("#total_visits",data.statsdata.num_visits)
				   	setDivValue("#new_visits",data.statsdata.num_new_visits)
				   	setDivValue("#total_coupons",data.statsdata.num_coupons)
				   	setDivValue("#new_coupons",data.statsdata.num_new_coupons)
				   	setDivValue("#promo_clients",data.statsdata.num_promo_children)
			 		wait(false)
			 		_promokids = $("#promokids")
			 		_promokids.html("<div class='row headrow' style=''><div class='cell'></div><div class='cell'>Child's Name</div><div class='cell'>Current Visits</div></div>");
			 		$.each(data.promokids,function( i, elem){	
				 		_lnk ="${request.contextPath}/child/show/" + elem[0]			 								 	
				 		_promokids.append("<div class='row'><div class='cell'>&raquo; </div><div class='cell'><a href='" + _lnk + "'>" + elem[1] + " " + elem[2]+"</a></div><div class='cell'>" + elem[3]+"</div></div>");
				 		_promokids.show();
				 	});
				},
				// callback handler that will be called on completion
			        // which means, either on success or error
		        complete: function(){
   				
			    }

		 });  
}

function setDivValue(id,value){
	if($(id)) $(id).html(value)
}
function wait(flag) { var el = $(".wait"); if (flag) el.show(); else el.hide(); }
</script>