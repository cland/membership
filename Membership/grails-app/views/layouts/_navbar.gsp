<%@ page import="cland.membership.SystemRoles" %>
<div class="nav" role="navigation">
	<ul>
		<sec:ifLoggedIn>
			<li><a class="home" href="${request.contextPath}/"><g:message code="default.home.label"/></a></li>
			<li><a class="list" href="${request.contextPath}/parent/">Clients</a></li>
			<li><a class="list" href="${request.contextPath}/booking/">Bookings</a></li>
			<sec:ifAnyGranted roles="${SystemRoles.ROLE_ADMIN },${SystemRoles.ROLE_DEVELOPER }">
				<li><a class="list" href="${request.contextPath}/reports/">Reports</a></li>
				<li><a class="list" href="${request.contextPath}/settings/edit/1">Settings</a></li>	
			</sec:ifAnyGranted>
			<li style="float:right;"><g:link controller="logout" action="index" >Logout</g:link></li>
		</sec:ifLoggedIn>
		
	</ul>
</div>