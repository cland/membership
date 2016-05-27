<%@ page import="org.joda.time.DateTime" %>
<%@ page import="cland.membership.lookup.*" %>
<% def childcount=settings?.newchildcount %>

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
						<g:textField name="parent.person1.mobileNo" value="" required=""/>
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
						<g:textField type="email" name="parent.person1.email" value="" required=""/>
						
					</span>
				</div>			
			</div>
	
			<div class="row">
				<div class="cell"><label id="">Id number:</label></div>
				<div class="cell">
					<span class="property-value" aria-labelledby="home-label">
						<g:textField name="parent.person1.idNumber" value="" required=""/>
					</span>
				</div>		
				<div class="cell"><label id="">Relationship:</label></div>
				<div class="cell">
					<% def reltypes = cland.membership.lookup.Keywords.findByName("RelationshipTypes")?.values?.sort{it?.label} %>
						<g:radioGroup required=""
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
						<g:textField name="parent.person2.mobileNo" required="" value=""/>
					</span>
				</div>			
			</div>
		</div>		
	</fieldset>
	<fieldset><legend>Children</legend>
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
									
								</div>
								<div class="cell border-bottom">
									<g:textField name="child.person.dateOfBirth${index }" placeholder="Date of Birth" id="birth-date${index }" class="child${index } datepick_single_past" value=""/>						
									<% def gender = cland.membership.lookup.Keywords.findByName("Gender")?.values?.sort{it?.label} %>
									<br/><g:radioGroup style="margin-top:15px;" 
										class="child${index }"
										values="${gender?.id}"
										labels="${gender}" 
										name="child.person.gender${index }">
										${it.radio} <g:message code="${it.label}" />
									</g:radioGroup>
								</div>
								<div class="cell border-bottom">									
									<textarea class="textbox-child${index }"name="child.comments${index }" rows="10" cols="50" style="height:80px;width:350px;" placeholder="Comments">${childInstance?.comments }</textarea>
								</div>			
							</div>
						</g:each>
					</div>
				</div>
			</div>
			<div class="row">
				<input type="hidden" name="currentChildCount" id="curchild-count" value="1"/>
				<input type="button" class="button" id="next-child-btn" name="add-child_btn" value="Add Another Child" style="margin-left:30px;"/>
			</div>			
		</div>
	</fieldset>
	
