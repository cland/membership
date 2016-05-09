<g:set var="settingsInstance" value="${cland.membership.Settings.find{true}}"/>
<g:set var="isDebug" value="${settingsInstance?.debug }"/>
<g:set var="smsTestNumber" value="${settingsInstance?.smsTestNumber }"/>
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
		<span style="display:none;" id="code_parentname"></span>
		<span style="display:none;" id="code_parentno">${childInstance?.person }</span>
		<span style="display:none;" id="code_starttime">${visitInstance?.starttime }</span>
		<span style="display:none;" id="code_childname"></span>	
			<div style="text-align:right;">Child: ${childInstance?.person } - Checked-in at: ${visitInstance?.starttime }</div>		
			<div class="send-wait">Sending message, please wait...</div>
			<div id="message"></div>
			<fieldset id="template-fieldset"><legend>Select Notification Template</legend>
			<table>
			<thead>
					<tr><th></th>		
						<th nowrap>${message(code: 'template.title.label', default: 'Title')}</th>							
						<th>${message(code: 'template.body.label', default: 'Body')}</th>				
					</tr>
				</thead>
				<tbody id="template_list">
				<g:each in="${templateInstanceList}" status="i" var="templateInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
						<td><input type="checkbox" class="template_checkbox" value="${templateInstance.id}" name="template_${templateInstance?.id}" id="template_${templateInstance?.id}" /></td>
						<td nowrap><g:link controller="template" action="show" id="${templateInstance.id}"><span id="template_${templateInstance?.id}_title">${fieldValue(bean: templateInstance, field: "title")}</span></g:link></td>					
						<td><span id="template_${templateInstance?.id}_body">${fieldValue(bean: templateInstance, field: "body")}</span></td>					
					</tr>
				</g:each>
				</tbody>
			</table>
			</fieldset>
			
			<fieldset id="previewmsg"><legend>Preview Message</legend>
				<form role="form" id="smsform" name="contactform" action="none" >
				<div class="table">
					<div class="row">
						<div class="cell">
							<div class="table">
								<div class="row">
									<div class="cell"><label id="">To Parent/Guardian:</label></div>
									<div class="cell"><input type="text" class="form-control" id="inputName" name="inputName" value="${childInstance?.parent?.person1 }" placeholder="Name"></div>
									<div class="cell"><label id="">Mobile No.:</label></div>
									<div class="cell"><input type="text" class="form-control" id="inputTel" name="inputTel" value="${visitInstance?.contactNo }" placeholder="Mobile Number"> </div>
								</div>								
							</div>
						</div>
					</div>
					<div class="row">
						<div class="cell">
							<textarea class="form-control" style="width:99%" readonly id="inputMessage" name="inputMessage" rows="6" placeholder="Message"></textarea>
						</div>
					</div>
					<div class="row">
						<div class="cell">
							<input type="hidden" name="templateId" id="templateId" value=""/>
							<button type="submit" id="sendsms_btn" class="btn btn-primary btn-lg">Send SMS</button>
						</div>
					</div>
				</div>
				</form>
			</fieldset>
		</div>

	<script>
		var notification = null;
		$(document).ready(function() {	
			//sendToHtown()
			notification = null
			$(document).on("click","#sendsms_btn",sendSMS)
			$(document).on("click",".template_checkbox",selectTemplate)
			
		});		
		function selectTemplate(){
			var el = $(this);
			if(el.prop("checked")){
				var _id = el.prop("id")
				var _body = $("#" + _id + "_body").text();
				var _title = $("#" + _id + "_title").text();
				var _name = $("#inputName").val();
				if(_name == "") _name = "${childInstance?.parent?.person1 }"
				$("#templateId").prop("value",el.prop("value"));
				$("#inputMessage").val(
						_body.replace(/{{parentname}}/gi,_name).
						replace(/{{parentno}}/gi,"${childInstance?.parent?.membershipNo }").
						replace(/{{childname}}/gi,"${childInstance?.person }").
						replace(/{{starttime}}/gi,"${visitInstance?.starttime }")
						)
			}
		}
		function sendSMS(){
			notification = null
			var name = $("#inputName").val();
			var num =  $("#inputTel").val();
			var debug = "${isDebug}";
			if(debug == "1") num = "${smsTestNumber}";
			
			var body = $("#inputMessage").val();	
			if(name == ""){
				alert("Please enter your name!"); return false;
			}
			if(num == ""){
				alert("Please enter either your mobile number!");return false;
			}
			
			if(body == ""){
				alert("Please enter your message!"); return false;
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
			notification = {'childid':${childInstance?.id},
					'visitid':${visitInstance?.id},
					'templateid':$("#templateId").prop("value"),
					'body':body,
					'sendto':num,
					'response_code':'',
					'response_msg':'',
					'response_code':'',
					'total_price':'',
					'total_count':'',
					'queued_count':''
					};
					
			$(".send-wait").show();
			$("#message").hide();
			$("#smsform").hide();
			$("#previewmsg").hide();
			$("#template-fieldset").hide();			
			sendToStown(JSON.stringify(msg),sendToStownCallback)
			return false;
		}
		function sendToStownCallback(data){
			$(".send-wait").append("<br/><p style='font-weight:bold;color:green;'>Saving notification...</p>")			
			console.log(data.response_code + " : " + data.response_msg);
			//$("#message").html("<p style='font-weight:bold;color:green;'>" + data.response_code + " : " + data.response_msg + "</p>");
			//TODO: if success full we need to save a record to the notifications database list
			saveNotification(data)
		}
		function saveNotification(data){
			notification.response_code = data.response_code;
			notification.response_msg = data.response_msg;
			notification.total_price = data.data.total_price;
			notification.total_count = data.data.total_count;
			notification.queued_count = data.data.queued_count;
			var jqxhr = $.ajax({
				  method: "POST",
				  url: "${request.contextPath}/harare/savenote",				  
				  data: JSON.stringify(notification)
				})
			  .done(function(data) {
				 console.log(data);
				 $(".send-wait").hide();
				 $("#message").show();
				 $("#message").html("<p style='font-weight:bold;color:green;'>" + data.response_code + " : " + data.response_msg + "</p>");
			  })
			  .fail(function() {
			    alert( "error" );
			  })
			  .always(function() {
			    console.log( "saveNotification complete!" );
			  });
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
