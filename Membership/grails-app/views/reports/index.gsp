<%@ page import="cland.membership.SystemRoles" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title>Reports</title>
		<style type="text/css" media="screen">
			.wait{border:none};
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
		<div class="nav navpage" role="navigation">
			<ul>
				<li><g:link class="list" controller="visit" action="dailyreport">Daily Visits Report</g:link></li>
			</ul>
		</div>
		<a href="#page-body" class="skip"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>		
		<div id="page-body" role="main">	
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
				<div class="info">Total number of children qualifying for discounted visit: <span id='promo_clients'><b>0</b></span></div>
				<div id="promokids" class="table" style="display:none"></div>
				
				
			</fieldset>
			<fieldset><legend>Birthday List</legend>
				<div id="birthdaydatawait" class="hide">Loading list, please wait ...</div>
				<table class="inner-table">
				<thead>
						<tr id="birthday-report-header">
							<th>Date</th>
							<th>Child Name</th>
							<th>Age</th>
							<th>Gender</th>	
							<th>Visits</th>						
							<th>Contact No</th>
							<th>Email</th>
							<th>Action</th>									
						</tr>
					</thead>
					<tbody id="birthdaydata">
						
					</tbody>
				</table>
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
									<td>Date range:</td>
									<td>
										From: <g:textField name="startDate_open" class="datepick_single_future" id="start-date" value=""/> &nbsp;
										To: <g:textField name="endDate_open" class="datepick_single_future" id="end-date" value=""/>	
									</td>
								</tr>
								</table>					
								<g:submitButton id="export_btn" name="export" class="button export" onclick="exportReport('export');return false" value="Search & Export" />					
							</fieldset>
						</g:formRemote>	
					</div>
				</fieldset>
			</sec:ifAnyGranted>
		</div>

<br/><br/>
	<script>
	function onSuccess(data){
	}
	function onFailure(data){
	}
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
	 function birthdaylist(){
		   	var _tbody = $("#birthdaydata");
			var _waitrow = $("#birthdaydatawait");
			_waitrow.show();
			_tbody.html("")
			var _form = $("#birthdayform");
			var postdata = _form.serialize(); //{ 'status':status };			
			var jqxhr = $.ajax({ 
				url: "${request.contextPath}/child/birthdaylist",
				data:postdata,				
				cache: false
			 })
			  .done(function(data) {				  	
					 $.each(data,function(i,elem){
						 _btnfunc = "sendNotification('" + elem.id + "','0'); return false;";
						 _notifybtn = '<a href="" class="button2" onclick="' + _btnfunc + '">Send a Message</a>'
						 _tbody.append("<tr><td>" + elem.person.birthdate + "</td><td><a href='${request.contextPath}/child/show/" + elem.id + "'>" + elem.person.fullname + "</a></td><td>" + elem.person.age + "</td><td>" + elem.person.gender.label + "</td><td>" + elem.visitcount + "</td><td>" + elem.parent.person1.mobileno + "</td><td>" + elem.parent.person1.email + "</td><td>" + _notifybtn + "</td></tr>")
					 });
					 _waitrow.hide();
			  })
			  .fail(function() {
				  _waitrow.hide();
			  })
			  .always(function() {
			    	//console.log( "complete!" );
			  });

			return false;
		} //end function
		function sendNotification(_child_id,_visit_id){		
			 var _link = "${g.createLink(controller: 'harare', action: 'smsdialogcreate')}?cid=" + escape(_child_id) + "&vid=" + _visit_id ;
			 console.log(_link);
			 	
		  	 var $dialog = $('<div><div id="wait" style="font-weight:bold;text-align:center;">Loading...</div></div>')             
		                .load(_link)		                
		                .dialog({
		                	modal:true,
		                    autoOpen: false,
		                    dialogClass: 'no-close',
		                    width:800,
		                    beforeClose: function(event,ui){
		                    	
		                    },
		                    buttons:{
		                        "DONE":function(){			                      	 
		                         	// $dialog.dialog('close')
		                         	 $dialog.dialog('destroy').remove()
		                            }
			                    },
		                    close: function(event,ui){
		                  	  	$dialog.dialog('destroy').remove()
		                  	
		                    },
		                    position: {my:"top",at:"top",of:window},
		                    title: 'Send SMS Notification'                         
		                });
		                    
		                $dialog.dialog('open');
		               
		  } //end function sendNotification() 
	function setDivValue(id,value){
		if($(id)) $(id).html(value)
	}
	function wait(flag) { var el = $(".wait"); if (flag) el.show(); else el.hide(); }
	</script>		
	</body>
</html>
