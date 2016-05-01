<g:set var="activeVisit" value="${childInstance?.activeVisit }"/>
<g:set var="parent" value="${childInstance?.parent }"/>
<g:set var="visits" value="${childInstance.visits?.sort{it.starttime}.reverse() }"/>
<%@ page import="cland.membership.Child" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'child.label', default: 'Child')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
		<g:render template="head" var="thisInstance" bean="${parentInstance }" model="[sidenav:page_nav]"></g:render>
		
	</head>
	<body>
		<a href="#show-child" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav navpage" role="navigation">
			<ul>
				<li><g:link class="create" controller="parent" action="show" id="${parent?.id }">Parent: ${parent }</g:link></li>				
			</ul>
		</div>
		<div id="show-child" class="content scaffold-show" role="main">
			<h1 class="hide">Child: ${childInstance } (${parent?.membershipNo +"-" + childInstance?.accessNumber})</h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<fieldset>
				<legend>Child's Profile</legend>
				<div class="table">
					<div class="row">
						<div class="cell">
							<div class="table">
								<div class="row">
									<div class="cell"><label id="">First name:</label></div>
									<div class="cell">${childInstance?.person?.firstName }</div>
									<div class="cell"><label id="">Last name:</label></div>
									<div class="cell">${childInstance?.person?.lastName }</div>
								</div>
								<div class="row">
									<div class="cell"><label id="">Gender:</label></div>
									<div class="cell">${childInstance?.person?.gender }</div>
									<div class="cell"><label id="">D.O.B:</label></div>
									<div class="cell">${childInstance?.person?.dateOfBirth?.format("dd-MMM-yyyy")} (${childInstance?.person?.age } yrs)</div>
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
								<div class="row">
									<div class="cell"><label id="">Emergency contact:</label></div>
									<div class="cell">${parent?.person2 }</div>
									<div class="cell"><label id="">Contact No:</label></div>
									<div class="cell">${parent?.person2?.mobileNo}</div>
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
				</ul>
				<div id="tab-1">
				<g:if test="${activeVisit}">	
					<fieldset style="text-align:center;"><legend>Current Visit Photo</legend>
						<attachments:each bean="${activeVisit}">
							<img src="${request.contextPath}/attachmentable/show/${attachment?.id }" style="width:300px;"/><br/>
						</attachments:each>
						<label>Check-in date-time: </label> ${activeVisit?.starttime?.format("dd MMM yyyy HH:mm")}<br/>
						<input type="submit" class="button" id="btn_notify" onclick="sendNotification()" name="btn_notify" value="Notify" />
					 	<input type="submit" class="button" id="btn_checkout" onclick="checkOut()" name="btn_checkout" value="Check-Out" />
					 	<input type="submit" class="button" id="btn_view" onclick="checkOut()" name="btn_view" value="Cancel" />
					</fieldset>		
				</g:if>
				<g:if test="${childInstance.visits}">
					<table>
						<thead>
							<tr>
								<th>Date</th>
								<th>Time-in</th>
								<th>Time-out</th>
								<th>Contact No.</th>
								<th>Status</th>								
							</tr>
						</thead>
						<g:each in="${visits}" var="c">
							<tr>								
								<td>${c?.starttime?.format("dd MMM yyyy")}</td>
								<td>${c?.starttime?.format("hh:mm")}</td>
								<td>${c?.endtime?.format("HH:mm")}</td>
								<td>${c?.contactNo}</td>
								<td>${c?.status}</td>
								
							</tr>
						</g:each>
					</table>
				</g:if>
				
				</div>
			
			<g:form url="[resource:childInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${childInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
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
		});  
		</script>
	</body>
</html>
