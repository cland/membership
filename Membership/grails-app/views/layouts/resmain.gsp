<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><g:layoutTitle default="Membership"/></title>
<asset:stylesheet src="application.css"/>  		
<asset:stylesheet src="bootstrap.min.css"/>
<asset:javascript src="application.js"/>
<asset:javascript src="bootstrap.min.js"/>
<style>
	body {text-align:center;}
	.responsive-fieldset {display:table-cell; width: 100%}
</style>
<g:layoutHead/>
<link rel="shortcut icon" href="${assetPath(src: 'favicon.ico')}" type="image/x-icon">

</head>
<body>
<nav id="myNavbar" class="navbar navbar-default navbar-inverse navbar-fixed-top" role="navigation">
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#navbarCollapse">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#">Wiggly Toes IPC</a>
        </div>
        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="navbarCollapse">
            <ul class="nav navbar-nav">
                <li class="active"><a href="#" target="_blank">Home</a></li>
                <li><a href="#" target="_blank">About</a></li>
                <li><a href="#" target="_blank">Contact</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container">
	<g:layoutBody/>
    <hr>
    <g:render template="/layouts/footer"></g:render>
</div>
</body>
</html>