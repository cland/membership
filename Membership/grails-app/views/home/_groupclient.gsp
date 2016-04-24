<%@ page import="cland.membership.lookup.*" %>
<% def grpchildcount=2 %>
<div class="bookingwait">Saving booking, please wait...</div>
<div id="booking-message"></div>
<g:formRemote name="newgroup_form" url="[controller:'booking',action:'newbooking']" 
			update="bookingpanel" 
			onSuccess="onSuccessBookingCallbackHander(data,textStatus)"
			onLoading="onBookingLoading()"
			onComplete="onBookingComplete()"
			onFailure="onBookingFailure(data,textStatus)">
			<fieldset><legend>Contact Person</legend>
	<div class="table">
				<div class="row">
					<div class="cell"><label id="">First name:</label></div>
					<div class="cell">
						<span class="property-value" aria-labelledby="home-label">
							<g:textField name="parent.person1.firstName" required="" value=""/>
						</span>
					</div>	
					<div class="cell"><label id="">Cell number:</label></div>
					<div class="cell">
						<span class="property-value" aria-labelledby="home-label">
							<g:textField name="parent.person1.mobileNo" value=""/>
						</span>
					</div>			
				</div>
				<div class="row">
					<div class="cell"><label id="">Surname:</label></div>
					<div class="cell">
						<span class="property-value" aria-labelledby="home-label">
							<g:textField name="parent.person1.lastName" required="" value=""/>
						</span>
					</div>
					<div class="cell"><label id="">Email:</label></div>
					<div class="cell">
						<span class="property-value" aria-labelledby="home-label">
							<g:textField name="parent.person1.email" value=""/>
						</span>
					</div>			
				</div>
		
				<div class="row">
					<div class="cell"><label id="">Id number:</label></div>
					<div class="cell">
						<span class="property-value" aria-labelledby="home-label">
							<g:textField name="parent.person1.idNumber" value=""/>
						</span>
					</div>		
					<div class="cell"><label id="">Relationship:</label></div>
					<div class="cell">
						<% def reltypes = cland.membership.lookup.Keywords.findByName("RelationshipTypes")?.values?.sort{it.id} %>
						<g:radioGroup 
							values="${reltypes?.id}"
							labels="${reltypes}" 
							name="parent.relationship">
							${it.radio} <g:message code="${it.label}" />
						</g:radioGroup>
					</div>			
				</div>				
			</div>
	</fieldset>
	<fieldset><legend>Booking</legend>
		<input type="hidden" name="booking.bookingtype" value="${Keywords.findByName("Birthday")?.id }"/>
		<div class="table">
			<div class="row">
				<div class="cell">	
					<div class="table">
						<div class="row">	
							<div class="cell"><label id="">Date:</label>
								<g:textField name="booking.date" id="grp-bookingdate" class="datepick_single_past" value=""/>			
							</div>
							<div class="cell"><label id="">Total number of kids incl birthday child?:</label><br/>
								<g:textField name="booking.totalkidcount"  value=""/><br/>					
							</div>
							<div class="cell"><label id="">Total number of adults:</label>
								<g:textField name="booking.totaladultcount" placeholder=""  value=""/>
							</div>
						</div>
					</div>
				</div>		
			</div>
			<div class="row">
				<div class="cell">
					<div class="table" style="width:100%;">
						<div class="row">
							<div class="cell" style="width:26%"><label id="">Time slot:</label><br/>
								<% def _timeslots = cland.membership.lookup.Keywords.findByName("PartyTimeSlots")?.values?.sort{it.id}.reverse() %>
								<g:radioGroup id="key_PartyTimeSlots"
									values="${_timeslots?.id}"
									labels="${_timeslots}" 
									name="booking.timeslot">
									${it.radio} <g:message code="${it.label}" /><br/>
								</g:radioGroup>	
							</div>
							<div class="cell" style="width:26%"><label id="">Room:</label><br/>
								<% def _rooms = cland.membership.lookup.Keywords.findByName("Room")?.values?.sort{it.id} %>
								<g:radioGroup id="key_Room"
									values="${_rooms?.id}"
									labels="${_rooms}" 
									name="booking.room">
									${it.radio} <g:message code="${it.label}" /><br/>
								</g:radioGroup>	
							</div>
							<div class="cell" style="width:26%"><label id="">Party Package:</label><br/>
							<% def _packages = cland.membership.lookup.Keywords.findByName("PartyPackage")?.values?.sort{it.id} %>
								<g:radioGroup id="key_PartyPackage"
									values="${_packages?.id}"
									labels="${_packages}" 
									name="booking.partyPackage">
									${it.radio} <g:message code="${it.label}" /><br/>
								</g:radioGroup>	
							</div>
							<div class="cell"><label id="">Theme:</label><br/>
							<% def _themes = cland.membership.lookup.Keywords.findByName("PartyTheme")?.values?.sort{it.label} %>
								<g:radioGroup id="key_PartyTheme"
									values="${_themes?.id}"
									labels="${_themes}" 
									name="booking.partyTheme">
									${it.radio} <g:message code="${it.label}" /><br/>
								</g:radioGroup>	
							</div>						
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="cell">
					<label>Comments: </label><br/>
					<textarea name="booking.comments" rows="5" cols="70" style="width:84%"></textarea>
				</div>		
			</div>
		</div>
	</fieldset>		
	
	<fieldset><legend>Birthday Child Details</legend>
		<div class="table">
			
			<div class="row">
				<div class="cell" style="width:20px;"><h1>1.</h1></div>
				<div class="cell">
					<g:textField name="child.person.firstname" placeholder="First Name"  value=""/><br/>
					<g:textField name="child.person.lastname" placeholder="Last Name"  value=""/>
				</div>
				<div class="cell">
					<g:textField name="child.person.dateOfBirth" placeholder="Date of Birth" id="grp-birth-date1" class="datepick_single_past" value=""/>
					<g:textField name="child.person.gender" placeholder="Gender"  value=""/>
				</div>
				<div class="cell"><label>Head Shot Photo:</label><input type="file" name="child.photo1"/></div>			
			</div>
			<div class="row"><div class="cell"></div><div class="cell"></div><div class="cell"></div></div>			
		</div>
	</fieldset>
	<fieldset>
		<legend>List of Children</legend>
		<div class="table">
			
			<g:each in="${(1..grpchildcount).toList()}" var="index">
				<div class="row">
					<div class="cell" style="width:20px;"><h1>${index+1 }.</h1></div>
					<div class="cell">
						<input type="text" name="childlead.firstName" value="" placeholder="First Name" id="lead-firstname-${index }" />
					</div>
					<div class="cell">
						<input type="text" name="childlead.lastName" value="" placeholder="Last Name" id="lead-lastname-${index }" />
					</div>
					<div class="cell">
						<input type="text" name="childlead.mobileNo" value="" placeholder="Mobile Number" id="lead-mobileno-${index }" />
					</div>
				</div>
			</g:each>
			
		</div>
	</fieldset>
	<fieldset class="buttons">
		<g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Submit')}" />
		<input type="button" name="cancel" onclick="document.location='${request.contextPath}/'" class="cancel" value="${message(code: 'default.button.cancel.label', default: 'Cancel')}" />
	</fieldset>
</g:formRemote>