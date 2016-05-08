
<%@ page import="cland.membership.Parent" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'parent.label', default: 'Parent')}" />
		<title><g:message code="default.show.label" args="[entityName]" />: ${parentInstance }</title>
		<g:render template="head" var="thisInstance" bean="${parentInstance }" model="[sidenav:page_nav]"></g:render>
	</head>
	<body>
		<a href="#show-parent" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav navpage" role="navigation">
			<ul>
				<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				
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
					</ul>
				<div id="tab-1">
					<g:render template="client" bean="${parentInstance}" var="parentInstance" model="[mode:'read']"></g:render>
				</div>
			<div id="tab-2">
				<g:if test="${parentInstance.children}">
					<table>
						<thead>
							<tr>
								<th>Name</th>
								<th>Date</th>
								<th>Time-in</th>
								<th>Time-out</th>
								<th>Contact No.</th>
								<th>Status</th>								
							</tr>
						</thead>
						<g:each in="${parentInstance?.children }" var="child" status="i">
							<g:each in="${child?.visits.sort{it.starttime}.reverse()}" var="c">
								<tr>
									<td><g:link controller="child" action="show" id="${child?.id}">${child?.person }</g:link></td>						
									<td>${c?.starttime?.format("dd MMM yyyy")}</td>
									<td>${c?.starttime?.format("hh:mm")}</td>
									<td>${c?.endtime?.format("HH:mm")}</td>
									<td>${c?.contactNo}</td>
									<td>${c?.status}</td>
									
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
				<g:if test="${parentInstance.notifications}">
					<table>
						<thead>
							<tr>
								<th>Date Sent</th>
								<th>Child's Name</th>																
								<th>Sent To</th>
								<th>Status</th>								
							</tr>
						</thead>
						<g:each in="${parentInstance?.notifications }" var="note" status="i">
							
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
					</table>
				</g:if>
			</div>
			<g:form url="[resource:parentInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${parentInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
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
