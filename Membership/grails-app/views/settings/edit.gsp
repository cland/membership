<%@ page import="cland.membership.Settings" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'settings.label', default: 'Settings')}" />
		<title><g:message code="default.edit.label" args="[entityName]" /></title>
		<g:render template="head" />
		<asset:javascript src="jquery-ui.multidatespicker.js"/>
	</head>
	<body>
		<a href="#edit-settings" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		
		<div id="edit-settings" class="content scaffold-edit" role="main">
			<h1><g:message code="default.edit.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<g:hasErrors bean="${settingsInstance}">
			<ul class="errors" role="alert">
				<g:eachError bean="${settingsInstance}" var="error">
				<li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
				</g:eachError>
			</ul>
			</g:hasErrors>
			<div id="tabs" style="display: none;">
						<ul>
					<li><a href="#tab-1">Configuration</a></li>
					<li><a href="#tab-2">Staff</a></li>
					<li><a href="#tab-3">Notification Templates</a></li>
				</ul>
				<div id="tab-1">
					<g:form url="[resource:settingsInstance, action:'update']" method="PUT" >
						<g:hiddenField name="version" value="${settingsInstance?.version}" />
						<fieldset class="form">
							<g:render template="form"/>
						</fieldset>
						<fieldset class="buttons">
							<g:actionSubmit class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" />
							<input type="button" name="cancel" onclick="document.location='${request.contextPath}'" class="cancel" value="${message(code: 'default.button.cancel.label', default: 'Cancel')}" />
						</fieldset>
					</g:form>
				</div>
				<div id="tab-2">
					<table>
					<thead>
							<tr>
							
								<g:sortableColumn property="username" title="${message(code: 'person.username.label', default: 'Username')}" />
							
								<g:sortableColumn property="firstName" title="${message(code: 'person.firstName.label', default: 'First Name')}" />
							
								<th><g:message code="person.race.label" default="Race" /></th>
							
								<g:sortableColumn property="accountExpired" title="${message(code: 'person.accountExpired.label', default: 'Account Expired')}" />
							
								<g:sortableColumn property="knownAs" title="${message(code: 'person.knownAs.label', default: 'Known As')}" />
							
							</tr>
						</thead>
						<tbody>
						<g:each in="${personInstanceList}" status="i" var="personInstance">
							<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
							
								<td><g:link action="show" id="${personInstance.id}">${fieldValue(bean: personInstance, field: "username")}</g:link></td>
							
								<td>${fieldValue(bean: personInstance, field: "firstName")}</td>
							
								<td>${fieldValue(bean: personInstance, field: "lastName")}</td>										
							
								<td>${fieldValue(bean: personInstance, field: "username")}</td>
							
							</tr>
						</g:each>
						</tbody>
					</table>
				</div>
				<div id="tab-3">
					<p> Notification templates defined here.</p>
				</div>
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
				$( "#birth-date" ).datepicker({
					dateFormat: "dd-M-yy",
					altFormat: "yy-mm-dd",
					defaultDate : "-18y",					
					maxDate:"-2y",
					minDate:"-90y"
					});		                
			});  
		</script>
	</body>
</html>
