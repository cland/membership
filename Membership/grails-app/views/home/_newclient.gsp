<%@ page import="org.joda.time.DateTime" %>
<%@ page import="cland.membership.lookup.*" %>
<% def childcount=2 %>

	<g:set var="isEditMode" value="true"/>
	<fieldset>
	<legend >Parent/Guardian</legend>
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
					<% def reltypes = cland.membership.lookup.Keywords.findByName("RelationshipTypes")?.values?.sort{it?.id} %>
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
	<fieldset><legend>Emergency Contact Details</legend>
		<div class="table">
			<div class="row">
				<div class="cell"><label id="">First name:</label></div>
				<div class="cell">
					<span class="property-value" aria-labelledby="home-label">
						<g:textField name="parent.person2.firstName" required="" value=""/>
					</span>
				</div>	
				<div class="cell"><label id="">Last name:</label></div>
				<div class="cell">
					<span class="property-value" aria-labelledby="home-label">
						<g:textField name="parent.person2.lastName" required="" value=""/>
					</span>
				</div>	
				<div class="cell"><label id="">Cell number:</label></div>
				<div class="cell">
					<span class="property-value" aria-labelledby="home-label">
						<g:textField name="parent.person2.mobileNo" value=""/>
					</span>
				</div>			
			</div>
		</div>		
	</fieldset>
	<fieldset><legend>Children</legend>
		<div class="table">
			<g:each in="${(1..childcount).toList()}" var="index">
				<div class="row">
					<div class="cell" style="width:20px;"><h1>${index }.</h1></div>
					<div class="cell border-bottom">
						<g:textField name="child.person.firstname${index }" placeholder="First Name"  value="" id="child-firstname-${index }"/><br/>
						<g:textField name="child.person.lastname${index }" placeholder="Last Name"  value="" id="child-lastname-${index }"/><br/>
						Check-in now: <g:checkBox name="child.checkin${index }" value="Yes" />
						<g:textField name="child.visit.time${index }" placeholder="Date and Time" value="${new Date().format('dd-MMM-yyyy HH:mm')}" id="visit_time${index }" class="datetime-picker"/>
					</div>
					<div class="cell border-bottom">
						<g:textField name="child.person.dateOfBirth${index }" placeholder="Date of Birth" id="birth-date${index }" class="datepick_single_past" value=""/>						
						<% def gender = cland.membership.lookup.Keywords.findByName("Gender")?.values?.sort() %>
						<br/><g:radioGroup style="margin-top:15px;" 
							values="${gender?.id}"
							labels="${gender}" 
							name="child.person.gender${index }">
							${it.radio} <g:message code="${it.label}" />
						</g:radioGroup>
					</div>
					<div class="cell border-bottom">
						Profile Photo:<input type="file" name="profilephoto${index }"/><br/>
						Full Body Photo:<input type="file" name="visitphoto${index }"/>
					</div>			
				</div>
			</g:each>				
		</div>
	</fieldset>
	
