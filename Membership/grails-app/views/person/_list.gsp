<legend>Person Details</legend>
<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'firstName', 'error')} required">
			<label for="firstName">
				<g:message code="person.firstName.label" default="First Name" />
				<span class="required-indicator">*</span>
			</label>
			<g:textField name="firstName" required="" value="${personInstance?.firstName}"/>
		
		</div>
		<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'lastName', 'error')} ">
			<label for="lastName">
				<g:message code="person.lastName.label" default="Last Name" />
				
			</label>
			<g:textField name="lastName" value="${personInstance?.lastName}"/>
		
		</div>
		<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'dateOfBirth', 'error')} ">
			<label for="dateOfBirth">
				<g:message code="person.dateOfBirth.label" default="Date Of Birth"  />
				
			</label>
		<%--	<g:datePicker required="" name="dateOfBirth" precision="day"  value="${personInstance?.dateOfBirth}" default="none" relativeYears="[-80..-2]" noSelection="['': '-choose-']" />--%>
			<g:datePicker name="dateOfBirth" id="birth-date" class="datepick_single_past" value="${personInstance?.dateOfBirth}"/>
		</div>
		<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'race', 'error')} ">
			<label for="race">
				<g:message code="person.race.label" default="Race" />
				
			</label>
			<g:select id="race" name="race.id" from="${cland.membership.Race.list()}" optionKey="id" value="${personInstance?.race?.id}" class="many-to-one" noSelection="['null': '']"/>
		
		</div>
		
		<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'knownAs', 'error')} ">
			<label for="knownAs">
				<g:message code="person.knownAs.label" default="Known As" />
				
			</label>
			<g:textField name="knownAs" value="${personInstance?.knownAs}"/>
		
		</div>
		
		<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'title', 'error')} ">
			<label for="title">
				<g:message code="person.title.label" default="Title" />
				
			</label>
			<g:textField name="title" value="${personInstance?.title}"/>
		
		</div>
		
		<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'email', 'error')} ">
			<label for="email">
				<g:message code="person.email.label" default="Email" />
				
			</label>
			<g:textField name="email" value="${personInstance?.email}"/>
		
		</div>
		
		<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'gender', 'error')} ">
			<label for="gender">
				<g:message code="person.gender.label" default="Gender" />
				
			</label>
			<g:textField name="gender" value="${personInstance?.gender}"/>
		
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
				

		<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'email', 'error')} required">
			<label for="email">
				<g:message code="user.email.label" default="Email" />
				<span class="required-indicator">*</span>
			</label>
			<g:field type="email" name="email" required="" value="${personInstance?.email}"/>
		</div>
			
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
