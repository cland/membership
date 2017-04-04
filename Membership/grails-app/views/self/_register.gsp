<%@ page import="org.joda.time.DateTime" %>
<%@ page import="cland.membership.lookup.*" %>
<% def childcount=settings?.newchildcount %>

	<g:set var="isEditMode" value="true"/>
	<div id="new-registration-logindetails" class="container">
		<h2>Setup Your Login Details</h2>
		<div class="table table-2col">
			<div class="row">
				<div class="cell "><label id="">Email:</label></div>
				<div class="cell ">
					<span class="property-value" aria-labelledby="home-label">
						<g:textField type="email" id="parentemail" name="parent.person1.email" value="" required=""  placeholder="Enter a valid email address"/>						
					</span>
				</div>	
						
			</div>
			<div class="row">
				<div class="cell "><label id="">Password:</label></div>
				<div class="cell ">
					<span class="property-value" aria-labelledby="home-label">
						<g:field type="password" name="parent.person1.password" required="" value="" id="pwd"/>
					</span>
				</div>	
			</div>
			<div class="row">	
				<div class="cell "><label id="">Re-type password:</label></div>
				<div class="cell ">
					<span class="property-value" aria-labelledby="home-label">
						<g:field type="password" name="parent.person1.passwordConfirm" required="" value="" id="pwd-confirm"/>
					</span> <span class="error" id="pwd-msg" style="font-weight:bold;color:red;font-size:0.8em;display:none;">Passwords do not match!</span>
				</div>	
			</div>
		</div>
	</div>
	
	<div class="container">
		<h2>Parent/Guardian</h2>
		<div class="table table-2col">
			<div class="row">
				<div class="cell "><label id="">First name:</label></div>
				<div class="cell ">
					<span class="property-value" aria-labelledby="home-label">
						<g:textField name="parent.person1.firstName" required="" value=""/>
					</span>
				</div>					
			</div>
			<div class="row">
				<div class="cell "><label id="">Surname:</label></div>
				<div class="cell ">
					<span class="property-value" aria-labelledby="home-label">
						<g:textField name="parent.person1.lastName" required="" value=""/>
					</span>
				</div>
			</div>
			<div class="row">
				<div class="cell "><label id="">Cell number:</label></div>
				<div class="cell ">
					<span class="property-value" aria-labelledby="home-label">
						<g:textField name="parent.person1.mobileNo" value="" required=""/>
					</span>
				</div>	
			</div>
			<div class="row">
				<div class="cell "><label id="">Id number:</label></div>
				<div class="cell ">
					<span class="property-value" aria-labelledby="home-label">
						<g:textField name="parent.person1.idNumber" value="" required=""/>
					</span>
				</div>	
			</div>
			<div class="row">	
				<div class="cell "><label id="">Relationship:</label></div>
				<div class="cell ">
					<% def reltypes = cland.membership.lookup.Keywords.findByName("RelationshipTypes")?.values?.sort{it?.label} %>
						<g:radioGroup required=""
							values="${reltypes?.id}"
							labels="${reltypes}" 
							name="parent.relationship">
							${it.radio} <g:message code="${it.label}" />
						</g:radioGroup>
				</div>			
			</div>	
			<div class="row">
				<div class="cell ">
					<label for="office">
						<g:message code="person.office.label" default="Preferred Wiggly Toes Centre:" />
						<span class="required-indicator">*</span>
					</label>
				</div>
				<div class="cell ">					
					<g:select id="office" name="office.id" from="${cland.membership.Office.list()}" optionKey="id" required="" value="1" class="many-to-one" noSelection="['': '']"/>
				</div>				
			</div>	
		</div>	
	</div>
	
	<div class="container">
		<h2>Emergency Contact Details</h2>
		<div class="table table-2col">
			<div class="row">
				<div class="cell "><label id="">First name:</label></div>
				<div class="cell ">
					<span class="property-value" aria-labelledby="home-label">
						<g:textField name="parent.person2.firstName" required="" value=""/>
					</span>
				</div>	
			</div>
			<div class="row">	
				<div class="cell "><label id="">Last name:</label></div>
				<div class="cell ">
					<span class="property-value" aria-labelledby="home-label">
						<g:textField name="parent.person2.lastName" required="" value=""/>
					</span>
				</div>
			</div>
			<div class="row">	
				<div class="cell "><label id="">Cell number:</label></div>
				<div class="cell ">
					<span class="property-value" aria-labelledby="home-label">
						<g:textField name="parent.person2.mobileNo" required="" value=""/>
					</span>
				</div>			
			</div>
		</div>		
	</div>
	
	<div class="container">
		<h2>Our Partners</h2>
		<div class="table table-2col"> 
			<div class="row">
				<div class="cell "><label id="">Select one of our partners that you are a member of:</label></div>
				<div class="cell ">
				
					<% def partners = cland.membership.Partner.list().sort{it?.name} %>
						<g:radioGroup required=""
							values="${partners?.id}"
							labels="${partners}" 
							value="1"
							name="partner.id">
							${it.radio} <g:message code="${it.label}" />
						</g:radioGroup>
						
				</div>	
			</div>
			<div class="row" id="row-membershipno" style="">
				
				<div class="cell "><label id="">Enter your membership number:</label></div>
				<div class="cell ">
					<span class="property-value" aria-labelledby="home-label">
						<g:textField class="membershipno" name="membershipNo" placeholder="Membership Number"  value="" id="membershipno"/>
					</span>
				</div>
			</div>
		</div>
	</div>
	
	<div  class="container">
		<h2>Children</h2>
		<div class="table">
			<div class="row">
				<div class="cell">
					<div class="table">
						<g:each in="${(1..childcount).toList()}" var="index">
							<div class="row child-form-entry" id="child${index }">
								<div class="cell " style="width:20px;"><h1>${index }.</h1>
									<asset:image src="skin/icon_cross.png" class="child${index }-rmicon rm-child-icon" id="rmicon-child${index }" title="Remove this entry" alt="Remove this entry!"/>
								</div>
								<div class="cell border-bottom">
									<span class="property-value" aria-labelledby="home-label">
										<g:textField class="child${index }" name="child.person.firstname${index }" placeholder="First name"  value="" id="child-firstname-${index }"/>
									</span><br/><br/>
									<span class="property-value" aria-labelledby="home-label">
										<g:textField class="child${index }" name="child.person.lastname${index }" placeholder="Last name"  value="" id="child-lastname-${index }"/><br/>
									</span>
									
								</div>
								<div class="cell border-bottom">
									<span class="property-value" aria-labelledby="home-label">
										<g:textField  name="child.person.dateOfBirth${index }" placeholder="Date of Birth" id="birth-date${index }" class="child${index } datepick_single_past" value=""/>
										</span>
										<br/>
										<span class="property-value" aria-labelledby="home-label">						
										<% def gender = cland.membership.lookup.Keywords.findByName("Gender")?.values?.sort{it?.label} %>
										<g:radioGroup style="margin-top:15px;" 
										class="child${index }"
										values="${gender?.id}"
										labels="${gender}" 
										name="child.person.gender${index }">
										${it.radio} <g:message code="${it.label}" />
										</g:radioGroup>
										</span>
								</div>
								<div class="cell border-bottom">
									<span class="property-value" aria-labelledby="home-label">									
									<textarea class="textbox-child${index } mytextarea" name="child.comments${index }" rows="10" cols="50" style="" placeholder="Comments">${childInstance?.comments }</textarea>
									</span>
								</div>			
							</div>
						</g:each>
					</div>
				</div>
			</div>
			<div class="row">
				<input type="hidden" name="currentChildCount" id="curchild-count" value="1"/>
				<input type="button" class="button1-medium" id="next-child-btn" name="add-child_btn" value="Add Another Child"/>
			</div>			
		</div>
	</div>
	
<script>
	$(document).ready(function(){
		$("[name='partner.id']:radio").on("click",function(){
			if($(this).prop("value") != "None"){
				$("#row-membershipno").show();
				}else{
					$("#row-membershipno").hide();
					}
			});

		$("#pwd-confirm").on("change",function(){
			confirmPassword($("#pwd"), $(this))
		})
		$("#pwd").on("change",function(){
			confirmPassword($("#pwd-confirm"), $(this))
		})	
	});
	var confirmPassword = function(pEl, pcEl){
		var p = pEl.prop("value");
		var pc =pcEl.prop("value") 
		var m = $("#pwd-msg")
		if(pc != p & p !="" & pc != ""){
			pcEl.css("border","solid 1px red").css("color","red").css("font-weight","bold").focus();
			pEl.css("border","solid 1px red").css("color","red").css("font-weight","bold").focus();
			m.show();
		}else if(p == pc & p !="" & pc != ""){
			pcEl.css("border","solid 1px green").css("color","black").css("font-weight","bold").focus();
			pEl.css("border","solid 1px green").css("color","black").css("font-weight","bold").focus();
			m.hide();
		}	
	}
</script>