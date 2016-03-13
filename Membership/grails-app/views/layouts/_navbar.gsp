<%@ page import="cland.membership.SystemRoles" %>
<div class="nav" role="navigation">
	<ul>
		<sec:ifLoggedIn>
			<li><a class="home" href="${request.contextPath}"><g:message code="default.home.label"/></a></li>
			<li><a class="list" href="${request.contextPath}/parent/">Clients</a></li>
			<sec:ifAnyGranted roles="${SystemRoles.ROLE_ADMIN }">
				<li><a class="list" href="${request.contextPath}">Reports</a></li>
				<li><a class="list" href="${request.contextPath}/settings/edit/1">Settings</a></li>	
			</sec:ifAnyGranted>
		</sec:ifLoggedIn>
	</ul>
</div>