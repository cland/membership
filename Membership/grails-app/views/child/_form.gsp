<%@ page import="cland.membership.Child" %>
<g:set var="isEditMode" value="${mode?.equals("edit") }"/>
<fieldset><legend></legend>
	<div class="table">
		<div class="row">
			<div class="cell"></div>
			<div class="cell">				
				<attachments:each bean="${childInstance?.person}">
					<img src="/wiggly/attachmentable/show/${attachment?.id }"/><br/>		
					<g:if test="${isEditMode }">			    
					    <attachments:deleteLink
					                         attachment="${attachment}"
					                         label="${'[X]'}"
					                         returnPageURI="${createLink(action: 'actionName', id: childInstance?.id)}"/>
					    <attachments:downloadLink attachment="${attachment}"/>			                   
					    ${attachment.niceLength}
				   	</g:if>    
				</attachments:each>
			</div>
		</div>
	</div>
</fieldset>

<fieldset><legend></legend>
	<div class="table">
		<div class="row">
			<div class="cell"></div>
			<div class="cell"></div>
		</div>
	</div>
</fieldset>
