<%@ page import="cland.membership.Parent" %>
<g:set var="settingsInstance" value="${cland.membership.Settings.find{true}}"/>
<% def childcount=settingsInstance?.newchildcount %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'parent.label', default: 'Parent')}" />
		<title><g:message code="default.create.label" args="[entityName]" /></title>
		<g:render template="head" var="thisInstance" bean="${parentInstance }" model="[sidenav:page_nav]"></g:render>
	</head>
	<body>
		<a href="#create-parent" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav navpage" role="navigation">
			<ul>				
				<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="create-parent" class="content scaffold-create" role="main">
			<h1><g:message code="default.create.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<g:hasErrors bean="${parentInstance}">
			<ul class="errors" role="alert">
				<g:eachError bean="${parentInstance}" var="error">
				<li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
				</g:eachError>
			</ul>
			</g:hasErrors>
			
			<g:form url="[resource:parentInstance, action:'save']" >
				<div id="tabs" style="display: none;">
					<ul>
						<li><a href="#tab-1">Details</a></li>
						<li><a href="#tab-2">Supporting Documents</a></li>
					</ul>
					<div id="tab-1">
						<g:render template="client" bean="${parentInstance}" var="parentInstance" model="[mode:'edit']"></g:render>						
					</div>
					<div id="tab-2">
						
					</div>
					
				</div>
				<fieldset class="buttons">
					<g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" />
					<input type="button" name="cancel" onclick="document.location='${request.contextPath}/parent/'" class="cancel" value="${message(code: 'default.button.cancel.label', default: 'Cancel')}" />
				</fieldset>
			</g:form>
			</div>
			
		
		<script>
		$(document).ready(function() {		
			//setup the datepicker calendars
			var newchildcount = ${childcount};
			for(var i=0;i<newchildcount;i++){
				initBirthDatePicker($( "#birth-date" + (i+1) ),"-2y");
				initTimePicker($("#visit_time" + (i+1)),"")
			}
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
		function initBirthDatePicker(el,def){
			el.datepicker({
				dateFormat: "dd-M-yy",
				altFormat: "yy-mm-dd",
				defaultDate : def,					
				maxDate:"-0y",
				minDate:"-90y"
				});
		}	
		function initTimePicker(el,def){			
			el.datetimepicker({
				controlType: 'select',
				oneLine: true,
				timeFormat: 'HH:mm', // 'hh:mm tt',
				dateFormat: "dd-M-yy",
				altFormat: "yy-mm-dd HH:mm",
				stepMinute: 5
			});
			el.prop("value",getAussieDate("DD-MMM-YYYY HH:mm"))
		}
		function getAussieDate(fmt,datestring){
			if(fmt === undefined || fmt ==="") fmt = 'DD MMMM YYYY HH:mm:ss';
			if(datestring === undefined || datestring === "") 
				return moment().tz("Australia/Perth").format(fmt);
			else
				return moment(datestring).tz("Australia/Perth").format(fmt);
		}
		</script>		
	</body>
</html>
