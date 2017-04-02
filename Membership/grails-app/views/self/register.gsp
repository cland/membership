<%@ page import="cland.membership.SystemRoles" %>
<g:set var="cbcApiService" bean="cbcApiService"/>
<g:set var="settingsInstance" value="${cland.membership.Settings.find{true}}"/>
<% def childcount=settingsInstance?.newchildcount %>

<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title>Register: Wiggly Toes IPC Membership System</title>
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
			<div style="text-align:center;">
				<img alt="Wiggly Toes Creche, Cockburn in partnership with Goodlife Health Clubs" src="http://www.wigglytoesipc.com/images/promo1-goodlife.png">
			</div>
			<g:if test="${flash.message}">
				<div class="message" style="font-size:1.5em;text-align:center !important;" role="status">				
					${flash.message}
				</div>
			</g:if>			
			<fieldset style="background: rgb(248, 70, 70) none repeat scroll 0% 0%;">
				<legend style="background:#fff;border: solid 2px rgb(248, 70, 70)">Register Form</legend>			
				<div id="tabs" style="display: none;">
					<ul style="display:none;">						
						<li><a href="#tab-1">New Client</a></li>											
					</ul>					
					<div id="tab-1">
						<div class="wait hide">Processing, please wait...</div>
						<div id="start-register" style="text-align:center;">
							<input type="button" class="button" id="start-register-btn" name="startregisterbtn" value="I have been to a Wiggly Toes Centre" style="font-size: 1em;"/>
							<input type="button" class="button" id="new-register-btn" name="newregisterbtn" value="I am yet to visit one" style="font-size: 1em;"/>
						</div>
						<div id="errors-div" class="errors hide"></div>
						<div id="form-div">
						
						<g:uploadForm id="newclient_form" name="newclient_form" url="[controller:'self',action:'selfregister']"
						onsubmit="return submitForm()" >
							<g:render template="register" model="[settings:settingsInstance]"></g:render>
							<fieldset class="buttons">
								<g:submitButton id="register-btn" name="create" class="save" value="${message(code: 'default.button.register.label', default: 'Register')}" />
								<input type="button" name="cancel" onclick="document.location='${request.contextPath}/self/register'" class="cancel" value="${message(code: 'default.button.cancel.label', default: 'Cancel')}" />
							</fieldset>
						</g:uploadForm>
						</div>
						
						<div id="form-div-reset" style="display:none;">							
							<div id="errors-div-reset" class="errors hide"></div>
							<g:form id="resetclient_form" name="resetclient_form" onsubmit="return submitFormReset();" url="[controller:'self',action:'selfreset']">
								<div>
									<div id="group-finder-div">
										<p>Enter the email-address used when you first registered at any Wiggly Toes Indoor Centre</p>
										<asset:image src="spinner.gif" class="spinner-wait" style="display:none" id="spinner-wait-search" title="Processing, please wait..." alt="Processing, please wait...!"/>
										<input style="width:48.5em;padding:10px;border-color:rgba(8, 7, 7, 0.52);" id="person-email" name="resetemail" value="" placeholder="Email address">
									</div>
									<div class="form-group col-sm-4" style="margin-top:40px;" id="membershipno">
										<p>Enter your <span style="font-weight:bold;color:#46b5e1;"> Goodlife Health Clubs</span> membership number:</p>
										<input type="text" class="form-control" style="width:48.5em;padding:10px;border-color:rgba(8, 7, 7, 0.52);" id="membership-no" name="membershipno" placeholder="Membership Number">
									</div>
									<div class="form-group col-sm-4" style="margin-top:40px;" id="captcha-group">
										<input type="text" class="is_realperson form-control" style="width:48.5em;padding:10px;border-color:rgba(8, 7, 7, 0.52);" id="defaultReal" name="defaultReal" placeholder="Enter letters displayed above.">
										<input type="hidden" name="border" value="" id="border"/>
										<input type="hidden" name="captcha" value=""/>
										<input type="hidden" name="partner.id" value="${ cland.membership.Partner.find{true}?.id}" id="partner-id">
										
									</div>
								</div>
								
								<div class="" style="margin-top:20px">
									<g:submitButton id="reset-btn" name="create" class="button" value="${message(code: 'default.button.register.label', default: 'Send my details')}" />
									<input type="button" name="cancel" class="button" onclick="document.location='${request.contextPath}/self/register'" class="cancel" value="${message(code: 'default.button.cancel.label', default: 'Cancel')}" />
								</div>
							</g:form>
						</div>
					</div>
					
				</div>
			</fieldset>
			
			
		</div>

<br/><br/>
<script src="js/jquery.plugin.js" type="text/javascript"></script>
<script src="js/jquery.realperson.js" type="text/javascript"></script>
	<script>
		function submitForm(){
			var _email = $("#parentemail").prop("value");
			var _result = validateEmail(_email);			
			
			if(_result){
				$(".wait").show();$("#form-div").hide();
				return true
			}
			//problem with email
			$("#errors-div").html("<b>Please provide a valid email address.</b>");
			$("#parentemail").css("background","red").css("color","yellow").css("font-weight","bold").focus();
			$("#errors-div").show();
			return false;
		}
		function submitFormReset(){
			var msgEl = $("#errors-div")
			var _email = $("#person-email").prop("value");
			var _result = validateEmail(_email);			
			
			if(!_result){
				//problem with email
				msgEl.html("<b>Please provide a valid email address.</b>");
				$("#person-email").css("background","red").css("color","yellow").css("font-weight","bold").focus();
				msgEl.show();							
				return false
			}
			$("#person-email").css("background","white").css("color","black")
			//get the value of the harsh
			var el=$("#defaultReal");var _b='getHash'; el.removeClass("error-input");
		
			//$("#border").prop("value",el.realperson(_b));$("#catpcha").prop("value",el.val());
			if(el.val() == ""){
				msgEl.append("<b>Please enter the letters on the CAPTCHA to verify that you are a real person</b>");
				$("#defaultReal").css("background","red").css("color","yellow").css("font-weight","bold").focus();
				msgEl.show();
				return false;
			}
			
			var _form = $("#form-div-reset");
			$(".wait").show(); _form.hide();

			var data = {
					  'source': 'pub-html',
					  'resetemail':_email,
					  'membershipno':$("#membership-no").prop("value"),
					  'border':$("#border").prop("value"),
					  'captcha': el.prop("value"),
					  'sitename':'wigglytoesipc',	
					  'partnerid':	$("#partner-id").prop("value"),			  
					  'border':el.realperson(_b),
					  'basic':'d2lnZ2x5dG9lTUFJT52365Yzp3aWdnbHl0b2VzaXBjMjAxNm1BSUxFUg=='
					}
			var url = "${request.contextPath}/self/selfreset";			
				//ajax call here
				var jqxhr = $.ajax({
					  method: "POST",
					  url: url,
					  data: data
					})
				  .done(function(data) {
					 console.log(">> " + data.result)
					 msgEl.show();
					 if(data.result=="success"){						 
						 msgEl.html("Account reset successful. Follow the instructions in the email sent to your inbox to confirm and complete the account reset process. ")
						 msgEl.css("color","green")
						 msgEl.show()
						 $("div#start-register").hide();
					 }else if(data.result=="failedcaptcha"){
						 msgEl.html("<b>" + data.message + "</b>")
						 _form.show()
						 $("#defaultReal").css("background","red").css("color","yellow").css("font-weight","bold").focus();
						
					 }else{
						 msgEl.html("<b>" + data.message + "</b>")
						 
						 $("div#start-register").show();
					 }
				  })
				  .fail(function() {
				    msgEl.html("System error, please try again later.");
				   _form.trigger('reset').show();
				  })
				  .always(function() {
				    console.log( "complete!" );
				    $(".wait").hide();
				  });
			return false;
		}
		
		$(document).ready(function() {
			$("#defaultReal").realperson({
				length: 5
			});
			setTimeout(function () {
			    $(".message").html("<span style='font-weight:bold;'>Thank you!</span>");
			    $(".message").fadeOut(5000);
			}, 16000);
			$(".message").fadeIn(2000).animate({
			    padding: "+=20"
			}, 1500).delay(1000).queue(function (next) {
			    $(this).css("border", "1px #000 solid");
			    $(this).css("color", "green");
			    $(this).css("font-weight", "bold");
			    $(this).css("font-size", "1.5em");
			    next();
			});
			$("#form-div").hide();
			$(".nav").hide()
			$("#current-user").hide();
			$(".child-form-entry").hide();
			$("#child1").show();
			$(".child1").prop("required",true);
			$("#rmicon-child1").hide();
			$(document).on("click","#next-child-btn",function(){
				var childid = $("#curchild-count").prop("value");
				var nxtchild = (parseInt(childid) + 1);
				$("#child" + nxtchild).show();
				$(".child" + nxtchild).prop("required",true);
				$(".child" + nxtchild).prop("disabled",false);
				$(".textbox-child" + nxtchild).prop("disabled",false);
				$("#child-firstname-" + nxtchild).focus();
				$("#curchild-count").prop("value",nxtchild);
				
			});
			$(document).on("click",".rm-child-icon",function(){
				var id = $(this).prop("id").replace(/rmicon-/gi,"");
				var i = id.replace(/child/gi,"");
				$("#curchild-count").prop("value",(parseInt(i)-1));
				$("#" + id).hide();
				$("." + id).prop("disabled",true);
				$(".textbox-" + id).prop("disabled",true);
				
			});

			$(document).on("change","#parentemail",function(){
				checkEmailAddress($(this).prop("value"))
				})
			
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

			//setup the datepicker calendars
			var newchildcount = ${childcount};
			for(var i=0;i<newchildcount;i++){
				initBirthDatePicker($( "#birth-date" + (i+1) ),"-2y");
				//initTimePicker($("#visit_time" + (i+1)),"")
			}
			$(document).on("click","#new-register-btn",function(){
				$("div#start-register").hide();
				var _form = $("#newclient_form");
				$("div#form-div").show();
				_form.trigger("reset");
				$("#errors-div").hide();
			})

			$(document).on("click","#start-register-btn",function(){
				$("div#start-register").hide();
				var _form = $("#newclient_form");
				$("div#form-div-reset").show();
				_form.trigger("reset");
				$("#errors-div").hide();
			})
		});

		function onSuccessNewClientCallbackHander(data,textStatus){
				//append any new visits to the live panel
				$('#tabs').tabs("option", "active", 0);				
				$("#newclient_form").trigger("reset");
				$("#newclient_form").hide();
			}
		function onLoading(){
			$(".wait").show()
		}
		function onComplete(){
			$(".wait").hide()
		}
		function onFailure(data,textStatus){
			$(".wait").hide()
			alert("Operation failed with status '" + textStatus + "'")
		}
		function initBirthDatePicker(el,def){
			el.datepicker({
				dateFormat: "dd-M-yy",
				altFormat: "yy-mm-dd",
				defaultDate : def,					
				maxDate:"-0y",
				minDate:"-90y"
				});
		}
		function initTimePicker(el,def){			
			el.datetimepicker({
				controlType: 'select',
				oneLine: true,
				timeFormat: 'HH:mm', // 'hh:mm tt',
				dateFormat: "dd-M-yy",
				altFormat: "yy-mm-dd",
				altTimeFormat : "HH:mm",
				altFieldTimeOnly: false,
				stepMinute: 5
			});
			el.prop("value",getAussieDate("DD-MMM-YYYY HH:mm"))
		}						

		function validateEmail($email) {
			if($email == "") return false;
			var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,6})?$/;
			return emailReg.test( $email );
		}
		function checkEmailAddress(email){
			var jqxhr = $.ajax({ 
				url: "${request.contextPath}/self/validateEmail?e=" + email,
				method:"GET",
				cache: false
			 })
		  .done(function(data) {	 
			  if(data.result == "success"){		 
					if(data.ison){
						$("#errors-div").html("<b>This username or email address is not available!</b>");
						$("#parentemail").css("background","red").css("color","yellow").css("font-weight","bold").focus();
						$("#errors-div").show();
					}else{
						$("#parentemail").css("background","white").css("color","black").css("font-weight","normal");
						$("#errors-div").hide();
					}
			  }else{
				  alert("Failed to check the email address'")
				}
		  })
		  .fail(function() {
		    alert( "error" );
		  })
		  .always(function() {
			  $(".wait").hide();
		  });
		}

		function onResetSuccess(data){
			console.log("Success...")
			console.log(data.result)
		}
		function onResetFailure(){
			console.log(">> Error")
		}
		function onResetComplete(data){
			$(".wait").hide();
		}
	</script>		
	</body>
</html>
