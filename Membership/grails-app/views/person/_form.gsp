<%@page import="org.apache.jasper.compiler.Node.ParamsAction"%>
<%@ page import="cland.membership.security.Person" %>
<%@ page import="cland.membership.Parent" %>

<div id="tabs" style="display: none;">
	<ul>
		<li><a href="#tab-1">Person Details</a></li>
		<li><a href="#tab-2">Security Settings</a></li>
	</ul>
	<div id="tab-1">
	
		<fieldset><legend>Person Details</legend>
		
		<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'firstName', 'error')} required">
			<label for="firstName">
				<g:message code="person.firstName.label" default="First Name" />
				<span class="required-indicator">*</span>
			</label>
			<g:textField name="firstName" required="" value="${personInstance?.firstName?:parentInstance?.person?.firstName}"/>
		
		</div>
		<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'lastName', 'error')} ">
			<label for="lastName">
				<g:message code="person.lastName.label" default="Last Name" />
				<span class="required-indicator">*</span>
			</label>
			<g:textField name="lastName" required="" value="${personInstance?.lastName}"/>
		
		</div>
	
		<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'mobileNo', 'error')} ">
			<label for="mobileNo">
				<g:message code="person.mobileNo.label" default="Mobile No." />
				<span class="required-indicator">*</span>
			</label>
			<g:textField name="mobileNo" required="" value="${personInstance?.mobileNo}"/>
		
		</div>
				
		<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'email', 'error')} required">
			<label for="email">
				<g:message code="user.email.label" default="Email" />
				<span class="required-indicator">*</span>
			</label>
			<g:field type="email" name="email" required="" value="${personInstance?.email}"/>
		</div>
		
		<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'gender', 'error')} ">
			<label for="gender">
				<g:message code="person.gender.label" default="Gender" />
				
			</label>
			<% def gender = cland.membership.lookup.Keywords.findByName("Gender")?.values?.sort{it?.label} %>
						<g:radioGroup style="margin-top:15px;" 
							values="${gender?.id}"
							value="${personInstance?.gender?.id }"
							labels="${gender}" 
							name="gender">
							${it.radio} <g:message code="${it.label}" />
						</g:radioGroup>
		</div>
		<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'dateOfBirth', 'error')} ">
			<label for="dateOfBirth">
				<g:message code="person.dateOfBirth.label" default="Date Of Birth"  />
				
			</label>
		<%--	<g:datePicker required="" name="dateOfBirth" precision="day"  value="${personInstance?.dateOfBirth}" default="none" relativeYears="[-80..-2]" noSelection="['': '-choose-']" />--%>
			<g:textField name="dateOfBirth" id="birth-date" class="datepick_single_past" value="${personInstance?.dateOfBirth?.format('dd-MMM-yyyy')}"/>
		</div>
		<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'office', 'error')} ">
			<label for="office">
				<g:message code="person.office.label" default="Office" />
				<span class="required-indicator">*</span>
			</label>
			<g:select id="office" name="office.id" from="${cland.membership.Office.list()}" optionKey="id" required="" value="1" class="many-to-one" noSelection="['': '']"/>
		
		</div>
		
		</fieldset>
	</div>
	
	<div id="tab-2">
	<fieldset><legend>Login Details</legend>
	<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'username', 'error')} required">
			<label for="username">
				<g:message code="user.username.label" default="Username" />
				<span class="required-indicator">*</span>
			</label>
			<g:textField name="username" required="" value="${personInstance?.username}"/>
		</div>

		<g:if test="${params?.action == 'create'||params?.action == 'save'}">
			<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'password', 'error')} required">
				<label for="password">
					<g:message code="user.password.label" default="Password" />
					<span class="required-indicator">*</span>
				</label>
				<g:field type="password" name="password" required="" value="${personInstance?.password}"/>
			</div>
			<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'password', 'error')} required">
				<label for="passwordConfirm">
					<g:message code="user.passwordconfirm.label" default="Confirm Password" />
					<span class="required-indicator">*</span>
				</label>
				<g:field type="password" name="passwordConfirm" required="" value=""/>
			</div>
		</g:if>
		
		<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'enabled', 'error')} ">
			<label for="enabled">
				<g:message code="user.enabled.label" default="Enabled" />				
			</label>
			<g:checkBox name="enabled" value="${personInstance?.enabled}" />
		</div>
		
		<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'accountExpired', 'error')} ">
			<label for="accountExpired">
				<g:message code="user.accountExpired.label" default="Account Expired" />
				
			</label>
			<g:checkBox name="accountExpired" value="${personInstance?.accountExpired}" />
		</div>
		
		<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'accountLocked', 'error')} ">
			<label for="accountLocked">
				<g:message code="user.accountLocked.label" default="Account Locked" />
				
			</label>
			<g:checkBox name="accountLocked" value="${personInstance?.accountLocked}" />
		</div>
		
		<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'passwordExpired', 'error')} ">
			<label for="passwordExpired">
				<g:message code="user.passwordExpired.label" default="Password Expired" />
				
			</label>
			<g:checkBox name="passwordExpired" value="${personInstance?.passwordExpired}" />
		</div>
	</fieldset>
	
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
			<g:each in="${(params.action=="create"? [] : (personInstance?.authorities?.size() > 0 ? personInstance?.authorities:personInstance?.office?.officeGroups))}" status="i" var="roleGroupInstance">
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
	</div>		
</div>



<script type="text/javascript">
<!--  
$(document).ready(function() {

	//** PERSON CLIENT Auto Complete Call **//
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

	//** Person Picker			
	$( "#person-clients" ).catcomplete({
		source: function(request,response) {
			$.ajax({
				url : "${g.createLink(controller: 'person', action: 'personlist')}", 
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
			var _firstname = ui.item.firstName
			var _lastname = ui.item.lastName
			var _gender = (ui.item.gender == null ? null : ui.item.person.gender)
			var _raceid = (ui.item.race == null ? null : ui.item.person.race.id)
			var _officeid = (ui.item.office  == null ? null : ui.item.person.office.id)
			var _officegrps = (ui.item.officegroups == null?null:ui.item.officegroups)
			var _usergrps = (ui.item.usergroups == null?null:ui.item.usergroups)
			 //ui.item.person.firstName + " " + ui.item.person.lastName + " Gender: " + ui.item.person.gender
			$("#personid").prop("value",_id)
			$("input[name='firstName']").prop("value",_firstname) 
			$("input[name='lastName']").prop("value",_lastname)
			if(_gender) $("select[name='gender'] option[value=" + _gender + "]").prop("selected","selected")
			if(_raceid != null) $("select[name='race.id'] option[value=" + _raceid + "]").prop("selected","selected")
			if(_officeid != null) $("select[name='office.id'] option[value=" + _officeid + "]").prop("selected","selected")
			
			//update the groups list base on the office selected
			if(_officegrps != null){
				var _tbody = $("#groups-list");				
				_tbody.html("");
				$.each(_officegrps,function(item){
					var _sel = '';
					var _chbox = "<input type='checkbox' name='officegroups' value='" + this.id + "' " +_sel+ "/>";
					_tbody.append("<tr><td>" + _chbox + "</td><td>" + this.name + "</td><td>" + this.description + "</td>");	
				})
									
			}
			ui.item.value = ""
		}
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
});
//-->
</script>