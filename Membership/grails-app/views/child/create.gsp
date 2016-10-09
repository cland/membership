<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'child.label', default: 'Child')}" />
		<title><g:message code="default.create.label" args="[entityName]" /></title>
		<g:render template="head" var="thisInstance" bean="${childInstance }" model="[sidenav:page_nav]"></g:render>
	</head>
	<body>
		<a href="#create-child" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav navpage" role="navigation">
			<ul>
				<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="create-child" class="content scaffold-create" role="main">
			<h1><g:message code="default.create.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<g:hasErrors bean="${childInstance}">
			<ul class="errors" role="alert">
				<g:eachError bean="${childInstance}" var="error">
				<li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
				</g:eachError>
			</ul>
			</g:hasErrors>
			<g:uploadForm url="[resource:childInstance, action:'save']" >
			<div id="tabs" style="display: none;">
					<ul>
						<li><a href="#tab-1">Child Details</a></li>
						<li><a href="#tab-2">Person Details</a></li>
						<li><a href="#tab-3">Office Details</a></li>
					</ul>
					<div id="tab-1">
				<fieldset class="form">
					<g:render template="form"/>
				</fieldset>
				</div>
				<div id="tab-2">
				<fieldset class="form">
					<tmpl:/person/list/>
				</fieldset>
				</div>
				<div id="tab-3">
				<fieldset class="form">
					<tmpl:/office/form/>
				</fieldset>
				</div>
				<fieldset class="buttons">
					<g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" />
				</fieldset>
				</div>
			</g:uploadForm>
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
