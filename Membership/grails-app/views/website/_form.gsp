<%@ page import="cland.membership.Website" %>



<div class="fieldcontain ${hasErrors(bean: websiteInstance, field: 'sendCopyTo', 'error')} ">
	<label for="sendCopyTo">
		<g:message code="website.sendCopyTo.label" default="Send Copy To" />
		
	</label>
	<g:textField name="sendCopyTo" value="${websiteInstance?.sendCopyTo}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: websiteInstance, field: 'sendBlindCopyTo', 'error')} ">
	<label for="sendBlindCopyTo">
		<g:message code="website.sendBlindCopyTo.label" default="Send Blind Copy To" />
		
	</label>
	<g:textField name="sendBlindCopyTo" value="${websiteInstance?.sendBlindCopyTo}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: websiteInstance, field: 'bodyTemplate', 'error')} ">
	<label for="bodyTemplate">
		<g:message code="website.bodyTemplate.label" default="Body Template" />
		
	</label>
	<g:textField name="bodyTemplate" value="${websiteInstance?.bodyTemplate}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: websiteInstance, field: 'sendFrom', 'error')} ">
	<label for="sendFrom">
		<g:message code="website.sendFrom.label" default="Send From" />
		
	</label>
	<g:textField name="sendFrom" value="${websiteInstance?.sendFrom}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: websiteInstance, field: 'subjectTemplate', 'error')} ">
	<label for="subjectTemplate">
		<g:message code="website.subjectTemplate.label" default="Subject Template" />
		
	</label>
	<g:textField name="subjectTemplate" value="${websiteInstance?.subjectTemplate}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: websiteInstance, field: 'sendTo', 'error')} required">
	<label for="sendTo">
		<g:message code="website.sendTo.label" default="Send To" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="sendTo" required="" value="${websiteInstance?.sendTo}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: websiteInstance, field: 'sitename', 'error')} required">
	<label for="sitename">
		<g:message code="website.sitename.label" default="Sitename" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="sitename" required="" value="${websiteInstance?.sitename}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: websiteInstance, field: 'siteurl', 'error')} required">
	<label for="siteurl">
		<g:message code="website.siteurl.label" default="Siteurl" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="siteurl" required="" value="${websiteInstance?.siteurl}"/>

</div>

