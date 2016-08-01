
<%@ page import="cland.membership.Coupon" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'coupon.label', default: 'Coupon')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-coupon" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav navpage" role="navigation">
			<ul>
				<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>				
			</ul>
		</div>
		<div id="show-coupon" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list coupon">
			
				<g:if test="${couponInstance?.lastUpdatedBy}">
				<li class="fieldcontain">
					<span id="lastUpdatedBy-label" class="property-label"><g:message code="coupon.lastUpdatedBy.label" default="Last Updated By" /></span>
					
						<span class="property-value" aria-labelledby="lastUpdatedBy-label"><g:fieldValue bean="${couponInstance}" field="lastUpdatedBy"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${couponInstance?.createdBy}">
				<li class="fieldcontain">
					<span id="createdBy-label" class="property-label"><g:message code="coupon.createdBy.label" default="Created By" /></span>
					
						<span class="property-value" aria-labelledby="createdBy-label"><g:fieldValue bean="${couponInstance}" field="createdBy"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${couponInstance?.dateCreated}">
				<li class="fieldcontain">
					<span id="dateCreated-label" class="property-label"><g:message code="coupon.dateCreated.label" default="Date Created" /></span>
					
						<span class="property-value" aria-labelledby="dateCreated-label"><g:formatDate date="${couponInstance?.dateCreated}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${couponInstance?.expiryDate}">
				<li class="fieldcontain">
					<span id="expiryDate-label" class="property-label"><g:message code="coupon.expiryDate.label" default="Expiry Date" /></span>
					
						<span class="property-value" aria-labelledby="expiryDate-label"><g:formatDate date="${couponInstance?.expiryDate}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${couponInstance?.lastUpdated}">
				<li class="fieldcontain">
					<span id="lastUpdated-label" class="property-label"><g:message code="coupon.lastUpdated.label" default="Last Updated" /></span>
					
						<span class="property-value" aria-labelledby="lastUpdated-label"><g:formatDate date="${couponInstance?.lastUpdated}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${couponInstance?.maxvisits}">
				<li class="fieldcontain">
					<span id="maxvisits-label" class="property-label"><g:message code="coupon.maxvisits.label" default="Maxvisits" /></span>
					
						<span class="property-value" aria-labelledby="maxvisits-label"><g:fieldValue bean="${couponInstance}" field="maxvisits"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${couponInstance?.parent}">
				<li class="fieldcontain">
					<span id="parent-label" class="property-label"><g:message code="coupon.parent.label" default="Parent" /></span>
					
						<span class="property-value" aria-labelledby="parent-label"><g:link controller="parent" action="show" id="${couponInstance?.parent?.id}">${couponInstance?.parent?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				<g:if test="${couponInstance?.refNo}">
				<li class="fieldcontain">
					<span id="refNo-label" class="property-label"><g:message code="coupon.refNo.label" default="Ref No" /></span>
					
						<span class="property-value" aria-labelledby="refNo-label"><g:fieldValue bean="${couponInstance}" field="refNo"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${couponInstance?.startDate}">
				<li class="fieldcontain">
					<span id="startDate-label" class="property-label"><g:message code="coupon.startDate.label" default="Start Date" /></span>
					
						<span class="property-value" aria-labelledby="startDate-label"><g:formatDate date="${couponInstance?.startDate}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${couponInstance?.visits}">
				<li class="fieldcontain">
					<span id="visits-label" class="property-label"><g:message code="coupon.visits.label" default="Visits" /></span>
					
						<g:each in="${couponInstance.visits}" var="v">
						<span class="property-value" aria-labelledby="visits-label"><g:link controller="visit" action="show" id="${v.id}">${v?.encodeAsHTML()}</g:link></span>
						</g:each>
					
				</li>
				</g:if>
			
			</ol>
			<g:form url="[resource:couponInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${couponInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
