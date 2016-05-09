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
		<g:if test="${parentInstance.children}">
		<table>
			<thead>
				<tr>
					<th>First Name</th>
					<th>Last Name</th>
					<th>Date Of Birth</th>
					<th>Gender</th>
					<th>Total Visits</th>
					<th>Checked-In?</th>
					
				</tr>
			</thead>
			<g:each in="${parentInstance.children}" var="c">
				<tr>
					<td><span class="property-value" aria-labelledby="children-label"><g:link controller="child" action="show" id="${c.id}">${c?.person?.firstName}</g:link></span>
					</td>
					<td>${c?.person?.lastName}</td>
					<td>${c?.person?.dateOfBirth?.format("dd MMM yyyy")}</td>
					<td>${c?.person?.gender}</td>
					<td>${c?.getVisitCount()}</td>
					<td><g:formatBoolean boolean="${c?.isActive() }" false="No" true="Yes"/></td>
					
				</tr>
			</g:each>
		</table>
		
		<hr/><br/>
		</g:if>
		<g:if test="${isEditMode }">
			<h3>Add New</h3>
			
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
		</g:if>
	</fieldset>
	
