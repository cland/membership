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
							
								<th><g:message code="person.lastName.label" default="Last Name" /></th>
							
								<g:sortableColumn property="accountExpired" title="${message(code: 'person.accountExpired.label', default: 'Account Expired')}" />
							
							</tr>
						</thead>
						<tbody>
						<g:each in="${personInstanceList}" status="i" var="personInstance">
							<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
							
								<td><g:link action="show" id="${personInstance.id}">${fieldValue(bean: personInstance, field: "username")}</g:link></td>
							
								<td>${fieldValue(bean: personInstance, field: "firstName")}</td>
							
								<td>${fieldValue(bean: personInstance, field: "lastName")}</td>										
							
								<td>${fieldValue(bean: personInstance, field: "accountExpired")}</td>
							
							</tr>
						</g:each>
						</tbody>
					</table>
					<fieldset>
						<legend >New Staff</legend>
							<div class="table">
								<div class="row">
									<div class="cell"><label id="">First name:</label></div>
									<div class="cell">
										<span class="property-value" aria-labelledby="home-label">
											<g:textField name="person1.firstName" required="" value=""/>
										</span>
									</div>	
									<div class="cell"><label id="">Cell number:</label></div>
									<div class="cell">
										<span class="property-value" aria-labelledby="home-label">
											<g:textField name="person1.mobileNo" value=""/>
										</span>
									</div>			
								</div>
								<div class="row">
									<div class="cell"><label id="">Last name:</label></div>
									<div class="cell">
										<span class="property-value" aria-labelledby="home-label">
											<g:textField name="person1.lastName" required="" value=""/>
										</span>
									</div>
									<div class="cell"><label id="">Email:</label></div>
									<div class="cell">
										<span class="property-value" aria-labelledby="home-label">
											<g:textField name="person1.email" value=""/>
										</span>
									</div>			
								</div>
						
								<div class="row">
									<div class="cell"><label id="">Username:</label></div>
									<div class="cell">
										<span class="property-value" aria-labelledby="home-label">
											<g:textField name="person1.username" value=""/>
										</span>
									</div>		
									<div class="cell"><label id="">Password:</label></div>
									<div class="cell">
										<span class="property-value" aria-labelledby="home-label">
											<g:field type="password" name="password" required="" value=""/><br/>
											Confirm: <g:field type="password" name="passwordConfirm" required="" value=""/>
										</span>
									</div>			
								</div>
								<div class="row">
									<div class="cell"><label id="">Enabled:</label></div>
									<div class="cell">
										<span class="property-value" aria-labelledby="home-label">
											<g:textField name="person1.username" value=""/>
										</span>
									</div>		
									<div class="cell"><label id=""></label></div>
									<div class="cell">
										<span class="property-value" aria-labelledby="home-label">
											
										</span>
									</div>			
								</div>
							
							</div>
							<fieldset><legend>Access Rights</legend>
		<div>
			<div id="group-finder-div">
				Find a Group: <input id="group-search" name="group_search" value=""/>
			</div>
		
			<table id="groups-table-office">
			<thead>
				<tr>
					<th></th>
					<g:sortableColumn property="name" title="${message(code: 'roleGroup.name.label', default: 'Group Name')}" />					
					<g:sortableColumn property="description" title="${message(code: 'roleGroup.description.label', default: 'Description')}" />					
				</tr>
			</thead>
			<tbody id="groups-list">
			<g:each in="${(params.action=="create"? [] : (personInstance?.authorities?.size() > 0 ? personInstance?.authorities:personInstance?.person?.office?.officeGroups))}" status="i" var="roleGroupInstance">
				<g:set var="isRoleChecked" value="false" />
				<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					<g:if test="${personInstance?.authorities?.contains(roleGroupInstance) }">
						<g:set var="isRoleChecked" value="true" />
					</g:if>
					<td><g:checkBox name="officegroups" value="${roleGroupInstance.id}" checked='${isRoleChecked}' label=""/></td>
					<td><g:link controller="roleGroup" action="show" id="${roleGroupInstance.id}">${fieldValue(bean: roleGroupInstance, field: "name")}</g:link></td>					
					<td>${fieldValue(bean: roleGroupInstance, field: "description")}</td>					
				</tr>
			</g:each>
			</tbody>
			</table>
		</div>
		
		
	</fieldset>	
					</fieldset>
				</div>
				<div id="tab-3">
					<fieldset>
						<legend>New Notification Template</legend>
							<div class="table">
								<div class="row">
									<div class="cell"><label id="">Title:</label></div>
									<div class="cell">
										<span class="property-value" aria-labelledby="home-label">
											<g:textField name="template.title" required="" value=""/>
										</span>
									</div>										
								</div>
								<div class="row">
									<div class="cell"><label id="">Message:</label></div>
									<div class="cell">
										<span class="property-value" aria-labelledby="home-label">
											
											<g:textArea name="template.body" rows="6"></g:textArea>
										</span>
									</div>											
								</div>														
							
							</div>
						</fieldset>
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

				// Groups Picker
				$( "#group-search" ).catcomplete({
					source: function(request,response) {
						$.ajax({
							url : "${g.createLink(controller: 'acl', action: 'grouplist')}", 
							dataType: "json",
							data : request,
							success : function(data) {
								response(data); // set the response
							},
							error : function() { // handle server errors
								alert("Unable to retrieve records");
							}
						});
					},
					minLength : 2, // triggered only after minimum 2 characters have been entered.
					select : function(event, ui) { // event handler when user selects a company from the list.
						var _id = ui.item.id;
						var _name = ui.item.rolegroup.name
						var _desc = ui.item.rolegroup.description
						var _tbody = $("#groups-list");
						var _sel = 'checked';
						var _chbox = "<input type='checkbox' name='officegroups' value='" + _id + "' " +_sel+ " class='group-other'/>";
						_tbody.append("<tr><td>" + _chbox + "</td><td>" + _name + "</td><td>" + _desc + "</td>");	
						ui.item.value = ""
					}
				});	
				 $.widget( "custom.catcomplete", $.ui.autocomplete, {
						_create: function() {
							this._super();
							this.widget().menu( "option", "items", "> :not(.ui-autocomplete-category)" );
						},
						_renderMenu: function( ul, items ) {
							var that = this,
							currentCategory = "";
							$.each( items, function( index, item ) {
								var li;
								if ( item.category != currentCategory ) {
									ul.append( "<li class='ui-autocomplete-category'>" + item.category + "</li>" );
									currentCategory = item.category;
								}
								li = that._renderItemData( ul, item );
								if ( item.category ) {
									li.attr( "aria-label", item.category + " : " + item.label );
								}
							});
						}
					});                
			});  
		</script>
	</body>
</html>
