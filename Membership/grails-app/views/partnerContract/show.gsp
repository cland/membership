
<%@ page import="cland.membership.PartnerContract" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'partnerContract.label', default: 'PartnerContract')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-partnerContract" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav navpage" role="navigation">
			<ul>
				<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				
			</ul>
		</div>
		<div id="show-partnerContract" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list partnerContract">
			
				<g:if test="${partnerContractInstance?.lastUpdatedBy}">
				<li class="fieldcontain">
					<span id="lastUpdatedBy-label" class="property-label"><g:message code="partnerContract.lastUpdatedBy.label" default="Last Updated By" /></span>
					
						<span class="property-value" aria-labelledby="lastUpdatedBy-label"><g:fieldValue bean="${partnerContractInstance}" field="lastUpdatedBy"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${partnerContractInstance?.createdBy}">
				<li class="fieldcontain">
					<span id="createdBy-label" class="property-label"><g:message code="partnerContract.createdBy.label" default="Created By" /></span>
					
						<span class="property-value" aria-labelledby="createdBy-label"><g:fieldValue bean="${partnerContractInstance}" field="createdBy"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${partnerContractInstance?.history}">
				<li class="fieldcontain">
					<span id="history-label" class="property-label"><g:message code="partnerContract.history.label" default="History" /></span>
					
						<span class="property-value" aria-labelledby="history-label"><g:fieldValue bean="${partnerContractInstance}" field="history"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${partnerContractInstance?.comments}">
				<li class="fieldcontain">
					<span id="comments-label" class="property-label"><g:message code="partnerContract.comments.label" default="Comments" /></span>
					
						<span class="property-value" aria-labelledby="comments-label"><g:fieldValue bean="${partnerContractInstance}" field="comments"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${partnerContractInstance?.contractNo}">
				<li class="fieldcontain">
					<span id="contractNo-label" class="property-label"><g:message code="partnerContract.contractNo.label" default="Contract No" /></span>
					
						<span class="property-value" aria-labelledby="contractNo-label"><g:fieldValue bean="${partnerContractInstance}" field="contractNo"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${partnerContractInstance?.dateCreated}">
				<li class="fieldcontain">
					<span id="dateCreated-label" class="property-label"><g:message code="partnerContract.dateCreated.label" default="Date Created" /></span>
					
						<span class="property-value" aria-labelledby="dateCreated-label"><g:formatDate date="${partnerContractInstance?.dateCreated}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${partnerContractInstance?.dateRegistered}">
				<li class="fieldcontain">
					<span id="dateRegistered-label" class="property-label"><g:message code="partnerContract.dateRegistered.label" default="Date Registered" /></span>
					
						<span class="property-value" aria-labelledby="dateRegistered-label"><g:formatDate date="${partnerContractInstance?.dateRegistered}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${partnerContractInstance?.isUserVerified}">
				<li class="fieldcontain">
					<span id="isUserVerified-label" class="property-label"><g:message code="partnerContract.isUserVerified.label" default="Is User Verified" /></span>
					
						<span class="property-value" aria-labelledby="isUserVerified-label"><g:formatBoolean boolean="${partnerContractInstance?.isUserVerified}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${partnerContractInstance?.isValidPartnerMember}">
				<li class="fieldcontain">
					<span id="isValidPartnerMember-label" class="property-label"><g:message code="partnerContract.isValidPartnerMember.label" default="Is Valid Partner Member" /></span>
					
						<span class="property-value" aria-labelledby="isValidPartnerMember-label"><g:formatBoolean boolean="${partnerContractInstance?.isValidPartnerMember}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${partnerContractInstance?.lastUpdated}">
				<li class="fieldcontain">
					<span id="lastUpdated-label" class="property-label"><g:message code="partnerContract.lastUpdated.label" default="Last Updated" /></span>
					
						<span class="property-value" aria-labelledby="lastUpdated-label"><g:formatDate date="${partnerContractInstance?.lastUpdated}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${partnerContractInstance?.membershipNo}">
				<li class="fieldcontain">
					<span id="membershipNo-label" class="property-label"><g:message code="partnerContract.membershipNo.label" default="Membership No" /></span>
					
						<span class="property-value" aria-labelledby="membershipNo-label"><g:fieldValue bean="${partnerContractInstance}" field="membershipNo"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${partnerContractInstance?.parent}">
				<li class="fieldcontain">
					<span id="parent-label" class="property-label"><g:message code="partnerContract.parent.label" default="Parent" /></span>
					
						<span class="property-value" aria-labelledby="parent-label"><g:link controller="parent" action="show" id="${partnerContractInstance?.parent?.id}">${partnerContractInstance?.parent?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				<g:if test="${partnerContractInstance?.partner}">
				<li class="fieldcontain">
					<span id="partner-label" class="property-label"><g:message code="partnerContract.partner.label" default="Partner" /></span>
					
						<span class="property-value" aria-labelledby="partner-label"><g:link controller="partner" action="show" id="${partnerContractInstance?.partner?.id}">${partnerContractInstance?.partner?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
			</ol>
			<g:form url="[resource:partnerContractInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${partnerContractInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
