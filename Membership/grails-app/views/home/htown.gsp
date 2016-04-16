<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="maindialog"/>
		<title>Send Notification</title>
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
			<div class="wait">Sending message, please wait...</div>
			<div id="message"></div>
			<form role="form" id="smsform" name="contactform" action="none" >
				<div class="form-group col-sm-4" id="name-group">
					<input type="text" class="form-control" id="inputName" name="inputName" placeholder="Name">
				</div>
				<div class="form-group col-sm-4" id="phone-group">
					<input type="text" class="form-control" id="inputTel" name="inputTel" value='+61411111111' placeholder="Mobile Number">
				</div>
				<div class="form-group col-sm-12" id="message-group">
					<textarea class="form-control" id="inputMessage" name="inputMessage" rows="6" placeholder="Message"></textarea>
				</div>
				<button type="submit" id="sendsms_btn" class="btn btn-primary btn-lg">Send SMS</button>
			</form>
		</div>

<br/><br/>
	<script>

		$(document).ready(function() {	
			//sendToHtown()
			$(document).on("click","#sendsms_btn",sendSMS)
		});		
		
		function sendSMS(){
			var name = $("#inputName").val();
			var num = $("#inputTel").val();
			var body = $("#inputMessage").val();	
			if(name == ""){
				alert("Please enter your name!"); return;
			}
			if(num == ""){
				alert("Please enter either your mobile number!");return;
			}
			
			if(body == ""){
				alert("Please enter your message!"); return;
			}
			var msg = {'messages': [
					{
					  'source': 'html',
					  'from': 'WigglyToesIPC',
					  'body': body,
					  'to': num,
					  'schedule': 1436874701,
					  'custom_string': 'from Wiggly Toes IPC'
					}]
				}
			$(".wait").show();
			$("#message").hide();
			$("#smsform").hide();
			console.log(JSON.stringify(msg));
			sendToStown(JSON.stringify(msg),sendToStownCallback)
			return false;
		}
		function sendToStownCallback(data){
			$(".wait").hide();
			$("#message").show();
			console.log(data);
			console.log(data.response_code + " : " + data.response_msg);
			$("#message").html("<p style='font-weight:bold;color:green;'>" + data.response_code + " : " + data.response_msg + "</p>");
			//TODO: if success full we need to save a record to the notifications database list
		}

		function sendToHtown(){
			//ajax call here
			var jqxhr = $.ajax({
				  method: "POST",
				  url: "${request.contextPath}/harare/htown",
				  data: { to: "dembaremba@gmail.com", subject: "This is a test email",body:"This is the test body text", key:""  }
				})
			  .done(function(data) {
				 console.log(data);
			  })
			  .fail(function() {
			    alert( "error" );
			  })
			  .always(function() {
			    console.log( "complete!" );
			  });
		}

	</script>		
	</body>
</html>
