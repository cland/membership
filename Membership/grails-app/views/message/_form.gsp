<%@ page import="cland.membership.Message" %>



<div class="fieldcontain ${hasErrors(bean: messageInstance, field: 'sendCopyTo', 'error')} ">
	<label for="sendCopyTo">
		<g:message code="message.sendCopyTo.label" default="Send Copy To" />
		
	</label>
	<g:textField name="sendCopyTo" value="${messageInstance?.sendCopyTo}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: messageInstance, field: 'sendBlindCopyTo', 'error')} ">
	<label for="sendBlindCopyTo">
		<g:message code="message.sendBlindCopyTo.label" default="Send Blind Copy To" />
		
	</label>
	<g:textField name="sendBlindCopyTo" value="${messageInstance?.sendBlindCopyTo}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: messageInstance, field: 'outcome', 'error')} ">
	<label for="outcome">
		<g:message code="message.outcome.label" default="Outcome" />
		
	</label>
	<g:textField name="outcome" value="${messageInstance?.outcome}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: messageInstance, field: 'status', 'error')} ">
	<label for="status">
		<g:message code="message.status.label" default="Status" />
		
	</label>
	<g:textField name="status" value="${messageInstance?.status}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: messageInstance, field: 'dateSent', 'error')} ">
	<label for="dateSent">
		<g:message code="message.dateSent.label" default="Date Sent" />
		
	</label>
	<g:datePicker name="dateSent" precision="day"  value="${messageInstance?.dateSent}" default="none" noSelection="['': '']" />

</div>

<div class="fieldcontain ${hasErrors(bean: messageInstance, field: 'sendFrom', 'error')} ">
	<label for="sendFrom">
		<g:message code="message.sendFrom.label" default="Send From" />
		
	</label>
	<g:textField name="sendFrom" value="${messageInstance?.sendFrom}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: messageInstance, field: 'hashcode', 'error')} required">
	<label for="hashcode">
		<g:message code="message.hashcode.label" default="Hashcode" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="hashcode" required="" value="${messageInstance?.hashcode}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: messageInstance, field: 'message', 'error')} required">
	<label for="message">
		<g:message code="message.message.label" default="Message" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="message" required="" value="${messageInstance?.message}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: messageInstance, field: 'sendTo', 'error')} required">
	<label for="sendTo">
		<g:message code="message.sendTo.label" default="Send To" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="sendTo" required="" value="${messageInstance?.sendTo}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: messageInstance, field: 'senderEmail', 'error')} required">
	<label for="senderEmail">
		<g:message code="message.senderEmail.label" default="Sender Email" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="senderEmail" required="" value="${messageInstance?.senderEmail}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: messageInstance, field: 'senderIpAddress', 'error')} required">
	<label for="senderIpAddress">
		<g:message code="message.senderIpAddress.label" default="Sender Ip Address" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="senderIpAddress" required="" value="${messageInstance?.senderIpAddress}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: messageInstance, field: 'senderName', 'error')} required">
	<label for="senderName">
		<g:message code="message.senderName.label" default="Sender Name" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="senderName" required="" value="${messageInstance?.senderName}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: messageInstance, field: 'senderTel', 'error')} required">
	<label for="senderTel">
		<g:message code="message.senderTel.label" default="Sender Tel" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="senderTel" required="" value="${messageInstance?.senderTel}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: messageInstance, field: 'subject', 'error')} required">
	<label for="subject">
		<g:message code="message.subject.label" default="Subject" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="subject" required="" value="${messageInstance?.subject}"/>

</div>

