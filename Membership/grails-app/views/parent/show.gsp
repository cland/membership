<%@ page import="cland.membership.SystemRoles" %>
<%@ page import="cland.membership.Parent" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'parent.label', default: 'Parent')}" />
		<title><g:message code="default.show.label" args="[entityName]" />: ${parentInstance }</title>
		<g:render template="head" var="thisInstance" bean="${parentInstance }" model="[sidenav:page_nav]"></g:render>
	</head>
	<body>
		<a href="#show-parent" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav navpage" role="navigation">
			<ul>
				<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				
			</ul>
		</div>
		<div id="show-parent" class="content scaffold-show" role="main">
			<h1>Client: ${parentInstance } (${parentInstance?.membershipNo })</h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<div id="tabs" style="display: none;">
					<ul>
						<li><a href="#tab-1">Details</a></li>
						<li><a href="#tab-2">All Visits</a></li>
						<li style="display:none;"><a href="#tab-3">Supporting Documents</a></li>
						<li><a href="#tab-4">Notifications</a></li>
						<li><a href="#tab-5">Coupons</a></li>
					</ul>
				<div id="tab-1">
					<g:render template="client" bean="${parentInstance}" var="parentInstance" model="[mode:'read']"></g:render>
				</div>
			<div id="tab-2">
				<g:if test="${parentInstance.children}">
					<table>
						<thead>
							<tr>
								<th>Name</th>
								<th>Date</th>
								<th>Time-in</th>
								<th>Time-out</th>
								<th>Duration</th>
								<th>Contact No.</th>
								<th>Status</th>	
								<th>Selected Hours</th>
								<th>Visit Photo</th>							
							</tr>
						</thead>
						<g:each in="${parentInstance?.children }" var="child" status="i">
							<g:each in="${child?.visits.sort{it.starttime}.reverse()}" var="c">
								<tr>
									<td><g:link controller="child" action="show" id="${child?.id}">${child?.person }</g:link></td>						
									<td>${c?.starttime?.format("dd MMM yyyy")}</td>
									<td>${c?.starttime?.format("hh:mm")}</td>
									<td>${c?.endtime?.format("HH:mm")}</td>
									<td>${c?.durationText}</td>
									<td>${c?.contactNo}</td>
									<td>${c?.status}</td>
									<td>${c?.selectedHours}</td>
									<td>
										<attachments:each bean="${c}">
											<a href="#" onclick="viewPhoto('${request.contextPath}/attachmentable/show/${attachment?.id }');return false;">View Photo</a>
										</attachments:each>
									</td>
								</tr>
							</g:each>
						</g:each>
					</table>
				</g:if>
			</div>
			<div id="tab-3" style="display:none">
				<p>Documents</p>
			</div>
			<div id="tab-4">
				<g:if test="${parentInstance.notifications}">
					<table>
						<thead>
							<tr>
								<th>Date Sent</th>
								<th>Child's Name</th>																
								<th>Sent To</th>
								<th>Status</th>								
							</tr>
						</thead>
						<tbody id="notification_list">
							<g:each in="${parentInstance?.notifications }" var="note" status="i">							
								<tr>
									<td>${note?.dateCreated?.format("dd MMM yyyy")}</td>
									<td><g:link controller="child" action="show" id="${note?.child?.id}">${note?.child?.person }</g:link>	</td>							
									<td>${note?.sendTo}</td>
									<td>${note?.responseCode}</td>
								</tr>
								<tr>
									<td colspan="4" style="padding:5px;border-bottom:solid 1px rgb(243, 167, 132);">${note?.body}</td>									
								</tr>		
							</g:each>
						</tbody>
					</table>
				</g:if>
			</div>
			<div id="tab-5">
				<g:if test="${parentInstance.coupons}">
					<table>
						<thead>
							<tr>
								<th>Coupon No.</th>
								<th>Date Activated</th>								
								<th>Total Visits</th>																
								<th>Visits Left</th>
								<th>Expiry Date</th>
							</tr>
						</thead>
						<tbody id="coupon_list">
							<g:each in="${parentInstance?.coupons }" var="note" status="i">							
								<tr>
									<td>${note.refNo }</td>
									<td>${note?.startDate?.format("dd MMM yyyy")}</td>
									<td>${note?.maxvisits}</td>							
									<td>${note?.visitsLeft}</td>
									<td>${note?.expiryDate?.format("dd MMM yyyy")}</td>
								</tr>
								<tr id="coupon-visits-${note?.id }" class="coupon-visits-list">
									<td colspan="6" style="padding:5px;border-bottom:solid 1px rgb(243, 167, 132);">
									<g:if test="${note?.visits}">
										<table class="inner-table">
											<thead>
												<tr>
													<th>#</th>
													<th>Name</th>
													<th>Date</th>
													<th>Time-in</th>
													<th>Time-out</th>
													<th>Duration</th>
													<th>Contact No.</th>
													<th>Status</th>
													<th>Visit Photo</th>							
												</tr>
											</thead>
										<g:each in="${note?.visits.sort{it.starttime} }" var="v" status="j">
											<tr>
												<td>${j+1 }</td>
												<td><g:link controller="child" action="show" id="${v?.child?.id}">${v?.child?.person }</g:link></td>						
												<td>${v?.starttime?.format("dd MMM yyyy")}</td>
												<td>${v?.starttime?.format("hh:mm")}</td>
												<td>${v?.endtime?.format("HH:mm")}</td>
												<td>${v?.durationText}</td>
												<td>${v?.contactNo}</td>
												<td>${v?.status}</td>												
												<td>
													<attachments:each bean="${v}">
														<a href="#" onclick="viewPhoto('${request.contextPath}/attachmentable/show/${attachment?.id }');return false;">View Photo</a>
													</attachments:each>
												</td>
											</tr>
										</g:each>
										</table>
										</g:if>
									</td>									
								</tr>							
							</g:each>
						</tbody>
					</table>
				</g:if>
				<sec:ifAnyGranted roles="${SystemRoles.ROLE_ADMIN },${SystemRoles.ROLE_DEVELOPER }">
				<fieldset>
						<legend>Add New Coupon</legend>							
							<form id="new_coupon_form" name="new_coupon_form">
							<br/>
							<input type="hidden" id="coupon_parent_id" name="coupon.parent.id" value="${parentInstance?.id }"/>
							<div id="new_coupon_msg" class="text-align:center"></div>
							<div class="table">
								<div class="row">
									<div class="cell"><label id="">Coupon No:</label></div>
									<div class="cell">
										<span class="property-value" aria-labelledby="home-label">
											<g:textField id="coupon_refno" name="coupon.refno" required="" value="" placeholder="Coupon Number"/>
										</span>
									</div>	
									<div class="cell"><label id="">Visits:</label></div>
									<div class="cell">
										<span class="property-value" aria-labelledby="home-label">
											<g:textField id="coupon_maxvisits" name="coupon.maxvisits" required="" value="18" placeholder="Visits"/>
										</span>
									</div>									
								</div>
								<div class="row">
									<div class="cell"><label id="">Activation Date:</label></div>
									<div class="cell">
										<span class="property-value" aria-labelledby="home-label">																						
											<g:textField name="coupon.startdate" placeholder="Start Date" value="${new Date().format('dd-MMM-yyyy')}" id="coupon_startdate" class="datetime-picker"/>
										</span>
									</div>	
									<div class="cell"><label id="">Expiry Date:</label></div>
									<div class="cell">
										<span class="property-value" aria-labelledby="home-label">											
											<g:textField name="coupon.expirydate" placeholder="Expiry Date" value="${new Date().format('dd-MMM-yyyy')}" id="coupon_expirydate" class="datetime-picker"/>
										</span>
									</div>										
								</div>	
								<div class="row">
									<div class="cell"></div>
									<div class="cell">
										<input type="button" class="button" name="coupon_btn" id="coupon_btn" value="Submit"/>
									</div>
								</div>																				
							</div>
							</form>
						</fieldset>
				</sec:ifAnyGranted>		
			</div>
			<g:form url="[resource:parentInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${parentInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
		</div>
		<script>
		$(document).ready(function() {		
			
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
			initDatePicker($( "#coupon_startdate"),"0d","-1d","+2");
			initDatePicker($( "#coupon_expirydate"),"+3m","+3m","+4m");
			var d = new moment().add(3,'months').format("DD-MMM-YYYY");
			$( "#coupon_expirydate").prop("value",d)
			//handle template submit button
			$(document).on("click","#coupon_btn",function(){
				saveCoupon();
				}); 	                
		});  
		function viewPhoto(_link){
			var $dialog = $('<div style="text-align:center;"><img src="' + _link + '" style="width:300px;"/></div>')             
            		                
            .dialog({
            	modal:true,
                autoOpen: false,
                dialogClass: 'no-close',
                width:800,
                beforeClose: function(event,ui){
                	
                },
                buttons:{
                    "Close":function(){			                      	 
                     	// $dialog.dialog('close')
                     	 $dialog.dialog('destroy').remove()
                        }
                    },
                close: function(event,ui){
              	  	$dialog.dialog('destroy').remove()
              	
                },
                position: {my:"top",at:"top",of:window},
                title: 'Photo of child on the day of visit'                         
            });
                
            $dialog.dialog('open');
		}
		function saveCoupon(){	
			var _msgEl = $("#new_coupon_msg");
			var _parentid = $("#coupon_parent_id").val();
			var _refno = $("#coupon_refno").val();
			var _maxvisits = $('#coupon_maxvisits').val();
			var _startdate = $("#coupon_startdate").val();
			var _expirydate = $("#coupon_expirydate").val();
			var _form = $("#new_coupon_form");
			var _tbody = $("#coupon_list");
			if(_refno == "" || _startdate == "" || _maxvisits == ""){
				_msgEl.html("<span style='font-weight:bold;font-size:2em;color:red'>Missing information!</span>")
				return false;
				}
			if(_parentid == ""){
				_msgEl.html("<span style='font-weight:bold;font-size:2em;color:red'>Missing parent id!</span>")
				return false;
			}
			var postdata = {
					  'refno': _refno,
					  'parentid':_parentid,
					  'startdate':_startdate,
					  'expirydate':_expirydate,
					  'maxvisits':_maxvisits,					 							 
					  'basic':'d2lnZ2x5dG9lTUFJTEVSc2lwYzp3aWdnbHl0b2VzaXBjMjAxNm1BSUxFUg=='
					}
			console.log(postdata)								
			var url = "${g.createLink(controller: 'parent', action: 'newcoupon')}";
				console.log("Calling: " + url)
			//ajax call here
			var jqxhr = $.ajax({
				  method: "POST",
				  url: url,
				  data: postdata
				})
			  .done(function(data) {
					_msgEl.html("<span style='font-weight:bold;font-size:1.6em;color:green'>Coupon saved successfully!</span>")
					_tbody.append("<tr><td><span style='color:red;'>new</span></td><td>" + _refno +" </td><td>" + _startdate +"</td><td>" + _maxvisits +"</td><td>" + _maxvisits +"</td><td>" + _expirydate +"</td></tr>")
					_form.trigger('reset')
			  })
			  .fail(function() {
			    _msgEl.html("<span style='font-weight:bold;font-size:2em;color:red'>Failed to save template!</span>")
			  })
			  .always(function() { });
			  
			  return false;
		}
		function initDatePicker(el,def,min,max){
			el.datepicker({
				dateFormat: "dd-M-yy",
				altFormat: "yy-mm-dd",
				defaultDate : def,					
				maxDate:max,
				minDate:min
				});
		}
		function getAussieDate(fmt,datestring){
			if(fmt === undefined || fmt ==="") fmt = 'DD MMMM YYYY HH:mm:ss';
			if(datestring === undefined || datestring === "") 
				return moment().tz("Australia/Perth").format(fmt);
			else
				return moment(datestring).tz("Australia/Perth").format(fmt);
		}
		</script>
	</body>
</html>
