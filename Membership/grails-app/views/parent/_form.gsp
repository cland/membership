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


