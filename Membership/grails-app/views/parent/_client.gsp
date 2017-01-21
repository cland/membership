<%@ page import="org.joda.time.DateTime" %>
<%@ page import="cland.membership.lookup.*" %>
<g:set var="person1" value="${parentInstance?.person1}"/>
<g:set var="person2" value="${parentInstance?.person2}"/>
<g:set var="isEditMode" value="${mode?.equals("edit") }"/>
<g:set var="settingsInstance" value="${cland.membership.Settings.find{true}}"/>
<% def childcount=settingsInstance?.newchildcount %>
	<fieldset>
	<legend >Parent/Guardian</legend>
		<div class="table">
			<div class="row">
				<div class="cell"><label id="">First name:</label></div>
				<div class="cell">
					<span class="property-value" aria-labelledby="home-label">
						<g:if test="${isEditMode }">
							<g:textField name="person1.firstName" required="" value="${person1?.firstName }"/>
						</g:if>
						<g:else>${person1?.firstName }</g:else>
					</span>
				</div>	
				<div class="cell"><label id="">Cell number:</label></div>
				<div class="cell">
					<span class="property-value" aria-labelledby="home-label">
						<g:if test="${isEditMode }">
						<g:textField name="person1.mobileNo" value="${person1?.mobileNo }"/>
						</g:if>
						<g:else>${person1?.mobileNo }</g:else>
					</span>
				</div>			
			</div>
			<div class="row">
				<div class="cell"><label id="">Surname:</label></div>
				<div class="cell">
					<span class="property-value" aria-labelledby="home-label">
						<g:if test="${isEditMode }">
							<g:textField name="person1.lastName" required="" value="${person1?.lastName }"/>
						</g:if><g:else>${person1?.lastName }</g:else>
					</span>
				</div>
				<div class="cell"><label id="">Email:</label></div>
				<div class="cell">
					<span class="property-value" aria-labelledby="home-label">
						<g:if test="${isEditMode }">
							<g:textField name="person1.email" value="${person1?.email }"/>
						</g:if><g:else>${person1?.email }</g:else>
					</span>
				</div>			
			</div>
	
			<div class="row">
				<div class="cell"><label id="">Id number:</label></div>
				<div class="cell">
					<span class="property-value" aria-labelledby="home-label">
						<g:if test="${isEditMode }">
							<g:textField name="person1.idNumber" value="${person1?.idNumber }"/>
						</g:if><g:else>${person1?.idNumber }</g:else>
					</span>
				</div>		
				<div class="cell"><label id="">Relationship:</label></div>
				<div class="cell">
					<g:if test="${isEditMode }">
					<% def reltypes = cland.membership.lookup.Keywords.findByName("RelationshipTypes")?.values?.sort{it?.id} %>
						<g:radioGroup 
							value="${parentInstance?.relationship?.id }"
							values="${reltypes?.id}"
							labels="${reltypes}" 
							name="relationship">
							${it.radio} <g:message code="${it.label}" />
						</g:radioGroup>
					</g:if><g:else>${parentInstance?.relationship?.toString() }</g:else>
				</div>			
			</div>	
			<div class="row">
				<div class="cell"><label id="">Client type:</label></div>
				<div class="cell">
					<g:if test="${isEditMode }">
					<% def ctypes = cland.membership.lookup.Keywords.findByName("ClientTypes")?.values?.sort{it?.id} %>
						<g:radioGroup 
							value="${parentInstance?.clientType?.id }"
							values="${ctypes?.id}"
							labels="${ctypes}" 
							name="clientType">
							${it.radio} <g:message code="${it.label}" />
						</g:radioGroup>
					</g:if><g:else>${parentInstance?.clientType?.toString() }</g:else>
				</div>
				<div class="cell"></div>
			</div>
		</div>	
	</fieldset>
	<fieldset><legend>Emergency Contact Details</legend>
		<div class="table">
			<div class="row">
				<div class="cell"><label id="">First name:</label></div>
				<div class="cell">
					<span class="property-value" aria-labelledby="home-label">
						<g:if test="${isEditMode }">
							<g:textField name="person2.firstName" required="" value="${person2?.firstName }"/>
						</g:if><g:else>${person2?.firstName }</g:else>
					</span>
				</div>	
				<div class="cell"><label id="">Last name:</label></div>
				<div class="cell">
					<span class="property-value" aria-labelledby="home-label">
						<g:if test="${isEditMode }">
							<g:textField name="person2.lastName" required="" value="${person2?.lastName }"/>
						</g:if><g:else>${person2?.lastName }</g:else>
					</span>
				</div>	
				<div class="cell"><label id="">Cell number:</label></div>
				<div class="cell">
					<span class="property-value" aria-labelledby="home-label">
						<g:if test="${isEditMode }">
							<g:textField name="person2.mobileNo" value="${person2?.mobileNo }"/>
						</g:if><g:else>${person2?.mobileNo }</g:else>
					</span>
				</div>			
			</div>
		</div>		
	</fieldset>
	<fieldset><legend>Children</legend>
		<g:if test="${parentInstance.children?.sort{it?.person.firstName}}">
		<table class="inner-table">
			<thead>
				<tr>
					<th>First Name</th>
					<th>Last Name</th>
					<th>Date Of Birth</th>
					<th>Gender</th>
					<th>Total Visits</th>
					<th>Checked-In?</th>
					<th>Office</th>
					<th>Last Visit</th>
					<th>Last Office</th>
					<th>Action</th>
				</tr>
			</thead>
			<g:each in="${parentInstance.children?.sort{it?.person.firstName}}" var="c">
				<g:set var="activeVisit" value="${c?.getActiveVisit()}"/>
				<tr>
					<td><span class="property-value" aria-labelledby="children-label"><g:link controller="child" action="show" id="${c.id}">${c?.person?.firstName}</g:link></span>
					</td>
					<td>${c?.person?.lastName}</td>
					<td>${c?.person?.dateOfBirth?.format("dd MMM yyyy")}</td>
					<td>${c?.person?.gender}</td>
					<td>${c?.getVisitCount()}</td>
					<td><g:formatBoolean boolean="${c?.isActive() }" false="No" true="Yes"/></td>
					<td>${activeVisit?.office?.name }</td>
					<td>${c?.lastVisit?.starttime?.format("dd MMM yyyy") }</td>
					<td>${c?.lastVisit?.office?.name }</td>
					<td><a href="" class="button2" onclick="sendNotification('${c?.id}','0'); return false;">Notify</a></td>
				</tr>
			</g:each>
		</table>
		
		<hr/><br/>
		</g:if>
		<g:if test="${isEditMode }">
			<h3>Add New</h3>
				<div class="table">
			<div class="row">
				<div class="cell">
					<div class="table">
						<g:each in="${(1..childcount).toList()}" var="index">
							<div class="row child-form-entry" id="child${index }">
								<div class="cell" style="width:20px;"><h1>${index }.</h1>
									<asset:image src="skin/icon_cross.png" class="child${index }-rmicon rm-child-icon" id="rmicon-child${index }" title="Remove this entry" alt="Remove this entry!"/>
								</div>
								<div class="cell border-bottom">
									<g:textField class="child${index }" name="child.person.firstname${index }" placeholder="First Name"  value="" id="child-firstname-${index }"/><br/>
									<g:textField class="child${index }" name="child.person.lastname${index }" placeholder="Last Name"  value="" id="child-lastname-${index }"/><br/>
									<label>Check-in now:</label> 
									<g:checkBox class="child-checkbox${index }" name="child.checkin${index }" value="Yes" />
									<g:textField class="child-starttime${index }" name="child.visit.time${index }" placeholder="Date and Time" value="${new Date().format('dd-MMM-yyyy HH:mm')}" id="visit_time${index }" class="datetime-picker"/>
								</div>
								<div class="cell border-bottom">
									<g:textField class="child${index }" name="child.person.dateOfBirth${index }" placeholder="Date of Birth" id="birth-date${index }" class="datepick_single_past" value=""/>						
									<% def gender = cland.membership.lookup.Keywords.findByName("Gender")?.values?.sort{it?.label} %>
									<br/><g:radioGroup style="margin-top:15px;" 
										class="child${index }"
										values="${gender?.id}"
										labels="${gender}" 
										name="child.person.gender${index }">
										${it.radio} <g:message code="${it.label}" />
									</g:radioGroup>
									<br/><span class="visit-wbn-input"><br/><g:textField class="child-wbn${index }" name="child.visit.visitno${index }" placeholder="Wrist Band No."  value="" id="visit-visitno-${index }"/></span>
								</div>
								<div class="cell border-bottom">
									<label>Profile Photo:</label> <input type="file" name="profilephoto${index }"/><br/>
									<span class="visit-photo-input"><label>Full Body Photo:</label> <input type="file" name="visitphoto${index }"/><br/></span>
									
								</div>			
							</div>
						</g:each>				
					</div>
				</div>
			</div>
			<div class="row">
					<input type="hidden" name="currentChildCount" id="curchild-count" value="1"/>
					<input type="button" class="button2" id="next-child-btn" name="add-child_btn" value="Add Another Child" style="margin-left:30px;"/>
			</div>			
			
		</div>

		</g:if>
	</fieldset>
	<script>
	$(document).ready(function(){
		$(".visit-photo-input").hide();
		$(".child-form-entry").hide();
		$("#child1").show();
		var child1id =".child1"; 		
		//$(".child1").prop("required",true);
		$("#rmicon-child1").hide();
		$(document).on("click","#next-child-btn",function(){
			var childid = $("#curchild-count").prop("value");
			var nxtchild = (parseInt(childid) + 1);
			$("#child" + nxtchild).show();
			$(".child" + nxtchild).prop("required",true);
			$(".child" + nxtchild).prop("disabled",false);
			$(".textbox-child" + nxtchild).prop("disabled",false);
			$("#child-firstname-" + nxtchild).focus();
			$("#curchild-count").prop("value",nxtchild);

			//then we must ensure first child has required information
			$(child1id).prop("required",true);			
		});
		$(document).on("click",".rm-child-icon",function(){
			var id = $(this).prop("id").replace(/rmicon-/gi,"");
			var i = id.replace(/child/gi,"");
			var curchildcount = parseInt(i)-1;
			$("#curchild-count").prop("value",curchildcount);
			$("#" + id).hide();
			$("." + id).prop("disabled",true);
			$(".textbox-" + id).prop("disabled",true);

			if(curchildcount == 1) {
				setChild1Validation();
			}
		});
		$(document).on("blur",".child1",function(){
			setChild1Validation();
		});
	})
	function setChild1Validation(){
		var f = $("#child-firstname-1").prop("value");
		var l = $("#child-lastname-1").prop("value");
		if(f !== "" || l !== "") 
			$(".child1").prop("required",true);
		else {
			$(".child1").prop("required",false);
		}
	}
	function sendNotification(_child_id,_visit_id){		
		 var _link = "${g.createLink(controller: 'harare', action: 'smsdialogcreate')}?cid=" + escape(_child_id) + "&vid=" + _visit_id ;
	
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
	</script>
