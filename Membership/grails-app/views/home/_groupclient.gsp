<g:formRemote name="newgroup_form" url="[controller:'parent',action:'newclient']" 
			update="livepanel" 
			onSuccess="onSuccessNewClientCallbackHander(data,textStatus)"
			onLoading="onLoading()"
			onComplete="onComplete()"
			onFailure="onFailure(data,textStatus)">
	<fieldset><legend>Booking</legend>
		<div class="table">
			<div class="row">				
				<div class="cell"><label id="">Date:</label>
					<g:textField name="booking.date" id="grp-bookingdate" class="datepick_single_past" value=""/>				
				</div>
				<div class="cell"><label id="">Total number of kids incl birthday child?:</label>
					<g:textField name="booking.totalkidcount"  value=""/><br/>					
				</div>
				<div class="cell"><label id="">Total number of adults:</label>
					<g:textField name="booking.totaladultcount" placeholder=""  value=""/>
				</div>		
			</div>
		</div>
	</fieldset>		
	<fieldset><legend>Contact Person</legend>
	<div class="table">
				<div class="row">
					<div class="cell"><label id="">First name:</label></div>
					<div class="cell">
						<span class="property-value" aria-labelledby="home-label">
							<g:textField name="person.firstname" required="" value=""/>
						</span>
					</div>	
					<div class="cell"><label id="">Cell number:</label></div>
					<div class="cell">
						<span class="property-value" aria-labelledby="home-label">
							<g:textField name="telNo" value=""/>
						</span>
					</div>			
				</div>
				<div class="row">
					<div class="cell"><label id="">Surname:</label></div>
					<div class="cell">
						<span class="property-value" aria-labelledby="home-label">
							<g:textField name="person.lastname" required="" value=""/>
						</span>
					</div>
					<div class="cell"><label id="">Email:</label></div>
					<div class="cell">
						<span class="property-value" aria-labelledby="home-label">
							<g:textField name="email" value=""/>
						</span>
					</div>			
				</div>
		
				<div class="row">
					<div class="cell"><label id="">Id number:</label></div>
					<div class="cell">
						<span class="property-value" aria-labelledby="home-label">
							<g:textField name="idNumber" value=""/>
						</span>
					</div>		
					<div class="cell"><label id="">Relationship:</label></div>
					<div class="cell">
						<g:radioGroup 
							values="${cland.membership.lookup.Keywords.findByName("RelationshipTypes")?.values}"
							labels="${cland.membership.lookup.Keywords.findByName("RelationshipTypes")?.values}" 
							name="parent.relationship">
							${it.radio} <g:message code="${it.label}" />
						</g:radioGroup>
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
					<g:textField name="child.person.firstname" placeholder="Gender"  value=""/>
				</div>
				<div class="cell">Attach Photo:<input type="file" name="child.photo1"/></div>			
			</div>
			<div class="row"><div class="cell"></div><div class="cell"></div><div class="cell"></div></div>			
		</div>
	</fieldset>
	<fieldset class="buttons">
		<g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Submit')}" />
		
	</fieldset>
</g:formRemote>