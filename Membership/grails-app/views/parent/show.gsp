
<%@ page import="cland.membership.Parent" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'parent.label', default: 'Parent')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
		<g:render template="head" var="thisInstance" bean="${parentInstance }" model="[sidenav:page_nav]"></g:render>
	</head>
	<body>
		<a href="#show-parent" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav navpage" role="navigation">
			<ul>
				<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-parent" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<div id="tabs" style="display: none;">
					<ul>
						<li><a href="#tab-1">Parent Details</a></li>
						<li><a href="#tab-2">Person Details</a></li>
						<li><a href="#tab-3">Office Details</a></li>
					</ul>
					<div id="tab-1">
			<ol class="property-list parent">
			
				<g:if test="${parentInstance?.children}">
				<li class="fieldcontain">
					<span id="children-label" class="property-label"><g:message code="parent.children.label" default="Children" /></span>
					
					<table>
					<thead>
					<tr><th>ID</th>
					<th>First Name</th>
					<th>Date Of Birth</th>
					<th>Gender</th></tr>
					</thead>
						<g:each in="${parentInstance.children}" var="c">
						<tr><td><span class="property-value" aria-labelledby="children-label"><g:link controller="child" action="show" id="${c.id}">${c?.encodeAsHTML()}</g:link></span>
						</td>
						<td>${c?.person?.firstName}</td>
						<td>${c?.person?.dateOfBirth}</td>
						<td>${c?.person?.gender}</td>
						</tr>
						</g:each>
						</table>
					
				</li>
				</g:if>
			
				<g:if test="${parentInstance?.person1}">
				<li class="fieldcontain">
					<span id="person1-label" class="property-label"><g:message code="parent.person1.label" default="Person1" /></span>
					
						<span class="property-value" aria-labelledby="person1-label"><g:link controller="person" action="show" id="${parentInstance?.person1?.id}">${parentInstance?.person1?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
							
				<g:if test="${parentInstance?.person2}">
				<li class="fieldcontain">
					<span id="person2-label" class="property-label"><g:message code="parent.person2.label" default="Person2" /></span>
					
						<span class="property-value" aria-labelledby="person2-label"><g:link controller="person" action="show" id="${parentInstance?.person2?.id}">${parentInstance?.person2?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
				<g:if test="${parentInstance?.membershipNo}">
				<li class="fieldcontain">
					<span id="membershipNo-label" class="property-label"><g:message code="parent.membershipNo.label" default="Membership Number" /></span>
					
						<span class="property-value" aria-labelledby="membershipNo-label"><g:fieldValue bean="${parentInstance}" field="membershipNo"/></span>
					
				</li>
				</g:if>
				<g:if test="${parentInstance?.clientType}">
				<li class="fieldcontain">
					<span id="clientType-label" class="property-label"><g:message code="parent.clientType.label" default="Client Type" /></span>
					
						<span class="property-value" aria-labelledby="clientType-label"><g:fieldValue bean="${parentInstance}" field="clientType"/></span>
					
				</li>
				</g:if>
				<g:if test="${parentInstance?.comments}">
				<li class="fieldcontain">
					<span id="comments-label" class="property-label"><g:message code="parent.comments.label" default="Comments" /></span>
					
						<span class="property-value" aria-labelledby="comments-label"><g:fieldValue bean="${parentInstance}" field="comments"/></span>
					
				</li>
				</g:if>
				
			
			</ol>
			</div>
			<div id="tab-2">
			<p>===PERSON DETAIS===</p>
			</div>
			<div id="tab-3">
			<p>====OFFICE DETAILS</p>
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
