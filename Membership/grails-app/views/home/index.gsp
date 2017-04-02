<%@ page import="cland.membership.SystemRoles" %>
<g:set var="settingsInstance" value="${cland.membership.Settings.find{true}}"/>
<g:set var="warn_minutes" value="${settingsInstance?.notifytime }"/>
<g:set var="done_minutes" value="${settingsInstance?.donetime }"/>
<% def childcount=settingsInstance?.newchildcount %>

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
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>	
			<div class="wait">Loading, please wait...</div>
			<sec:ifNotGranted roles="${SystemRoles.ROLE_DEVELOPER },${SystemRoles.ROLE_ADMIN },${SystemRoles.ROLE_ASSISTANT },${SystemRoles.ROLE_MANAGER }">
				<div style="text-align:center">
					<img alt="Wiggly Toes Creche, Cockburn in partnership with Goodlife Health Clubs" src="http://www.wigglytoesipc.com/images/promo1-goodlife.png">
					<br/>
					<input type="button" class="button" onclick="document.location.href='${request.contextPath}/visitBooking/create'" name="bookvisit" value="Book a visit" style="font-size: 1em;"/>
				</div>
			</sec:ifNotGranted>
			<sec:ifAnyGranted roles="${SystemRoles.ROLE_DEVELOPER },${SystemRoles.ROLE_ADMIN },${SystemRoles.ROLE_ASSISTANT },${SystemRoles.ROLE_MANAGER }">		
			<fieldset style="background: rgb(248, 70, 70) none repeat scroll 0% 0%;">
				<legend style="background:#fff;border: solid 2px rgb(248, 70, 70)">Quick Check-In Form</legend>			
				<div id="tabs" style="display: none;">
					<ul>
						<li><a href="#tab-1">Search Existing</a></li>
						<li><a href="#tab-2">New Client</a></li>
						<sec:ifAnyGranted roles="${SystemRoles.ROLE_DEVELOPER }">
							<li><a href="#tab-3">Group/Birthday Booking</a></li>	
						</sec:ifAnyGranted>								
					</ul>
					<div id="tab-1">
						<form id="search_form" name="search_form" action="${request.contextPath}/parent/checkin" enctype="multipart/form-data">
							<g:render template="searchform" model="[settings:settingsInstance]"></g:render>
							<div id="searchform-actions" style="display:none">
								<g:textField name="child.searchvisit.time" placeholder="Date and Time" value="${new Date().format('dd-MMM-yyyy HH:mm')}" id="visit_time_search" class="datetime-picker"/>
								<input type="button" class="button" name="quick_checkin" id="checkin_btn" value="Check-In Selected"/>
								<input type="button" class="button" name="quick_clear" id="clear_btn" value="Clear"/>
							</div>
						</form>
					</div>
					<div id="tab-2">
						<div id="form-div">
						<div id="errors-div" class="errors hide"></div>
						<g:uploadForm id="newclient_form" name="newclient_form" url="[controller:'parent',action:'newclient']"
						onsubmit="return submitForm()" >
							<g:render template="newclient" model="[settings:settingsInstance]"></g:render>
							<fieldset class="buttons">
								<g:submitButton id="register-btn" name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Submit')}" />
								<input type="button" name="cancel" onclick="document.location='${request.contextPath}/'" class="cancel" value="${message(code: 'default.button.cancel.label', default: 'Cancel')}" />
							</fieldset>
						</g:uploadForm>
						</div>
					</div>
					<sec:ifAnyGranted roles="${SystemRoles.ROLE_DEVELOPER }">
						<div id="tab-3">
							<g:render template="groupclient" model="[settings:settingsInstance]"></g:render>
						</div>
					</sec:ifAnyGranted>
				</div>
			</fieldset>
			
			<g:render template="liveform" var="thisInstance" bean="${parentInstance }" model="[mode:'edit',settings:settingsInstance]"></g:render>
		</sec:ifAnyGranted>
		</div>

<br/><br/>
	<script>
		function getTimeRemaining(endtime) {
		  var t = Date.parse(endtime) - Date.parse(getAussieDate());
		  return parseClock(t);
		}
		function parseClock(t){
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
		function getTimeSpent(time) {
			 var t = Date.parse(getAussieDate()) - Date.parse(time);
			 return parseClock(t);
		}
		
		function initializeClock(id, time,countup,warning_limit,done_limit) {
		  var clock = document.getElementById(id);
		  var daysSpan = clock.querySelector('#' + id + ' .days');
		  var hoursSpan = clock.querySelector('#' + id + ' .hours');
		  var minutesSpan = clock.querySelector('#' + id + ' .minutes');
		  var secondsSpan = clock.querySelector('#' + id + ' .seconds');
		
		  function updateClock() {
		    var t = 0;
		    if(countup) t = getTimeSpent(time); else t = getTimeRemaining(time);
		
		    daysSpan.innerHTML = t.days;
		    hoursSpan.innerHTML = ('0' + t.hours).slice(-2);
		    minutesSpan.innerHTML = ('0' + t.minutes).slice(-2);
		    secondsSpan.innerHTML = ('0' + t.seconds).slice(-2);

		    if(countup){
			    //count up
		    	if(t.total > warning_limit & t.total < done_limit){
				    //warning
				    $("#" + id).removeClass("clock-done")
			    	$("#" + id).removeClass("clock-normal")  
				  	$("#" + id).addClass("clock-warn")
				}else if (t.total >= done_limit) {
			    	$("#" + id).removeClass("clock-warn")
			    	$("#" + id).removeClass("clock-normal")  
				  	$("#" + id).addClass("clock-done")
				 // 	console.log("Time up for '" + id + "'! " + t.total + " : " + time)
			      	//clearInterval(timeinterval);
			    }
			}else{
				//count down
		    	if(t.total < warning_limit & t.total > done_limit){
				    //warning
				    $("#" + id).removeClass("clock-done")
			    	$("#" + id).removeClass("clock-normal")  
				  	$("#" + id).addClass("clock-warn")
				}else if (t.total <= done_limit) {
			    	$("#" + id).removeClass("clock-warn")
			    	$("#" + id).removeClass("clock-normal")  
				  	$("#" + id).addClass("clock-done")
				  //	console.log("Time up for '" + id + "'! " + t.total + " : " + time)
			      //	clearInterval(timeinterval);
			    }		
			}
		    
		  }
		
		  updateClock();
		  var timeinterval = setInterval(updateClock, 1000);
		}
		
		function showTheTime() {
		   var s = getAussieDate();    
		   $("#time").html(s)
		}
		function getAussieDate(fmt,datestring){
			if(fmt === undefined || fmt ==="") fmt = 'DD MMMM YYYY HH:mm:ss';
			if(datestring === undefined || datestring === "") 
				return moment().tz("Australia/Perth").format(fmt);
			else
				return moment(datestring).tz("Australia/Perth").format(fmt);
		}
		
		$(document).ready(function() {	
			console.log("DATE: " + new Date())
			
			var livepanel = $("#livepanel")
			initVisits(livepanel)
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
				initTimePicker($("#visit_time" + (i+1)),"")
			}
			
			initBirthDatePicker($( "#grp-birth-date1" ),"-2y");
			initBirthDatePicker($( "#grp-bookingdate" ),"-2y");
			
			//setup the time pickers			
			initTimePicker($("#visit_time_search"),"")

			//show datetime:
			showTheTime(); // for the first load
			setInterval(showTheTime, 250); // update it periodically 

		});
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
		function onSuccessNewClientCallbackHander(data,textStatus){
				//append any new visits to the live panel
				$("#livepanel").empty();
				$('#tabs').tabs("option", "active", 0);
				initVisits($("#livepanel"))
				$("#newclient_form").trigger("reset");
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
		function initVisits(livepanel){
			//ajax call here
			var jqxhr = $.ajax({ 
					url: "${request.contextPath}/child/visits",
					cache: false
				 })
			  .done(function(data) {
				  $.each(data,function(index,el){
					  var visit_id = el.id;
					  var name = el.child.person.firstname + " " + el.child.person.lastname
					  var id = el.child.id
					  var tel = el.contactno; //el.child.parent.person1.mobileno
					  var email = el.child.parent.person1.email
					  var parent_name = el.child.parent.person1.firstname + " " + el.child.parent.person1.lastname
					  var timein = el.starttime
					  var visitno = el.visitno
					  var photoid = el.child.person.photoid
					  var deadline = new Date(Date.parse(timein));
					  var clienttype = el.child.parent.clienttype.name;
					  var clienttypeflag = "";
					  var office = el.office.name
					  var officeid = el.office.id
					  if(clienttype == "GymMember") clienttypeflag = " <b>(GYM)</b>";
						  
					 // deadline.setHours(deadline.getHours() + 2)
					  var photolink = "${request.contextPath}/attachmentable/show/" + photoid;
					  if(photoid == null || photoid == "") photolink = "assets/kidface.png"
					  addActiveVisit(livepanel, "" + id,visit_id,name,photolink,tel,timein,"--","clock-normal",visitno,clienttypeflag,office)
					  var countup =  true;
					 
					  var selected_hr = el.duration.selectedhours;
					  var selected_min = (selected_hr * 60);
					  var current_min = (el.duration.days * 24 * 60) + (el.duration.hours * 60) + el.duration.minutes;					
					  var warning_limit = getMillis((selected_min - ${warn_minutes})); //3300000; //milliseconds = 55 min (45min = 2700000) (minutesx3600x100)
					  var done_limit = getMillis(selected_min); //just over 2 hours
					 
					  initializeClock('clockdiv_' + id, deadline,countup,warning_limit,done_limit);
				});
			  })
			  .fail(function() {
			    alert( "error" );
			  })
			  .always(function() {
			    
			  });
		
		}

		function addActiveVisit(el, divid,visit_id,name,photo,tel,timein,extratime, clockstatus,visitno,clienttypeflag,office){
			var lnk = "${request.contextPath}/child/show/" + divid;
			var html = '<div id="person_' + visit_id + '" class="person-card float-left">' +
			  '<img class="person-img" src="' + photo + '" alt="Child" />' +
			  '<div class="person-info">' +
				'<div class="details-title">' +
				  '<span><a style="color:#fff;" href="' +lnk + '">' + name + '</a></span><br/>' +
				  '<small>Tel: ' + tel + clienttypeflag + '</small>' +
				  '<div id="clockdiv_' + divid + '" class="clock ' + clockstatus +'">' +
					  '<div style="display:none;">' +
						'<span class="days"></span>' +
						'<div class="smalltext">Days</div>' +
					  '</div>' +
					  '<div>' +
						'<span class="hours"></span>' +
						'<div class="smalltext">Hours</div>' +
					  '</div>' +
					  '<div>' +
						'<span class="minutes"></span>' +
						'<div class="smalltext">Minutes</div>' +
					  '</div>' +
					  '<div>' +
						'<span class="seconds"></span>' +
						'<div class="smalltext">Seconds</div>' +
					  '</div>' +
					'</div>' +
				'</div>' +
				'<div class="details-body">' +
				  '<span><small><b>WBN:</b> ' + visitno + '</small></span><br/>' +
				  '<span><small><b>TIME IN:</b> <br/>' + timein + '</small></span><br/>' +
				  '<span class=""><small><b>Office:</b> ' + office + '</small></span>' +
				  '<br/><span>' +
					'<input type="submit" class="button2" id="btn_notify_' + divid +'" onclick="sendNotification(\'' + divid + '\',\'' + visit_id + '\')" name="btn_' + divid + '" value="Notify" />' +
					 '&nbsp;<input type="submit" class="button2" id="btn_checkout_' + visit_id +'" onclick="checkOut(\'' + visit_id + '\',\'Complete\')" name="btn_' + divid + '" value="Check-Out" />' +
					 '&nbsp;<input type="submit" class="button2" id="btn_view_' + divid +'" onclick="checkOut(\'' + visit_id + '\',\'Cancelled\')" name="btn_' + divid + '" value="Cancel" />' +
				  '</span>' +
				'</div>' +
			  '</div>' +
			'</div>';

			el.prepend(html);

		}
		function checkOut(_id,status){
			var postdata = { 'id': _id, 'endtime': getAussieDate('DD-MMM-YYYY HH:mm'),'status':status };
			var jqxhr = $.ajax({ 
				url: "${request.contextPath}/parent/checkout",
				data:postdata,
				method:"POST",
				cache: false
			 })
		  .done(function(data) {
			  if(data.result = "success"){				 
				  $("#person_" + data.id).remove();
			  }else{
				  alert("Failed to check out client: '" + data.message + "'")
				}
		  })
		  .fail(function() {
		    alert( "error" );
		  })
		  .always(function() {
		    	//console.log( "complete!" );
		  });
		}
		function sendNotification(_child_id,_visit_id){		
			 var _link = "${g.createLink(controller: 'harare', action: 'smsdialogcreate')}?cid=" + escape(_child_id) + "&vid=" + _visit_id ;
			 	
		  	 var $dialog = $('<div><div id="wait" style="font-weight:bold;text-align:center;">Loading...</div></div>')             
		                .load(_link)		                
		                .dialog({
		                	modal:true,
		                    autoOpen: false,
		                    dialogClass: 'no-close',
		                    width:800,
		                    beforeClose: function(event,ui){
		                    	
		                    },
		                    buttons:{
		                        "DONE":function(){			                      	 
		                         	// $dialog.dialog('close')
		                         	 $dialog.dialog('destroy').remove()
		                            }
			                    },
		                    close: function(event,ui){
		                  	  	$dialog.dialog('destroy').remove()
		                  	
		                    },
		                    position: {my:"top",at:"top",of:window},
		                    title: 'Send SMS Notification'                         
		                });
		                    
		                $dialog.dialog('open');
		               
		  } //end function sendNotification()
		  function getMillis(minutes){
			  return (minutes * 60000);
			  }

		  function onSuccessBookingCallbackHander(data,textStatus){
			  $(".bookingwait").hide()
			  $("#booking-message").show()
			  $("#newgroup_form").show()
				//append any new visits to the live panel
				if(data.result == "success"){
					$("#newgroup_form").trigger("reset").hide();
					$("#booking-message").addClass("message").removeClass("errors");
					$("#booking-message").html("Booking saved successfully!")
				}else{
					$("#booking-message").addClass("errors").removeClass("message");
					$("#booking-message").html("Error: " + data.message)					
				}
				
			}
		function onBookingLoading(){
			$(".bookingwait").show()
			$("#booking-message").hide()
			$("#newgroup_form").hide()
		}
		function onBookingComplete(){
			$(".bookingwait").hide()
		}
		function onBookingFailure(data,textStatus){
			$(".bookingwait").hide()
			$("#booking-message").html("Operation failed with status '" + textStatus + "'")
			$("#booking-message").removeClass("message").addClass("errors");
		}
		function validateEmail($email) {
			  var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,6})?$/;
			  return emailReg.test( $email );
		}
	</script>		
	</body>
</html>
