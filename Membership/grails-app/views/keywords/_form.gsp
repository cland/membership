<%@ page import="cland.membership.lookup.Keywords" %>



<div class="fieldcontain ${hasErrors(bean: keywordsInstance, field: 'name', 'error')} required">
	<label for="name">
		<g:message code="keywords.name.label" default="Name" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="name" required="" value="${keywordsInstance?.name}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: keywordsInstance, field: 'category', 'error')} ">
	<label for="category">
		<g:message code="keywords.category.label" default="Category" />
		
	</label>
	<g:textField name="category" value="${keywordsInstance?.category}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: keywordsInstance, field: 'description', 'error')} ">
	<label for="description">
		<g:message code="keywords.description.label" default="Description" />
		
	</label>
	<g:textField name="description" value="${keywordsInstance?.description}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: keywordsInstance, field: 'label', 'error')} ">
	<label for="label">
		<g:message code="keywords.label.label" default="Label" />
		
	</label>
	<g:textField name="label" value="${keywordsInstance?.label}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: keywordsInstance, field: 'lastUpdatedBy', 'error')} required">
	<label for="lastUpdatedBy">
		<g:message code="keywords.lastUpdatedBy.label" default="Last Updated By" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="lastUpdatedBy" type="number" value="${keywordsInstance.lastUpdatedBy}" required=""/>

</div>

<div class="fieldcontain ${hasErrors(bean: keywordsInstance, field: 'createdBy', 'error')} required">
	<label for="createdBy">
		<g:message code="keywords.createdBy.label" default="Created By" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="createdBy" type="number" value="${keywordsInstance.createdBy}" required=""/>

</div>

<div class="fieldcontain ${hasErrors(bean: keywordsInstance, field: 'keyword', 'error')} required">
	<label for="keyword">
		<g:message code="keywords.keyword.label" default="Keyword" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="keyword" name="keyword.id" from="${cland.membership.lookup.Keywords.list()}" optionKey="id" required="" value="${keywordsInstance?.keyword?.id}" class="many-to-one"/>

</div>

<div class="fieldcontain ${hasErrors(bean: keywordsInstance, field: 'values', 'error')} ">
	<label for="values">
		<g:message code="keywords.values.label" default="Values" />
		
	</label>
	
<ul class="one-to-many">
<g:each in="${keywordsInstance?.values?}" var="v">
    <li><g:link controller="keywords" action="show" id="${v.id}">${v?.encodeAsHTML()}</g:link></li>
</g:each>
<li class="add">
<g:link controller="keywords" action="create" params="['keywords.id': keywordsInstance?.id]">${message(code: 'default.add.label', args: [message(code: 'keywords.label', default: 'Keywords')])}</g:link>
</li>
</ul>


</div>

