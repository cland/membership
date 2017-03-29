
<%@ page import="cland.membership.Partner" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'partner.label', default: 'Partner')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-partner" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav navpage" role="navigation">
			<ul>
				<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-partner" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list partner">
			
				<g:if test="${partnerInstance?.partnerCode}">
				<li class="fieldcontain">
					<span id="partnerCode-label" class="property-label"><g:message code="partner.partnerCode.label" default="Partner Code" /></span>
					
						<span class="property-value" aria-labelledby="partnerCode-label"><g:fieldValue bean="${partnerInstance}" field="partnerCode"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${partnerInstance?.lastUpdatedBy}">
				<li class="fieldcontain">
					<span id="lastUpdatedBy-label" class="property-label"><g:message code="partner.lastUpdatedBy.label" default="Last Updated By" /></span>
					
						<span class="property-value" aria-labelledby="lastUpdatedBy-label"><g:fieldValue bean="${partnerInstance}" field="lastUpdatedBy"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${partnerInstance?.createdBy}">
				<li class="fieldcontain">
					<span id="createdBy-label" class="property-label"><g:message code="partner.createdBy.label" default="Created By" /></span>
					
						<span class="property-value" aria-labelledby="createdBy-label"><g:fieldValue bean="${partnerInstance}" field="createdBy"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${partnerInstance?.history}">
				<li class="fieldcontain">
					<span id="history-label" class="property-label"><g:message code="partner.history.label" default="History" /></span>
					
						<span class="property-value" aria-labelledby="history-label"><g:fieldValue bean="${partnerInstance}" field="history"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${partnerInstance?.comments}">
				<li class="fieldcontain">
					<span id="comments-label" class="property-label"><g:message code="partner.comments.label" default="Comments" /></span>
					
						<span class="property-value" aria-labelledby="comments-label"><g:fieldValue bean="${partnerInstance}" field="comments"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${partnerInstance?.partnerIndustry}">
				<li class="fieldcontain">
					<span id="partnerIndustry-label" class="property-label"><g:message code="partner.partnerIndustry.label" default="Partner Industry" /></span>
					
						<span class="property-value" aria-labelledby="partnerIndustry-label"><g:link controller="keywords" action="show" id="${partnerInstance?.partnerIndustry?.id}">${partnerInstance?.partnerIndustry?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				<g:if test="${partnerInstance?.contactNo}">
				<li class="fieldcontain">
					<span id="contactNo-label" class="property-label"><g:message code="partner.contactNo.label" default="Contact No" /></span>
					
						<span class="property-value" aria-labelledby="contactNo-label"><g:fieldValue bean="${partnerInstance}" field="contactNo"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${partnerInstance?.dateCreated}">
				<li class="fieldcontain">
					<span id="dateCreated-label" class="property-label"><g:message code="partner.dateCreated.label" default="Date Created" /></span>
					
						<span class="property-value" aria-labelledby="dateCreated-label"><g:formatDate date="${partnerInstance?.dateCreated}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${partnerInstance?.lastUpdated}">
				<li class="fieldcontain">
					<span id="lastUpdated-label" class="property-label"><g:message code="partner.lastUpdated.label" default="Last Updated" /></span>
					
						<span class="property-value" aria-labelledby="lastUpdated-label"><g:formatDate date="${partnerInstance?.lastUpdated}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${partnerInstance?.name}">
				<li class="fieldcontain">
					<span id="name-label" class="property-label"><g:message code="partner.name.label" default="Name" /></span>
					
						<span class="property-value" aria-labelledby="name-label"><g:fieldValue bean="${partnerInstance}" field="name"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${partnerInstance?.rate}">
				<li class="fieldcontain">
					<span id="rate-label" class="property-label"><g:message code="partner.rate.label" default="Rate" /></span>
					
						<span class="property-value" aria-labelledby="rate-label"><g:fieldValue bean="${partnerInstance}" field="rate"/></span>
					
				</li>
				</g:if>
			
			</ol>
			<g:form url="[resource:partnerInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${partnerInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
