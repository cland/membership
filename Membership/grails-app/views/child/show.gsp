
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
				<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-child" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<div id="tabs" style="display: none;">
					<ul>
						<li><a href="#tab-1">Child Details</a></li>
						<li><a href="#tab-2">Person Details</a></li>
						<li><a href="#tab-3">Office Details</a></li>
					</ul>
					<div id="tab-1">
			<ol class="property-list child">
			
				<g:if test="${childInstance?.parent}">
				<li class="fieldcontain">
					<span id="parent-label" class="property-label"><g:message code="child.parent.label" default="Parent" /></span>
					
						<span class="property-value" aria-labelledby="parent-label"><g:link controller="parent" action="show" id="${childInstance?.parent?.id}">${childInstance?.parent?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				<g:if test="${childInstance?.person}">
				<li class="fieldcontain">
					<span id="person-label" class="property-label"><g:message code="child.person.label" default="Person" /></span>
					
						<span class="property-value" aria-labelledby="person-label"><g:link controller="person" action="show" id="${childInstance?.person?.id}">${childInstance?.person?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
				
				<g:if test="${childInstance?.accessNumber}">
				<li class="fieldcontain">
					<span id="accessNumber-label" class="property-label"><g:message code="parent.accessNumber.label" default="Access Number" /></span>
					
						<span class="property-value" aria-labelledby="accessNumber-label"><g:fieldValue bean="${childInstance}" field="accessNumber"/></span>
					
				</li>
				</g:if>
				
				<g:if test="${childInstance?.comments}">
				<li class="fieldcontain">
					<span id="comments-label" class="property-label"><g:message code="parent.comments.label" default="Comments" /></span>
					
						<span class="property-value" aria-labelledby="comments-label"><g:fieldValue bean="${childInstance}" field="comments"/></span>
					
				</li>
				</g:if>
				
				<g:if test="${childInstance?.medicalComments}">
				<li class="fieldcontain">
					<span id="medicalComments-label" class="property-label"><g:message code="parent.medicalComments.label" default="Medical Comments" /></span>
					
						<span class="property-value" aria-labelledby="medicalComments-label"><g:fieldValue bean="${childInstance}" field="medicalComments"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${childInstance?.visits}">
				<li class="fieldcontain">
					<span id="visits-label" class="property-label"><g:message code="child.visits.label" default="Visits" /></span>
					
						<g:each in="${childInstance.visits}" var="v">
						<span class="property-value" aria-labelledby="visits-label"><g:link controller="visit" action="show" id="${v.id}">${v?.encodeAsHTML()}</g:link></span>
						</g:each>
					
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
