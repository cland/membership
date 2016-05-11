<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title>Reports</title>
		<style type="text/css" media="screen">
			
			#status {
				background-color: #eee;
				border: .2em solid #fff;
				margin: 2em 2em 1em;
				padding: 1em;
				width: 12em;
				float: left;
				-moz-box-shadow: 0px 0px 1.25em #ccc;
				-webkit-box-shadow: 0px 0px 1.25em #ccc;
				box-shadow: 0px 0px 1.25em #ccc;
				-moz-border-radius: 0.6em;
				-webkit-border-radius: 0.6em;
				border-radius: 0.6em;
			}

			.ie6 #status {
				display: inline; /* float double margin fix http://www.positioniseverything.net/explorer/doubled-margin.html */
			}

			#status ul {
				font-size: 0.9em;
				list-style-type: none;
				margin-bottom: 0.6em;
				padding: 0;
			}

			#status li {
				line-height: 1.3;
			}

			#status h1 {
				text-transform: uppercase;
				font-size: 1.1em;
				margin: 0 0 0.3em;
			}

			#page-body {
				margin: 0.5em 0.5em 1.25em 1em;
			}

			h2 {
				margin-top: 1em;
				margin-bottom: 0.3em;
				font-size: 1em;
			}

			p {
				line-height: 1.5;
				margin: 0.25em 0;
			}

			#controller-list ul {
				list-style-position: inside;
			}

			#controller-list li {
				line-height: 1.3;
				list-style-position: inside;
				margin: 0.25em 0;
			}

			@media screen and (max-width: 480px) {
				#status {
					display: none;
				}

				#page-body {
					margin: 0 0.5em 0.5em;
				}

				#page-body h1 {
					margin-top: 0;
				}
			}
		</style>
		<script type="text/javascript">
//<![CDATA[
var cbc_params = {
		active_tab : function(){ if (${params.tab==null}) return 0; else return ${params.tab};}
	}
//]]>
</script>
	</head>
	<body>
		<a href="#page-body" class="skip"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>		
		<div id="page-body" role="main">	
		<h1>Reports</h1>
		<br/>		
			<fieldset><legend>MONTH-TO-DATE SUMMARY</legend>
				<div id="statsmsg"></div>
				<table class="dataTable" style="width:90%;padding-left:10px;border:none">
					<tbody>
						<tr valign="top">
							<td bgcolor="#000000" width="122">&nbsp;</td>
							<td style="color:white;font-weight:bold;font-size:9pt;white-space:nowrap" bgcolor="#000000" width="122">New</td>
							<td style="color:white;font-weight:bold;font-size:9pt;white-space:nowrap" bgcolor="#000000" width="159">Active</td>							
							<td bgcolor="#000000" width="35"><img src="/icons/ecblank.gif" alt="" border="0" height="1" width="1"></td>
						</tr>				
						<tr valign="top">
							<td width="122"><label>Clients</label></td>
							<td width="122"><div id="new_clients">--</div></td>
							<td width="159"><div id="total_clients">--</div></td>						
							<td width="35"><img class="wait" id="wait_clients" src="${request.contextPath}/images/spinner.gif" title="loading..." alt="loading..." style="display: none;">&nbsp;</td>
						</tr>				
						<tr valign="top">
							<td width="122"><label>Children</label></td>
							<td width="122"><div id="new_children">--</div></td>
							<td width="159"><div id="total_children">--</div></td>
							<td width="35"><img class="wait" id="wait_children" src="${request.contextPath}/images/spinner.gif" title="loading..." alt="loading..." style="display: none;">&nbsp;</td></tr>				
						<tr valign="top">
							<td width="122"><label>Visits</label></td>
							<td width="122"><div id="new_visits">--</div></td>
							<td width="159"><div id="total_visits">--</div></td>
							<td width="35"><img class="wait" id="wait_visits" src="${request.contextPath}/images/spinner.gif" title="loading..." alt="loading..." style="display: none;">&nbsp;</td>
						</tr>				
					</tbody>
				</table>
				<div class="key"><div>
				</div></div>
			</fieldset>
			
			<fieldset><legend>Export to Excel</legend>
				<div class="filter-div">
				
				<g:formRemote class="ExportForm" id="searchform" name="searchform"  url="[controller:'report',action:'export']" 				
				onSuccess="onSuccess(data)"
				onFailure="onFailure(data)">
					<fieldset class="form">
						<table class="dataTable">						
						<tr>
							<td>Date range:</td>
							<td>
								From: <g:textField name="startDate_open" class="datepick_single_future" id="start-date" value=""/> &nbsp;
								To: <g:textField name="endDate_open" class="datepick_single_future" id="end-date" value=""/>	
							</td>
						</tr>						

					</table>
					

					<g:submitButton id="export_btn" name="export" class="export" onclick="exportReport('export');return false" value="Search & Export" />
					

					</fieldset>

				</g:formRemote>	
			</div>
			</fieldset>
		</div>

<br/><br/>
	<script>
	function onSuccess(data){
	}
	function onFailure(data){
	}
	$(document).ready(function() {	
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
				defaultDate: new Date(today.getFullYear(), today.getMonth()-6, today.getDate()),
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
				 		wait(false)
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
	</body>
</html>
