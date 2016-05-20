<g:set var="activeVisit" value="${childInstance?.activeVisit }"/>
<g:set var="parent" value="${childInstance?.parent }"/>
<g:set var="visits" value="${childInstance.visits?.sort{it.starttime}.reverse() }"/>
<g:set var="isEditMode" value="${mode?.equals("edit") }"/>
	<fieldset>
		<legend>Child's Profile</legend>
		<div class="table">
			<div class="row">
				<div class="cell">
					<div class="table">
						<div class="row">
							<div class="cell"><label id="">First name:</label></div>
							<div class="cell">
								<g:if test="${isEditMode }">
									<g:hiddenField name="person.mobileNo" value="${childInstance?.person?.mobileNo}" />
									
									<g:textField name="person.firstName" value="${childInstance?.person?.firstName }"/>
								</g:if>
								<g:else>${childInstance?.person?.firstName }</g:else>								
							</div>
							<div class="cell"><label id="">Last name:</label></div>
							<div class="cell">
								<g:if test="${isEditMode }">
									<g:textField name="person.lastName" value="${childInstance?.person?.lastName }"/>
								</g:if>
								<g:else>${childInstance?.person?.lastName }</g:else>
							</div>
						</div>
						<div class="row">
							<div class="cell"><label id="">Gender:</label></div>
							<div class="cell">
								<g:if test ="${ isEditMode}">
									<% def gender = cland.membership.lookup.Keywords.findByName("Gender")?.values?.sort() %>
									<g:radioGroup style="margin-top:15px;" 
										values="${gender?.id}"
										labels="${gender}"
										value="${childInstance?.person?.gender?.id }" 
										name="person.gender">
										${it.radio} <g:message code="${it.label}" />
									</g:radioGroup>
								</g:if>
								<g:else>
									${childInstance?.person?.gender }
								</g:else>
							</div>
							<div class="cell"><label id="">D.O.B:</label></div>
							<div class="cell">
								<g:if test="${isEditMode }">
									<g:textField name="person.dateOfBirth" placeholder="Date of Birth" id="birth-date" class="datepick_single_past" value="${childInstance?.person?.dateOfBirth?.format("dd-MMM-yyyy")}"/>
								</g:if>
								<g:else>
									${childInstance?.person?.dateOfBirth?.format("dd-MMM-yyyy")} (${childInstance?.person?.age } yrs)
								</g:else>
							</div>	
						</div>
						<div class="row">
							<div class="cell"><label id="">Parent:</label></div>
							<div class="cell"><a href="${request.contextPath}/parent/show/${parent?.id}">${parent }</a></div>
							<div class="cell"><label id="">Membership No.:</label></div>
							<div class="cell">${parent?.membershipNo}</div>
						</div>
						<div class="row">
							<div class="cell"><label id="">Contact No.:</label></div>
							<div class="cell">${parent?.person1?.mobileNo }</div>
							<div class="cell"><label id="">Email:</label></div>
							<div class="cell">${parent?.person1?.email}</div>
						</div>						
					</div>
				</div>					
				<div class="cell">				
					<attachments:each bean="${childInstance?.person}">
						<img src="${request.contextPath}/attachmentable/show/${attachment?.id }" style="width:150px;vertical-align:top;"/><br/>		
						<g:if test="${isEditMode }">			    
						    <attachments:deleteLink
						                         attachment="${attachment}"
						                         label="${'[X]'}"
						                         returnPageURI="${createLink(action: 'actionName', id: childInstance?.id)}"/>
						    <attachments:downloadLink attachment="${attachment}"/>			                   
						    ${attachment.niceLength}
					   	</g:if>    
					</attachments:each>
					<g:if test="${isEditMode }">
						Profile Photo:<input type="file" name="profilephoto${childInstance?.person?.id }"/><br/>
					</g:if>
					
				</div>
			</div>
		</div>
	</fieldset>
	<fieldset><legend>Emergency Contact</legend>
		<div class="table">
			<div class="row">
				<div class="cell"><label id="">Contact:</label></div>
				<div class="cell">${parent?.person2 }</div>
				<div class="cell"><label id="">Contact No:</label></div>
				<div class="cell">${parent?.person2?.mobileNo}</div>
				
			</div>
		</div>
	</fieldset>
	<div id="tabs" style="display: none;">
		<ul>
			<li><a href="#tab-1">Visits</a></li>
			<li><a href="#tab-2">Caring and Medication</a></li>
		</ul>
		<div id="tab-1">
		<g:if test="${activeVisit}">	
			<fieldset style="text-align:center;"><legend>Current Visit Photo</legend>
				<div id="current-visit-div">
					<attachments:each bean="${activeVisit}">
						<img src="${request.contextPath}/attachmentable/show/${attachment?.id }" style="width:300px;"/><br/>
					</attachments:each>
					<label>Check-in date-time: </label> ${activeVisit?.starttime?.format("dd MMM yyyy HH:mm")}<br/>
					<input type="submit" class="button" id="btn_notify" onclick="sendNotification('${activeVisit?.child?.id}','${activeVisit?.id}')" name="btn_notify" value="Notify" />
				 	<input type="submit" class="button" id="btn_checkout" onclick="checkOut('${activeVisit?.id}','Complete')" name="btn_checkout" value="Check-Out" />
				 	<input type="submit" class="button" id="btn_view" onclick="checkOut('${activeVisit?.id}','Cancelled')" name="btn_view" value="Cancel" />
			 	</div>
			</fieldset>		
		</g:if>
		<g:if test="${childInstance.visits}">
			<table>
				<thead>
					<tr>
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
				<g:each in="${visits}" var="c">
					<tr>								
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
			</table>
		</g:if>
		
		</div>
		<div id="tab-2">
			<div class="table">
				<div class="row">
					<div class="cell" style="background:rgb(209, 205, 205) none repeat scroll 0% 0%">
						<p><b>Important information relating to caring of child</b></p>
						<p>Include details of toilet requirements (e.g. nappies or toilet training) and any allergies or other special requirements</p>
					</div>
				</div>
				<div class="row">
					<div class="cell">
					&nbsp;
						<g:if test="${isEditMode }">
							<textarea name="comments" rows="5" cols="70" style="width:84%">${childInstance?.comments }</textarea>
						</g:if>
						<g:else>
							${childInstance?.comments }
						</g:else>
					</div>
				</div>
				<div class="row"><div class="cell">&nbsp;</div></div>
				<div class="row">
					<div class="cell" style="background:rgb(209, 205, 205) none repeat scroll 0% 0%">
						<p><b>Medication</b></p>
						<p>Include details of any medication the child takes. Administering medication is the responsibility of parents, not staff. However this information may be required in the case of an emeergency.</p>
					</div>
				</div>
				<div class="row">
					<div class="cell">&nbsp;
						<g:if test="${isEditMode }">
							<textarea name="medicalComments" rows="5" cols="70" style="width:84%">${childInstance?.medicalComments }</textarea>
						</g:if>
						<g:else>
							${childInstance?.medicalComments }
						</g:else>
						
					</div>
				</div>
			</div>
		</div>		
</div>

<script>
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

</script>

		