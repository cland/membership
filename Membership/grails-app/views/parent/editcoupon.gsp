<g:set var="settingsInstance" value="${cland.membership.Settings.find{true}}"/>
<g:set var="isDebug" value="${settingsInstance?.debug }"/>
<g:set var="smsTestNumber" value="${settingsInstance?.smsTestNumber }"/>
<g:set var="smsFrom" value="${settingsInstance?.smsFrom }"/>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="maindialog"/>
		<title>Edit Coupon</title>
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
			<div style="text-align:right;">Parent: ${couponInstance?.parent?.person1 }</div>		
			<div class="edit-coupon-wait hide">Processing, please wait...</div>
			<div id="edit-coupon-message"></div>
			<input type="hidden" name="edit_coupon_id" id="edit_coupon_id" value="${couponInstance?.id }"/>
			<fieldset id="edit-previewmsg"><legend>Edit Coupon Details</legend>
				<form id="edit-coupon-form" name="edit_coupon_form">
							<br/>							
							<div id="edit_coupon_msg" class="text-align:center"></div>
							<div class="table">
								<div class="row">
									<div class="cell"><label id="">Coupon No:</label></div>
									<div class="cell">
										<span class="property-value" aria-labelledby="home-label">
											<g:textField id="edit_coupon_refno" name="refno" required="" value="${couponInstance?.refNo }" placeholder="Coupon Number"/>
										</span>
									</div>	
									<div class="cell"><label id="">Visits:</label></div>
									<div class="cell">
										<span class="property-value" aria-labelledby="home-label">
											<g:textField id="edit_coupon_maxvisits" name="maxvisits" required="" value="${couponInstance?.maxvisits }" placeholder="Visits"/>
										</span>
									</div>									
								</div>
								<div class="row">
									<div class="cell"><label id="">Activation Date:</label></div>
									<div class="cell">
										<span class="property-value" aria-labelledby="home-label">																						
											<g:textField name="startdate" placeholder="Start Date" value="${couponInstance?.startDate?.format('dd-MMM-yyyy')}" id="edit_coupon_startdate" class="datetime-picker"/>
										</span>
									</div>	
									<div class="cell"><label id="">Expiry Date:</label></div>
									<div class="cell">
										<span class="property-value" aria-labelledby="home-label">											
											<g:textField name="expirydate" placeholder="Expiry Date" value="${couponInstance?.expiryDate?.format('dd-MMM-yyyy')}" id="edit_coupon_expirydate" class="datetime-picker"/>
										</span>
									</div>										
								</div>	
								<div class="row">
									<div class="cell"></div>
									<div class="cell">
										<input type="button" class="button" name="edit_coupon_btn" onClick="updateCoupon();return false;" id="edit-coupon-btn" value="Update"/>
									</div>
								</div>																				
							</div>
							</form>
			</fieldset>
		</div>

	<script>
	$(document).ready(function() {
		
		initDatePicker1($( "#edit_coupon_startdate"),"0d","-1y","+2");
		initDatePicker1($( "#edit_coupon_expirydate"),"+3m","0d","+4m");
		
		//handle template submit button		
	//	$(document).on("click","#edit-coupon-btn",function(){
	//		updateCoupon();
	//	});	
		         
	});  

	function initDatePicker1(el,def,min,max){
		el.datepicker({
			dateFormat: "dd-M-yy",
			altFormat: "yy-mm-dd"
			});
	}
	function getAussieDate(fmt,datestring){
		if(fmt === undefined || fmt ==="") fmt = 'DD MMMM YYYY HH:mm:ss';
		if(datestring === undefined || datestring === "") 
			return moment().tz("Australia/Perth").format(fmt);
		else
			return moment(datestring).tz("Australia/Perth").format(fmt);
	}
	function updateCoupon(){
		var _msgEl = $("#edit_coupon_msg");
		var _couponid = $("#edit_coupon_id").val();
		var _refno = $("#edit_coupon_refno").val();
		var _maxvisits = $('#edit_coupon_maxvisits').val();
		var _startdate = $("#edit_coupon_startdate").val();
		var _expirydate = $("#edit_coupon_expirydate").val();
		var _form = $("#edit_coupon_form");
		var _tbody = $("#coupon_list");
		if(_refno == "" || _startdate == "" || _maxvisits == ""){
			_msgEl.html("<span style='font-weight:bold;font-size:2em;color:red'>Missing information!</span>")
			return false;
			}
		if(_couponid == "" || _couponid === undefined){
			_msgEl.html("<span style='font-weight:bold;font-size:2em;color:red'>Missing coupon id!</span>")
			return false;
		}
		var _postdata = {
				  'refno': _refno,
				  'couponid':_couponid,
				  'startdate':_startdate,
				  'expirydate':_expirydate,
				  'maxvisits':_maxvisits,					 							 
				  'basic':'d2lnZ2x5dG9lTUFJTEVSc2lwYzp3aWdnbHl0b2VzaXBjMjAxNm1BSUxFUg=='
				}				
		var _url = "${g.createLink(controller: 'parent', action: 'updatecoupon')}";
	
		//ajax call here
		var jqxhr = $.ajax({
			  method: "POST",
			  url: _url,
			  data: _postdata
			})
		  .done(function(data) {
				_msgEl.html("<span style='font-weight:bold;font-size:1.6em;color:green'>Coupon saved successfully!</span>")					
				_form.hide()	
				var _lnk = "${g.createLink(controller: 'parent', action: 'show')}/${couponInstance?.parent?.id}?tab=4";
				document.location.href = _lnk;			
		  })
		  .fail(function() {
		    _msgEl.html("<span style='font-weight:bold;font-size:2em;color:red'>Failed to save template!</span>")
		  })
		  .always(function() { });
		  
		  return false;
	}
	</script>		
	</body>
</html>
