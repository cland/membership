<%@ page import="cland.membership.SystemRoles" %>
<g:set var="cbcApiService" bean="cbcApiService"/>
<g:set var="parent" value="${ cbcApiService.findParentFor(null)}"/>
<div class="nav" role="navigation">
	<ul>
		<sec:ifLoggedIn>
			
			<li><a class="home" href="${request.contextPath}/"><g:message code="default.home.label"/></a></li>
			<sec:ifNotGranted roles="${SystemRoles.ROLE_ADMIN },${SystemRoles.ROLE_DEVELOPER },${SystemRoles.ROLE_MANAGER },${SystemRoles.ROLE_ASSISTANT }">
				<li><a class="list" href="${request.contextPath}/visitBooking/">My Bookings</a></li>
				<li><a class="list" href="${request.contextPath}/parent/show/${parent?.id}">My Profile</a></li>
			</sec:ifNotGranted>
			<sec:ifAnyGranted roles="${SystemRoles.ROLE_ADMIN },${SystemRoles.ROLE_DEVELOPER },${SystemRoles.ROLE_MANAGER },${SystemRoles.ROLE_ASSISTANT }">
				<li><a class="list" href="${request.contextPath}/parent/">Clients</a></li>
				<li><a class="list" href="${request.contextPath}/visitBooking/">Online Bookings</a></li>
				<li><a class="list" href="${request.contextPath}/coupon/">Coupons</a></li>
			</sec:ifAnyGranted>
			<sec:ifAnyGranted roles="${SystemRoles.ROLE_DEVELOPER }">
				<li><a class="list" href="${request.contextPath}/booking/">Bookings</a></li>
			</sec:ifAnyGranted>
			<sec:ifAnyGranted roles="${SystemRoles.ROLE_ADMIN },${SystemRoles.ROLE_DEVELOPER },${SystemRoles.ROLE_MANAGER }">
				<li><a class="list" href="${request.contextPath}/reports/">Reports</a></li>				
			</sec:ifAnyGranted>
			<sec:ifAnyGranted roles="${SystemRoles.ROLE_ADMIN },${SystemRoles.ROLE_DEVELOPER }">	
				<li><a class="list" href="${request.contextPath}/settings/edit/1">Settings</a></li>	
			</sec:ifAnyGranted>
			<li style="float:right;"><g:link controller="logout" action="index" >Logout</g:link></li>
		</sec:ifLoggedIn>
		
	</ul>
</div>