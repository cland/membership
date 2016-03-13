<%@ page import="cland.membership.Parent" %>



<div class="fieldcontain ${hasErrors(bean: parentInstance, field: 'children', 'error')} ">
	<label for="children">
		<g:message code="parent.children.label" default="Children" />
		
	</label>
	
<ul class="one-to-many">
<g:each in="${parentInstance?.children?}" var="c">
    <li><g:link controller="child" action="show" id="${c.id}">${c?.encodeAsHTML()}</g:link></li>
</g:each>
<li class="add">
<g:link controller="child" action="create" params="['parent.id': parentInstance?.id]">${message(code: 'default.add.label', args: [message(code: 'child.label', default: 'Child')])}</g:link>
</li>
</ul>
</div>
<div class="fieldcontain ${hasErrors(bean: parentInstance, field: 'clientType', 'error')} ">
			<label for="gender">
				<g:message code="parent.clientType.label" default="Client Type" />
				
			</label>
			<g:select name="clientType" from="${parentInstance.constraints.clientType.inList}" value="${personInstance?.clientType}" valueMessagePrefix="clientType" noSelection="['': '']"/>
		
		</div>
		<div class="fieldcontain ${hasErrors(bean: parentInstance, field: 'comments', 'error')} ">
			<label for="title">
				<g:message code="parent.comments.label" default="Comments" />
				
			</label>
			<g:textField name="comments" value="${parentInstance?.comments}"/>
		
		</div>
		<div class="fieldcontain ${hasErrors(bean: parentInstance, field: 'membershipNo', 'error')} ">
			<label for="membershipNo">
				<g:message code="parent.memberhipNo.label" default="membership" />
				
			</label>
			<g:textField name="membershipNo" value="${parentInstance?.membershipNo}"/>
		
		</div>


