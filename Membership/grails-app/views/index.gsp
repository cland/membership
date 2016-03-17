<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title>Wiggly Toes IPC Membership System</title>
		<style type="text/css" media="screen">
			
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
		<a href="#page-body" class="skip"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>		
		<div id="page-body" role="main">			
			<fieldset><legend>Quick Check-In Form</legend>			
				<div id="tabs" style="display: none;">
					<ul>
						<li><a href="#tab-1">Search Existing</a></li>
						<li><a href="#tab-2">New Client</a></li>
						<li><a href="#tab-3">Group/Birthday Booking</a></li>									
					</ul>
					<div id="tab-1">
						<form action="">
							<input name="query" value="">
							<g:submitButton name="Search" class="save" value="Search" />
						</form>
					</div>
					<div id="tab-2">
						<g:render template="newclient"></g:render>
					</div>
					<div id="tab-2">
						<g:render template="groupclient"></g:render>
					</div>
				</div>
			</fieldset>
			
			<g:render template="liveform" var="thisInstance" bean="" model=""></g:render>
			
		</div>

<br/><br/>
	<script>
		function getTimeRemaining(endtime) {
		  var t = Date.parse(endtime) - Date.parse(new Date());
		  var seconds = Math.floor((t / 1000) % 60);
		  var minutes = Math.floor((t / 1000 / 60) % 60);
		  var hours = Math.floor((t / (1000 * 60 * 60)) % 24);
		  var days = Math.floor(t / (1000 * 60 * 60 * 24));
		  return {
		    'total': t,
		    'days': days,
		    'hours': hours,
		    'minutes': minutes,
		    'seconds': seconds
		  };
		}
		
		function initializeClock(id, endtime) {
			console.log("id: '" + id + "'")
		  var clock = document.getElementById(id);
		  var daysSpan = clock.querySelector('#' + id + ' .days');
		  var hoursSpan = clock.querySelector('#' + id + ' .hours');
		  var minutesSpan = clock.querySelector('#' + id + ' .minutes');
		  var secondsSpan = clock.querySelector('#' + id + ' .seconds');
		
		  function updateClock() {
		    var t = getTimeRemaining(endtime);
		
		    daysSpan.innerHTML = t.days;
		    hoursSpan.innerHTML = ('0' + t.hours).slice(-2);
		    minutesSpan.innerHTML = ('0' + t.minutes).slice(-2);
		    secondsSpan.innerHTML = ('0' + t.seconds).slice(-2);
		
		    if (t.total <= 0) {
			  console.log("Time up!")
		      clearInterval(timeinterval);
		    }
		  }
		
		  updateClock();
		  var timeinterval = setInterval(updateClock, 1000);
		}
		
	
		$(document).ready(function() {
			$("#tabs").tabs(
					{
					active:cbc_params.active_tab(),
					create: function (event,ui){	
						//executed after is created								
						$('#tabs').show()
					},
					show: function(event,ui){
						//on every tabs clicked
					},
					beforeLoad : function(event, ui) {
							ui.jqXHR.error(function() {
								ui.panel
								.html("Couldn't load this tab. We'll try to fix this as soon as possible. ");
							});
						}
			});
			var startDate = new Date(); //"11 March 2016 22:23:00";
			var deadline = new Date(Date.parse(startDate)); //(Date.parse(new Date()) + 15 * 24 * 60 * 60 * 1000);
			deadline.setHours(deadline.getHours() + 2);
			initializeClock('clockdiv', deadline);
			initializeClock('clockdivtwo', new Date((Date.parse(new Date()) + 15 * 24 * 60 * 60 * 1000)));
			initializeClock('clockdivthree', new Date((Date.parse(new Date()) + 15 * 24 * 60 * 60 * 1000)));
			initializeClock('clockdivfour', new Date((Date.parse(new Date()) + 15 * 24 * 60 * 60 * 1000)));
			
		});
	</script>		
	</body>
</html>
