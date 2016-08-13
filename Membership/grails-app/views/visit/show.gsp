<%@ page import="cland.membership.SystemRoles" %>
<%@ page import="cland.membership.Visit" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'visit.label', default: 'Visit')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-visit" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav navpage" role="navigation">
			<ul>
				<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>				
			</ul>
		</div>
		<div id="show-visit" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list visit">
			<g:if test="${visitInstance?.visitNo}">
				<li class="fieldcontain">
					<span id="visitNo-label" class="property-label"><g:message code="visit.visitNo.label" default="Visit No" /></span>
					
						<span class="property-value" aria-labelledby="visitNo-label"><g:fieldValue bean="${visitInstance}" field="visitNo"/></span>
					
				</li>
				</g:if>
				<g:if test="${visitInstance?.status}">
				<li class="fieldcontain">
					<span id="status-label" class="property-label"><g:message code="visit.status.label" default="Status" /></span>
					
						<span class="property-value" aria-labelledby="status-label"><g:fieldValue bean="${visitInstance}" field="status"/></span>
					
				</li>
				</g:if>
			<g:if test="${visitInstance?.child}">
				<li class="fieldcontain">
					<span id="child-label" class="property-label"><g:message code="visit.child.label" default="Child" /></span>
					
						<span class="property-value" aria-labelledby="child-label"><g:link controller="child" action="show" id="${visitInstance?.child?.id}">${visitInstance?.child?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
				<g:if test="${visitInstance?.starttime}">
				<li class="fieldcontain">
					<span id="starttime-label" class="property-label"><g:message code="visit.starttime.label" default="Starttime" /></span>
					
						<span class="property-value" aria-labelledby="starttime-label"><g:formatDate date="${visitInstance?.starttime}" /></span>
					
				</li>
				</g:if>
				<g:if test="${visitInstance?.endtime}">
				<li class="fieldcontain">
					<span id="endtime-label" class="property-label"><g:message code="visit.endtime.label" default="Endtime" /></span>
					
						<span class="property-value" aria-labelledby="endtime-label"><g:formatDate date="${visitInstance?.endtime}" /></span>
					
				</li>
				</g:if>
				<g:if test="${visitInstance?.visitHours}">
				<li class="fieldcontain">
					<span id="selectedHours-label" class="property-label"><g:message code="visit.visitHours.label" default="Visit Hours" /></span>
					
						<span class="property-value" aria-labelledby="visitHours-label"><g:fieldValue bean="${visitInstance}" field="visitHours"/></span>
					
				</li>
				</g:if>
				<g:if test="${visitInstance?.createdByName}">
				<li class="fieldcontain">
					<span id="createdBy-label" class="property-label"><g:message code="visit.createdBy.label" default="Created By" /></span>
					
						<span class="property-value" aria-labelledby="createdBy-label"><g:fieldValue bean="${visitInstance}" field="createdByName"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${visitInstance?.contactNo}">
				<li class="fieldcontain">
					<span id="contactNo-label" class="property-label"><g:message code="visit.contactNo.label" default="Contact No" /></span>
					
						<span class="property-value" aria-labelledby="contactNo-label"><g:fieldValue bean="${visitInstance}" field="contactNo"/></span>
					
				</li>
				</g:if>
			
			<g:if test="${visitInstance?.office}">
				<li class="fieldcontain">
					<span id="office-label" class="property-label"><g:message code="visit.office.label" default="Office" /></span>
					
						<span class="property-value" aria-labelledby="office-label"><g:link controller="office" action="show" id="${visitInstance?.office?.id}">${visitInstance?.office?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
				
				<g:if test="${visitInstance?.photoKey}">
				<li class="fieldcontain">
					<span id="photoKey-label" class="property-label"><g:message code="visit.photoKey.label" default="Photo Key" /></span>
					
						<span class="property-value" aria-labelledby="photoKey-label"><g:fieldValue bean="${visitInstance}" field="photoKey"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${visitInstance?.selectedHours}">
				<li class="fieldcontain">
					<span id="selectedHours-label" class="property-label"><g:message code="visit.selectedHours.label" default="Selected Hours" /></span>
					
						<span class="property-value" aria-labelledby="selectedHours-label"><g:fieldValue bean="${visitInstance}" field="selectedHours"/></span>
					
				</li>
				</g:if>
			
				
			
				<g:if test="${visitInstance?.promotion}">
				<li class="fieldcontain">
					<span id="promotion-label" class="property-label"><g:message code="visit.promotion.label" default="Promotion" /></span>
					
						<span class="property-value" aria-labelledby="promotion-label"><g:link controller="keywords" action="show" id="${visitInstance?.promotion?.id}">${visitInstance?.promotion?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				
				
			
				<g:if test="${visitInstance?.dateCreated}">
				<li class="fieldcontain">
					<span id="dateCreated-label" class="property-label"><g:message code="visit.dateCreated.label" default="Date Created" /></span>
					
						<span class="property-value" aria-labelledby="dateCreated-label"><g:formatDate date="${visitInstance?.dateCreated}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${visitInstance?.lastUpdatedByName}">
				<li class="fieldcontain">
					<span id="lastUpdated-label" class="property-label"><g:message code="visit.lastUpdated.label" default="Last Updated" /></span>
					
						<span class="property-value" aria-labelledby="lastUpdated-label"><g:formatDate date="${visitInstance?.lastUpdated}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${visitInstance?.startday}">
				<li class="fieldcontain">
					<span id="startday-label" class="property-label"><g:message code="visit.startday.label" default="Startday" /></span>
					
						<span class="property-value" aria-labelledby="startday-label"><g:fieldValue bean="${visitInstance}" field="startday"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${visitInstance?.startmonth}">
				<li class="fieldcontain">
					<span id="startmonth-label" class="property-label"><g:message code="visit.startmonth.label" default="Startmonth" /></span>
					
						<span class="property-value" aria-labelledby="startmonth-label"><g:fieldValue bean="${visitInstance}" field="startmonth"/></span>
					
				</li>
				</g:if>
			
				
			
				<g:if test="${visitInstance?.startweek}">
				<li class="fieldcontain">
					<span id="startweek-label" class="property-label"><g:message code="visit.startweek.label" default="Startweek" /></span>
					
						<span class="property-value" aria-labelledby="startweek-label"><g:fieldValue bean="${visitInstance}" field="startweek"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${visitInstance?.startyear}">
				<li class="fieldcontain">
					<span id="startyear-label" class="property-label"><g:message code="visit.startyear.label" default="Startyear" /></span>
					
						<span class="property-value" aria-labelledby="startyear-label"><g:fieldValue bean="${visitInstance}" field="startyear"/></span>
					
				</li>
				</g:if>
			
				
			
				<g:if test="${visitInstance?.timerCheckPoint}">
				<li class="fieldcontain">
					<span id="timerCheckPoint-label" class="property-label"><g:message code="visit.timerCheckPoint.label" default="Timer Check Point" /></span>
					
						<span class="property-value" aria-labelledby="timerCheckPoint-label"><g:formatDate date="${visitInstance?.timerCheckPoint}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${visitInstance?.totalminutes}">
				<li class="fieldcontain">
					<span id="totalminutes-label" class="property-label"><g:message code="visit.totalminutes.label" default="Totalminutes" /></span>
					
						<span class="property-value" aria-labelledby="totalminutes-label"><g:fieldValue bean="${visitInstance}" field="totalminutes"/></span>
					
				</li>
				</g:if>							
			
			</ol>
			<g:form url="[resource:visitInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
				<sec:ifAnyGranted roles="${SystemRoles.ROLE_DEVELOPER }">
					<g:link class="edit" action="edit" resource="${visitInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</sec:ifAnyGranted>
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
