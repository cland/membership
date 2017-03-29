<%@ page import="cland.membership.Partner" %>



<div class="fieldcontain ${hasErrors(bean: partnerInstance, field: 'partnerCode', 'error')} required">
	<label for="partnerCode">
		<g:message code="partner.partnerCode.label" default="Partner Code" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="partnerCode" required="" value="${partnerInstance?.partnerCode}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: partnerInstance, field: 'lastUpdatedBy', 'error')} required">
	<label for="lastUpdatedBy">
		<g:message code="partner.lastUpdatedBy.label" default="Last Updated By" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="lastUpdatedBy" type="number" value="${partnerInstance.lastUpdatedBy}" required=""/>

</div>

<div class="fieldcontain ${hasErrors(bean: partnerInstance, field: 'createdBy', 'error')} required">
	<label for="createdBy">
		<g:message code="partner.createdBy.label" default="Created By" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="createdBy" type="number" value="${partnerInstance.createdBy}" required=""/>

</div>

<div class="fieldcontain ${hasErrors(bean: partnerInstance, field: 'history', 'error')} ">
	<label for="history">
		<g:message code="partner.history.label" default="History" />
		
	</label>
	<g:textField name="history" readonly="readonly" value="${partnerInstance?.history}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: partnerInstance, field: 'comments', 'error')} ">
	<label for="comments">
		<g:message code="partner.comments.label" default="Comments" />
		
	</label>
	<g:textField name="comments" value="${partnerInstance?.comments}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: partnerInstance, field: 'partnerIndustry', 'error')} ">
	<label for="partnerIndustry">
		<g:message code="partner.partnerIndustry.label" default="Partner Industry" />
		
	</label>
	<g:select id="partnerIndustry" name="partnerIndustry.id" from="${cland.membership.lookup.Keywords.list()}" optionKey="id" value="${partnerInstance?.partnerIndustry?.id}" class="many-to-one" noSelection="['null': '']"/>

</div>

<div class="fieldcontain ${hasErrors(bean: partnerInstance, field: 'contactNo', 'error')} required">
	<label for="contactNo">
		<g:message code="partner.contactNo.label" default="Contact No" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="contactNo" required="" value="${partnerInstance?.contactNo}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: partnerInstance, field: 'name', 'error')} required">
	<label for="name">
		<g:message code="partner.name.label" default="Name" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="name" required="" value="${partnerInstance?.name}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: partnerInstance, field: 'rate', 'error')} required">
	<label for="rate">
		<g:message code="partner.rate.label" default="Rate" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="rate" value="${fieldValue(bean: partnerInstance, field: 'rate')}" required=""/>

</div>

