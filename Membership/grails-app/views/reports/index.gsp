<%@ page import="cland.membership.SystemRoles" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title>Reports</title>
		<style type="text/css" media="screen">
			.wait{border:none};
			#status {
				background-color: #eee;
				border: .2em solid #fff;
				margin: 2em 2em 1em;
				padding: 1em;
				width: 12em;
				float: left;
				-moz-box-shadow: 0px 0px 1.25em #ccc;
				-webkit-box-shadow: 0px 0px 1.25em #ccc;
				box-shadow: 0px 0px 1.25em #ccc;
				-moz-border-radius: 0.6em;
				-webkit-border-radius: 0.6em;
				border-radius: 0.6em;
			}

			.ie6 #status {
				display: inline; /* float double margin fix http://www.positioniseverything.net/explorer/doubled-margin.html */
			}

			#status ul {
				font-size: 0.9em;
				list-style-type: none;
				margin-bottom: 0.6em;
				padding: 0;
			}

			#status li {
				line-height: 1.3;
			}

			#status h1 {
				text-transform: uppercase;
				font-size: 1.1em;
				margin: 0 0 0.3em;
			}

			#page-body {
				margin: 0.5em 0.5em 1.25em 1em;
			}

			h2 {
				margin-top: 1em;
				margin-bottom: 0.3em;
				font-size: 1em;
			}

			p {
				line-height: 1.5;
				margin: 0.25em 0;
			}

			#controller-list ul {
				list-style-position: inside;
			}

			#controller-list li {
				line-height: 1.3;
				list-style-position: inside;
				margin: 0.25em 0;
			}

			@media screen and (max-width: 480px) {
				#status {
					display: none;
				}

				#page-body {
					margin: 0 0.5em 0.5em;
				}

				#page-body h1 {
					margin-top: 0;
				}
			}
		</style>
		<script type="text/javascript">
//<![CDATA[
var cbc_params = {
		active_tab : function(){ if (${params.tab==null}) return 0; else return ${params.tab};}
	}
//]]>
</script>
	</head>
	<body>
		<div class="nav navpage" role="navigation" style="display:none;">
			<ul>
				<li><g:link class="list" controller="visit" action="dailyreport">Daily Visits Report</g:link></li>
			</ul>
		</div>
		<a href="#page-body" class="skip"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>		
		<div id="page-body" role="main">	
		<div id="tabs" style="display: none;">
			<ul>
				<li><a href="#tab-1">Summary</a></li>
				<li><a href="#tab-2">Daily Visits</a></li>
				<li><a href="#tab-3">Birthday List</a></li>
				<li><a href="#tab-4">Top Visitors</a></li>
			</ul>
			<div id="tab-1">
				<g:render template="summary"></g:render>
			</div>
			<div id="tab-2">
				<g:render template="dailyvisits"></g:render>
			</div>
			<div id="tab-3">
				<g:render template="birthdays"></g:render>
			</div>
			<div id="tab-4">
				<g:render template="topvisitors"></g:render>
			</div>
		</div>
		
		</div>

<br/><br/>
	<script>

	
	</script>		
	</body>
</html>
