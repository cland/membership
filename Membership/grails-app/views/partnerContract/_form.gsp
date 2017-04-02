<%@ page import="cland.membership.PartnerContract" %>



<div class="fieldcontain ${hasErrors(bean: partnerContractInstance, field: 'lastUpdatedBy', 'error')} required">
	<label for="lastUpdatedBy">
		<g:message code="partnerContract.lastUpdatedBy.label" default="Last Updated By" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="lastUpdatedBy" type="number" value="${partnerContractInstance.lastUpdatedBy}" required=""/>

</div>

<div class="fieldcontain ${hasErrors(bean: partnerContractInstance, field: 'createdBy', 'error')} required">
	<label for="createdBy">
		<g:message code="partnerContract.createdBy.label" default="Created By" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="createdBy" type="number" value="${partnerContractInstance.createdBy}" required=""/>

</div>

<div class="fieldcontain ${hasErrors(bean: partnerContractInstance, field: 'history', 'error')} ">
	<label for="history">
		<g:message code="partnerContract.history.label" default="History" />
		
	</label>
	<g:textField name="history" readonly="readonly" value="${partnerContractInstance?.history}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: partnerContractInstance, field: 'comments', 'error')} ">
	<label for="comments">
		<g:message code="partnerContract.comments.label" default="Comments" />
		
	</label>
	<g:textField name="comments" value="${partnerContractInstance?.comments}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: partnerContractInstance, field: 'contractNo', 'error')} required">
	<label for="contractNo">
		<g:message code="partnerContract.contractNo.label" default="Contract No" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="contractNo" required="" value="${partnerContractInstance?.contractNo}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: partnerContractInstance, field: 'dateRegistered', 'error')} required">
	<label for="dateRegistered">
		<g:message code="partnerContract.dateRegistered.label" default="Date Registered" />
		<span class="required-indicator">*</span>
	</label>
	<g:datePicker name="dateRegistered" precision="day"  value="${partnerContractInstance?.dateRegistered}"  />

</div>

<div class="fieldcontain ${hasErrors(bean: partnerContractInstance, field: 'isUserVerified', 'error')} ">
	<label for="isUserVerified">
		<g:message code="partnerContract.isUserVerified.label" default="Is User Verified" />
		
	</label>
	<g:checkBox name="isUserVerified" value="${partnerContractInstance?.isUserVerified}" />

</div>

<div class="fieldcontain ${hasErrors(bean: partnerContractInstance, field: 'isValidPartnerMember', 'error')} ">
	<label for="isValidPartnerMember">
		<g:message code="partnerContract.isValidPartnerMember.label" default="Is Valid Partner Member" />
		
	</label>
	<g:checkBox name="isValidPartnerMember" value="${partnerContractInstance?.isValidPartnerMember}" />

</div>

<div class="fieldcontain ${hasErrors(bean: partnerContractInstance, field: 'membershipNo', 'error')} required">
	<label for="membershipNo">
		<g:message code="partnerContract.membershipNo.label" default="Membership No" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="membershipNo" required="" value="${partnerContractInstance?.membershipNo}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: partnerContractInstance, field: 'parent', 'error')} required">
	<label for="parent">
		<g:message code="partnerContract.parent.label" default="Parent" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="parent" name="parent.id" from="${cland.membership.Parent.list()}" optionKey="id" required="" value="${partnerContractInstance?.parent?.id}" class="many-to-one"/>

</div>

<div class="fieldcontain ${hasErrors(bean: partnerContractInstance, field: 'partner', 'error')} required">
	<label for="partner">
		<g:message code="partnerContract.partner.label" default="Partner" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="partner" name="partner.id" from="${cland.membership.Partner.list()}" optionKey="id" required="" value="${partnerContractInstance?.partner?.id}" class="many-to-one"/>

</div>

