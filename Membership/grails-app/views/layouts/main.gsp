<%@ page import="cland.membership.SystemRoles" %>
<g:set var="cbcApiService" bean="cbcApiService"/>
<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title><g:layoutTitle default="Membership"/></title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="shortcut icon" href="${assetPath(src: 'favicon.ico')}" type="image/x-icon">
		<link rel="apple-touch-icon" href="${assetPath(src: 'apple-touch-icon.png')}">
		<link rel="apple-touch-icon" sizes="114x114" href="${assetPath(src: 'apple-touch-icon-retina.png')}">
  		<asset:stylesheet src="application.css"/>
		<asset:javascript src="application.js"/>
		<g:layoutHead/>
		<link rel="apple-touch-icon" sizes="57x57" href="${assetPath(src: 'fav/apple-icon-57x57.png')}">
		<link rel="apple-touch-icon" sizes="60x60" href="${assetPath(src: 'fav/apple-icon-60x60.png')}">
		<link rel="apple-touch-icon" sizes="72x72" href="${assetPath(src: 'fav/apple-icon-72x72.png')}">
		<link rel="apple-touch-icon" sizes="76x76" href="${assetPath(src: 'fav/apple-icon-76x76.png')}">
		<link rel="apple-touch-icon" sizes="114x114" href="${assetPath(src: 'fav/apple-icon-114x114.png')}">
		<link rel="apple-touch-icon" sizes="120x120" href="${assetPath(src: 'fav/apple-icon-120x120.png')}">
		<link rel="apple-touch-icon" sizes="144x144" href="${assetPath(src: 'fav/apple-icon-144x144.png')}">
		<link rel="apple-touch-icon" sizes="152x152" href="${assetPath(src: 'fav/apple-icon-152x152.png')}">
		<link rel="apple-touch-icon" sizes="180x180" href="${assetPath(src: 'fav/apple-icon-180x180.png')}">
		<link rel="icon" type="image/png" sizes="192x192"  href="${assetPath(src: 'fav/android-icon-192x192.png')}">
		<link rel="icon" type="image/png" sizes="32x32" href="${assetPath(src: 'fav/favicon-32x32.png')}">
		<link rel="icon" type="image/png" sizes="96x96" href="${assetPath(src: 'fav/favicon-96x96.png')}">
		<link rel="icon" type="image/png" sizes="16x16" href="${assetPath(src: 'fav/favicon-16x16.png')}">
		<link rel="manifest" href="${assetPath(src: 'fav/manifest.json')}">
		<meta name="msapplication-TileColor" content="#ffffff">
		<meta name="msapplication-TileImage" content="${assetPath(src: 'fav/ms-icon-144x144.png')}">
		<meta name="theme-color" content="#ffffff">
		
		
	</head>
	<body>
		<div id="grailsLogo" role="banner">
			<a href="${request.contextPath}"><asset:image src="logo.png" alt="Membership System"/></a>
			<div class="float-right">
			
			<div id="current-user"> <label><span class="r-arrow"></span> </label>
				<sec:ifLoggedIn>
					<span style="color:#000;">Logged in as:</span> <sec:loggedInUserInfo field="username" />					
				</sec:ifLoggedIn> 
				<sec:ifNotLoggedIn>Anonymous</sec:ifNotLoggedIn>
				<br>
				<sec:ifAnyGranted roles="${SystemRoles.ROLE_ADMIN },${SystemRoles.ROLE_DEVELOPER },${SystemRoles.ROLE_MANAGER },${SystemRoles.ROLE_ASSISTANT }">
					<label><span class="r-arrow"></span></label>
					<span style="color:#000;">Location: </span>
					<g:set var="primaryOffice" value="${cbcApiService?.getUserPrimaryOffice()}"/>
					<g:link controller="office" action="show" id="${primaryOffice?.id}" >${primaryOffice }</g:link>
				</sec:ifAnyGranted>
			</div>
		</div>	
		</div>
		<g:render template="/layouts/navbar"></g:render>
		<g:layoutBody/>
		<div class="footer" role="contentinfo"><g:render template="/layouts/footer"></g:render></div>
		<div id="spinner" class="spinner" style="display:none;"><g:message code="spinner.alt" default="Loading&hellip;"/></div>
	</body>
</html>
