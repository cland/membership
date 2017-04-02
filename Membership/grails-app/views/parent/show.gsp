<%@ page import="cland.membership.SystemRoles" %>
<%@ page import="cland.membership.Parent" %>
<g:set var="settingsInstance" value="${cland.membership.Settings.find{true}}"/>
<g:set var="children" value="${parentInstance?.children?.sort{it?.person.firstName} }"/>
<g:set var="coupons" value="${parentInstance?.coupons?.sort{it.startDate}  }"/>
<g:set var="notifications" value="${parentInstance.notifications?.sort{it.dateCreated }.reverse()}"/>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'parent.label', default: 'Parent')}" />
		<title><g:message code="default.show.label" args="[entityName]" />: ${parentInstance }</title>
		<g:render template="head" var="thisInstance" bean="${parentInstance }" model="[sidenav:page_nav]"></g:render>
		<style>
			.row-deleted, .row_deleted td{
				color:#d8d8d8;
				text-decoration: line-through;
			}
			.delete-coupon-icon {}
			.edit-coupon-icon {margin-left:1em;}
			.delete-coupon-icon:hover, .edit-coupon-icon:hover {cursor:hand;cursor:pointer;transform: scale(1.8);}
		</style>
		<asset:javascript src="webcam.js"/>
	</head>
	<body>
		<a href="#show-parent" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav navpage" role="navigation">
			<ul>
				<sec:ifAnyGranted roles="${SystemRoles.ROLE_ADMIN },${SystemRoles.ROLE_DEVELOPER },${SystemRoles.ROLE_MANAGER },${SystemRoles.ROLE_ASSISTANT }">
					<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				</sec:ifAnyGranted>							
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
						<li><a href="#tab-6">Manage Profile Photos</a></li>
					</ul>
				<div id="tab-1">
					<g:render template="client" bean="${parentInstance}" var="parentInstance" model="[mode:'read']"></g:render>
				</div>
			<div id="tab-2">
				<g:if test="${children }">
					<table class="inner-table">
						<thead>
							<tr>
								<th>Name</th>
								<th>Date</th>
								<th>Time-in</th>
								<th>Time-out</th>
								<th>Duration</th>
								<th>Effective Hours</th>
								<th>Contact No.</th>
								<th>Status</th>									
								<th>Wrist Band No.</th>
								<th>Actions</th>							
							</tr>
						</thead>
						<g:each in="${children }" var="child" status="i">
							<g:each in="${child?.visits?.findAll{it.status!="Cancelled"}.sort{it.starttime}.reverse()}" var="c">
								<tr>
									<td><g:link controller="child" action="show" id="${child?.id}">${child?.person }</g:link></td>						
									<td>${c?.starttime?.format("dd MMM yyyy")}</td>
									<td>${c?.starttime?.format("HH:mm")}</td>
									<td>${c?.endtime?.format("HH:mm")}</td>
									<td>${c?.durationText}</td>
									<td>${c?.visitHours}</td>
									<td>${c?.contactNo}</td>
									<td id="row-visit-status-${c?.id}" class="status-${c?.status }">${c?.status}</td>									
									<td>
										${c?.visitNo }																
									</td>
									<sec:ifAnyGranted roles="${SystemRoles.ROLE_ADMIN },${SystemRoles.ROLE_DEVELOPER },${SystemRoles.ROLE_MANAGER },${SystemRoles.ROLE_ASSISTANT }">
										<td>
											<g:if test="${c?.status?.equalsIgnoreCase('Complete')}">
												<asset:image src="skin/icon_cross.png" class="rm-visit-icon" onClick="setVisitStatus('${c?.id }','Cancelled');return false;" id="rm-visit-${c?.id }" title="Cancel this visit!" alt="Cancel this visit!"/>
												&nbsp;<asset:image src="skin/database_add.png" class="add-couponvisit-icon" onClick="addVisitToCoupon('${c?.id }');" id="add_couponvisit_${c?.id }" title="Add this visit to coupon" alt="Add this visit to coupon!"/>
											</g:if>
											<asset:image src="spinner.gif" class="spinner-rmvisit-wait hide" id="spinner-rmvisit-wait-${c?.id }" title="Processing, please wait..." alt="Processing, please wait...!"/>
										</td>
									</sec:ifAnyGranted>
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
				<g:if test="${notifications}">
					<table class="inner-table">
						<thead>
							<tr>
								<th>Date Sent</th>
								<th>Child's Name</th>																
								<th>Sent To</th>
								<th>Status</th>								
							</tr>
						</thead>
						<tbody id="notification_list">
							<g:each in="${notifications }" var="note" status="i">							
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
				
					<table class="inner-table">
						<thead>
							<tr>
								<th>Coupon No.</th>
								<th>Date Activated</th>								
								<th>Total Visits</th>																
								<th>Visits Left</th>
								<th>Expiry Date</th>
								<th>Actions</th>
							</tr>
						</thead>
						<tbody id="coupon_list">
							<g:each in="${coupons}" var="note" status="i">							
								<tr id="row-coupon-${note?.id }">
									<td>${note.refNo }</td>
									<td>${note?.startDate?.format("dd MMM yyyy")}</td>
									<td>${note?.maxvisits}</td>							
									<td>${note?.getVisitsLeft(settingsInstance?.mincutoff,settingsInstance?.minmodulo)}</td>
									<td>${note?.expiryDate?.format("dd MMM yyyy")}</td>
									<td>
										<sec:ifAnyGranted roles="${SystemRoles.ROLE_ADMIN },${SystemRoles.ROLE_DEVELOPER },${SystemRoles.ROLE_MANAGER },${SystemRoles.ROLE_ASSISTANT }">
											<asset:image src="skin/icon_delete.png" class="delete-coupon-icon" onClick="rmCoupon('${note?.id }');" id="del_${note?.id }" title="Delete this entry" alt="Delete this entry!"/>
											<asset:image src="spinner.gif" class="spinner-wait hide" id="spinner-wait-${note?.id }" title="Processing, please wait..." alt="Processing, please wait...!"/>
											<asset:image src="skin/database_edit.png" class="edit-coupon-icon" onClick="editCoupon('${note?.id }');" id="edit_${note?.id }" title="Edit this entry" alt="Edit entry!"/>											
										</sec:ifAnyGranted>
									</td>
								</tr>
								<tr id="coupon-visits-${note?.id }" class="coupon-visits-list">
									<td colspan="6" style="padding:5px;border-bottom:solid 1px rgb(243, 167, 132);">
									<g:if test="${note?.visits}">
										<table class="inner2-table">
											<thead>
												<tr>
													<th>#</th>
													<th>Name</th>
													<th>Date</th>
													<th>Time-in</th>
													<th>Time-out</th>
													<th>Duration</th>
													<th>Effective Hours</th>
													<th>Status</th>
													<th>Visit Photo</th>
													<sec:ifAnyGranted roles="${SystemRoles.ROLE_ADMIN },${SystemRoles.ROLE_DEVELOPER }">	
														<th></th>			
													</sec:ifAnyGranted>			
												</tr>
											</thead>
										<g:each in="${note?.visits.sort{it.starttime} }" var="v" status="j">
											<tr id="row-coupon-visit-${v?.id}">
												<td>${j+1 }</td>
												<td><g:link controller="child" action="show" id="${v?.child?.id}">${v?.child?.person }</g:link></td>						
												<td>${v?.starttime?.format("dd MMM yyyy")}</td>
												<td>${v?.starttime?.format("HH:mm")}</td>
												<td>${v?.endtime?.format("HH:mm")}</td>
												<td>${v?.durationText}</td>
												<td>${v?.visitHours}</td>
												<td>${v?.status}</td>						
												<td>
													<attachments:each bean="${v}">
														<a href="#" onclick="viewPhoto('${request.contextPath}/attachmentable/show/${attachment?.id }');return false;">View Photo</a>
													</attachments:each>
												</td>
												<sec:ifAnyGranted roles="${SystemRoles.ROLE_ADMIN },${SystemRoles.ROLE_DEVELOPER }">
													<td>
														<asset:image src="skin/icon_cross.png" class="rm-coupon-visit-icon" onClick="rmVisitFromCoupon('${note?.id }','${v?.id }');return false;" id="rm-coupon-visit-${v?.id }" title="Remove this visit from coupon" alt="Remove this visit from coupon!"/>
														<asset:image src="spinner.gif" class="spinner-wait hide" id="spinner-wait-${v?.id }" title="Processing, please wait..." alt="Processing, please wait...!"/>
													</td>
												</sec:ifAnyGranted>
											</tr>
										</g:each>
										</table>
										</g:if>
									</td>									
								</tr>							
							</g:each>
						</tbody>
					</table>
				
				
				<sec:ifAnyGranted roles="${SystemRoles.ROLE_ADMIN },${SystemRoles.ROLE_DEVELOPER },${SystemRoles.ROLE_ASSISTANT },${SystemRoles.ROLE_MANAGER }">
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
			<div id="tab-6">
				<g:render template="photos" var="parentInstance" bean="${parentInstance }" model="[sidenav:page_nav]"></g:render>
			</div>
			<g:form url="[resource:parentInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${parentInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<sec:ifAnyGranted roles="${SystemRoles.ROLE_MANAGER },${SystemRoles.ROLE_ADMIN }">
						<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
					</sec:ifAnyGranted>
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

		function editCoupon(_id){
			var _url = "${g.createLink(controller: 'parent', action: 'editcoupon')}/" + _id;
			var $dialog = $('<div style="text-align:center;">Loading coupon...</div>')             
            .load(_url)
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
                title: 'Edit coupon ' + _id                         
            });
                
            $dialog.dialog('open');	
			return false;
		} //edit
		function setVisitStatus(visit_id,_status){			
			var answer = confirm("Are you sure want to set the status of this visit to '" + _status + "'?");
			var waitEl = $("spinner-rmvisit-wait-"+visit_id)
			if(answer){
				waitEl.show();
				var url = "${g.createLink(controller: 'parent', action: 'updatevisitstatus')}";
				var postdata = {
						  'status': _status,
						  'vid': visit_id,			 							 
						  'basic':'d2lnZ2x5dG9lTUFJTEVSc2lwYzp3aWdnbHl0b2VzaXBjMjAxNm1BSUxFUg=='
						}
				//ajax call here
				var jqxhr = $.ajax({
					  method: "POST",
					  url: url,
					  data: postdata
					})
				  .done(function(data) {
					  	if(data.result == "success"){
							$("#row-visit-status-" + visit_id).html(_status);
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
		function addVisitToCoupon(visit_id){
			var answer = confirm("Are you sure you want to ADD this visit to a coupon?");
			var waitEl = $("spinner-wait-"+visit_id)
			if(answer){
				waitEl.show();
				var url = "${g.createLink(controller: 'parent', action: 'addvisittocoupon')}";
				var postdata = {						  
						  'vid': visit_id,			 							 
						  'basic':'d2lnZ2x5dG9lTUFJTEVSc2lwYzp3aWdnbHl0b2VzaXBjMjAxNm1BSUxFUg=='
						}
				//ajax call here
				var jqxhr = $.ajax({
					  method: "POST",
					  url: url,
					  data: postdata
					})
				  .done(function(data) {
					  	if(data.result=="success"){
					  		$("#add_couponvisit_" + visit_id).hide()
					  		alert("Added successfully!")
					  	}
												
				  })
				  .fail(function() {
				    _msgEl.html("<span style='font-weight:bold;font-size:2em;color:red'>Failed to save template!</span>")
				  })
				  .always(function() { waitEl.hide();});
			}	  
			return false;
		}
		function rmVisitFromCoupon(coupon_id,visit_id){
			var answer = confirm("Are you sure you want to remove this visit from the coupon?");
			var waitEl = $("spinner-wait-"+visit_id)
			if(answer){
				waitEl.show();
				var url = "${g.createLink(controller: 'parent', action: 'rmcouponvisit')}";
				var postdata = {
						  'cid': coupon_id,
						  'vid': visit_id,			 							 
						  'basic':'d2lnZ2x5dG9lTUFJTEVSc2lwYzp3aWdnbHl0b2VzaXBjMjAxNm1BSUxFUg=='
						}
				//ajax call here
				var jqxhr = $.ajax({
					  method: "POST",
					  url: url,
					  data: postdata
					})
				  .done(function(data) {
				  		if(data.result=="success"){
						$("#row-coupon-visit-" + visit_id).addClass("row-deleted");
						$("#rm-coupon-visit-" + visit_id).hide();
						}						
				  })
				  .fail(function() {
				    _msgEl.html("<span style='font-weight:bold;font-size:2em;color:red'>Failed to save template!</span>")
				  })
				  .always(function() { waitEl.hide();});
			}	  
			return false;
		}
		function rmCoupon(_id){
			var answer = confirm("Are you sure you want to delete this coupon?");
			var waitEl = $("spinner-wait-"+_id)
			if(answer){
				waitEl.show();
				var url = "${g.createLink(controller: 'parent', action: 'rmcoupon')}";
				var postdata = {
						  'id': _id,				 							 
						  'basic':'d2lnZ2x5dG9lTUFJTEVSc2lwYzp3aWdnbHl0b2VzaXBjMjAxNm1BSUxFUg=='
						}
				//ajax call here
				var jqxhr = $.ajax({
					  method: "POST",
					  url: url,
					  data: postdata
					})
				  .done(function(data) {
						$("#row-coupon-" + _id).addClass("row-deleted");
						$("#del_" + _id).hide();
						$("#edit_" + _id).hide();
						
				  })
				  .fail(function() {
				    _msgEl.html("<span style='font-weight:bold;font-size:2em;color:red'>Failed to save template!</span>")
				  })
				  .always(function() { waitEl.hide();});
			}	  
			return false;
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
										
			var url = "${g.createLink(controller: 'parent', action: 'newcoupon')}";
		
			//ajax call here
			var jqxhr = $.ajax({
				  method: "POST",
				  url: url,
				  data: postdata
				})
			  .done(function(data) {
					_msgEl.html("<span style='font-weight:bold;font-size:1.6em;color:green'>Coupon saved successfully!</span>")
					_tbody.append("<tr><td>(<span style='color:red;'>new</span>) " + _refno +" </td><td>" + _startdate +"</td><td>" + _maxvisits +"</td><td>" + _maxvisits +"</td><td>" + _expirydate +"</td></tr>")					
					_form.trigger('reset');
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
