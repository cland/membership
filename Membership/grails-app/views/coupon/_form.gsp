<%@ page import="cland.membership.Coupon" %>



<div class="fieldcontain ${hasErrors(bean: couponInstance, field: 'lastUpdatedBy', 'error')} required">
	<label for="lastUpdatedBy">
		<g:message code="coupon.lastUpdatedBy.label" default="Last Updated By" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="lastUpdatedBy" type="number" value="${couponInstance.lastUpdatedBy}" required=""/>

</div>

<div class="fieldcontain ${hasErrors(bean: couponInstance, field: 'createdBy', 'error')} required">
	<label for="createdBy">
		<g:message code="coupon.createdBy.label" default="Created By" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="createdBy" type="number" value="${couponInstance.createdBy}" required=""/>

</div>

<div class="fieldcontain ${hasErrors(bean: couponInstance, field: 'expiryDate', 'error')} required">
	<label for="expiryDate">
		<g:message code="coupon.expiryDate.label" default="Expiry Date" />
		<span class="required-indicator">*</span>
	</label>
	<g:datePicker name="expiryDate" precision="day"  value="${couponInstance?.expiryDate}"  />

</div>

<div class="fieldcontain ${hasErrors(bean: couponInstance, field: 'maxvisits', 'error')} required">
	<label for="maxvisits">
		<g:message code="coupon.maxvisits.label" default="Maxvisits" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="maxvisits" type="number" value="${couponInstance.maxvisits}" required=""/>

</div>

<div class="fieldcontain ${hasErrors(bean: couponInstance, field: 'parent', 'error')} required">
	<label for="parent">
		<g:message code="coupon.parent.label" default="Parent" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="parent" name="parent.id" from="${cland.membership.Parent.list()}" optionKey="id" required="" value="${couponInstance?.parent?.id}" class="many-to-one"/>

</div>

<div class="fieldcontain ${hasErrors(bean: couponInstance, field: 'refNo', 'error')} required">
	<label for="refNo">
		<g:message code="coupon.refNo.label" default="Ref No" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="refNo" required="" value="${couponInstance?.refNo}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: couponInstance, field: 'startDate', 'error')} required">
	<label for="startDate">
		<g:message code="coupon.startDate.label" default="Start Date" />
		<span class="required-indicator">*</span>
	</label>
	<g:datePicker name="startDate" precision="day"  value="${couponInstance?.startDate}"  />

</div>

<div class="fieldcontain ${hasErrors(bean: couponInstance, field: 'visits', 'error')} ">
	<label for="visits">
		<g:message code="coupon.visits.label" default="Visits" />
		
	</label>
	<g:select name="visits" from="${cland.membership.Visit.list()}" multiple="multiple" optionKey="id" size="5" value="${couponInstance?.visits*.id}" class="many-to-many"/>

</div>

