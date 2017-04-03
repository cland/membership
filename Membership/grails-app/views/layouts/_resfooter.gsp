<%@ page import="cland.membership.SystemRoles" %>
<div class="row">
        <div class="col-sm-12">
            <footer>            
                   
<a href="${request.contextPath}/">Home</a> |
<sec:ifNotLoggedIn>
<g:link controller="login" action="auth" >Login</g:link> |
</sec:ifNotLoggedIn>
<sec:ifAnyGranted roles="${SystemRoles.ROLE_DEVELOPER }">
	<g:link url="${resource(dir:'admin', file:'technical')}">Technical</g:link>  |
</sec:ifAnyGranted>
<sec:ifLoggedIn>

<sec:ifAnyGranted roles="${SystemRoles.ROLE_ADMIN },${SystemRoles.ROLE_DEVELOPER },${SystemRoles.ROLE_MANAGER }">
	<g:link url="${resource(dir:'office', file:'index')}">Offices</g:link>  |
	<g:link url="${resource(dir:'person', file:'index')}">People</g:link>  |
	<g:link url="${resource(dir:'visit', file:'index')}">All Visits</g:link>  |
	<g:link url="${resource(dir:'/', file:'selfregister')}">Self Register</g:link>  |
	<g:link url="${resource(dir:'partner', file:'index')}">Partners</g:link>  |
</sec:ifAnyGranted>



<g:link controller="logout" action="index" >Logout</g:link>
</sec:ifLoggedIn>
	<br/>
	<div class="copyright">
	<sec:ifAnyGranted roles="${SystemRoles.ROLE_ADMIN },${SystemRoles.ROLE_DEVELOPER },${SystemRoles.ROLE_MANAGER },${SystemRoles.ROLE_ASSISTANT }">
		<g:meta name="app.name"/> version: <g:meta name="app.version"/> | 
	</sec:ifAnyGranted>
	<g:copyright startYear="2016"> Crafted by: <span><a href="http://www.tagumiinvestments.com/solutions.html" target="_blank" style="color:green;font-weight:bold;">Tagumi Solutions</a></span></g:copyright> | <span id='time'></span>
	</div>
		</footer>
	</div>
</div>