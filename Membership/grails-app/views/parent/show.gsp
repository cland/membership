
<%@ page import="cland.membership.Parent" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'parent.label', default: 'Parent')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-parent" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-parent" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list parent">
			
				<g:if test="${parentInstance?.children}">
				<li class="fieldcontain">
					<span id="children-label" class="property-label"><g:message code="parent.children.label" default="Children" /></span>
					
						<g:each in="${parentInstance.children}" var="c">
						<span class="property-value" aria-labelledby="children-label"><g:link controller="child" action="show" id="${c.id}">${c?.encodeAsHTML()}</g:link></span>
						</g:each>
					
				</li>
				</g:if>
			
				<g:if test="${parentInstance?.date}">
				<li class="fieldcontain">
					<span id="date-label" class="property-label"><g:message code="parent.date.label" default="Date" /></span>
					
						<span class="property-value" aria-labelledby="date-label"><g:formatDate date="${parentInstance?.date}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${parentInstance?.person1}">
				<li class="fieldcontain">
					<span id="person1-label" class="property-label"><g:message code="parent.person1.label" default="Person1" /></span>
					
						<span class="property-value" aria-labelledby="person1-label"><g:link controller="person" action="show" id="${parentInstance?.person1?.id}">${parentInstance?.person1?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				<g:if test="${parentInstance?.person2}">
				<li class="fieldcontain">
					<span id="person2-label" class="property-label"><g:message code="parent.person2.label" default="Person2" /></span>
					
						<span class="property-value" aria-labelledby="person2-label"><g:link controller="person" action="show" id="${parentInstance?.person2?.id}">${parentInstance?.person2?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
			</ol>
			<g:form url="[resource:parentInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${parentInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
