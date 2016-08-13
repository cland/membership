<%@ page import="cland.membership.Visit" %>



<div class="fieldcontain ${hasErrors(bean: visitInstance, field: 'lastUpdatedBy', 'error')} required">
	<label for="lastUpdatedBy">
		<g:message code="visit.lastUpdatedBy.label" default="Last Updated By" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="lastUpdatedBy" type="number" value="${visitInstance.lastUpdatedBy}" required=""/>

</div>

<div class="fieldcontain ${hasErrors(bean: visitInstance, field: 'createdBy', 'error')} required">
	<label for="createdBy">
		<g:message code="visit.createdBy.label" default="Created By" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="createdBy" type="number" value="${visitInstance.createdBy}" required=""/>

</div>

<div class="fieldcontain ${hasErrors(bean: visitInstance, field: 'contactNo', 'error')} ">
	<label for="contactNo">
		<g:message code="visit.contactNo.label" default="Contact No" />
		
	</label>
	<g:textField name="contactNo" value="${visitInstance?.contactNo}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: visitInstance, field: 'endtime', 'error')} ">
	<label for="endtime">
		<g:message code="visit.endtime.label" default="Endtime" />
		
	</label>
	<g:datePicker name="endtime" precision="day"  value="${visitInstance?.endtime}" default="none" noSelection="['': '']" />

</div>

<div class="fieldcontain ${hasErrors(bean: visitInstance, field: 'photoKey', 'error')} ">
	<label for="photoKey">
		<g:message code="visit.photoKey.label" default="Photo Key" />
		
	</label>
	<g:textField name="photoKey" value="${visitInstance?.photoKey}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: visitInstance, field: 'selectedHours', 'error')} ">
	<label for="selectedHours">
		<g:message code="visit.selectedHours.label" default="Selected Hours" />
		
	</label>
	<g:field name="selectedHours" type="number" value="${visitInstance.selectedHours}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: visitInstance, field: 'office', 'error')} ">
	<label for="office">
		<g:message code="visit.office.label" default="Office" />
		
	</label>
	<g:select id="office" name="office.id" from="${cland.membership.Office.list()}" optionKey="id" value="${visitInstance?.office?.id}" class="many-to-one" noSelection="['null': '']"/>

</div>

<div class="fieldcontain ${hasErrors(bean: visitInstance, field: 'promotion', 'error')} ">
	<label for="promotion">
		<g:message code="visit.promotion.label" default="Promotion" />
		
	</label>
	<g:select id="promotion" name="promotion.id" from="${cland.membership.lookup.Keywords.list()}" optionKey="id" value="${visitInstance?.promotion?.id}" class="many-to-one" noSelection="['null': '']"/>

</div>


<div class="fieldcontain ${hasErrors(bean: visitInstance, field: 'child', 'error')} required">
	<label for="child">
		<g:message code="visit.child.label" default="Child" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="child" name="child.id" from="${cland.membership.Child.list()}" optionKey="id" required="" value="${visitInstance?.child?.id}" class="many-to-one"/>

</div>

<div class="fieldcontain ${hasErrors(bean: visitInstance, field: 'startday', 'error')} required">
	<label for="startday">
		<g:message code="visit.startday.label" default="Startday" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="startday" type="number" value="${visitInstance.startday}" required=""/>

</div>

<div class="fieldcontain ${hasErrors(bean: visitInstance, field: 'startmonth', 'error')} required">
	<label for="startmonth">
		<g:message code="visit.startmonth.label" default="Startmonth" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="startmonth" type="number" value="${visitInstance.startmonth}" required=""/>

</div>

<div class="fieldcontain ${hasErrors(bean: visitInstance, field: 'starttime', 'error')} required">
	<label for="starttime">
		<g:message code="visit.starttime.label" default="Starttime" />
		<span class="required-indicator">*</span>
	</label>
	<g:datePicker name="starttime" precision="day"  value="${visitInstance?.starttime}"  />

</div>

<div class="fieldcontain ${hasErrors(bean: visitInstance, field: 'startweek', 'error')} required">
	<label for="startweek">
		<g:message code="visit.startweek.label" default="Startweek" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="startweek" type="number" value="${visitInstance.startweek}" required=""/>

</div>

<div class="fieldcontain ${hasErrors(bean: visitInstance, field: 'startyear', 'error')} required">
	<label for="startyear">
		<g:message code="visit.startyear.label" default="Startyear" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="startyear" type="number" value="${visitInstance.startyear}" required=""/>

</div>

<div class="fieldcontain ${hasErrors(bean: visitInstance, field: 'status', 'error')} required">
	<label for="status">
		<g:message code="visit.status.label" default="Status" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="status" required="" value="${visitInstance?.status}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: visitInstance, field: 'timerCheckPoint', 'error')} required">
	<label for="timerCheckPoint">
		<g:message code="visit.timerCheckPoint.label" default="Timer Check Point" />
		<span class="required-indicator">*</span>
	</label>
	<g:datePicker name="timerCheckPoint" precision="day"  value="${visitInstance?.timerCheckPoint}"  />

</div>

<div class="fieldcontain ${hasErrors(bean: visitInstance, field: 'totalminutes', 'error')} required">
	<label for="totalminutes">
		<g:message code="visit.totalminutes.label" default="Totalminutes" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="totalminutes" type="number" value="${visitInstance.totalminutes}" required=""/>

</div>

<div class="fieldcontain ${hasErrors(bean: visitInstance, field: 'visitNo', 'error')} required">
	<label for="visitNo">
		<g:message code="visit.visitNo.label" default="Visit No" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="visitNo" required="" value="${visitInstance?.visitNo}"/>

</div>

