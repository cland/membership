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
			<fieldset style="background: rgb(248, 70, 70) none repeat scroll 0% 0%;">
				<legend style="background:#fff;border: solid 2px rgb(248, 70, 70)">Quick Check-In Form</legend>			
				<div id="tabs" style="display: none;">
					<ul>
						<li><a href="#tab-1">Search Existing</a></li>
						<li><a href="#tab-2">New Client</a></li>
						<li><a href="#tab-3">Group/Birthday Booking</a></li>									
					</ul>
					<div id="tab-1">
						<form action="">
							<g:render template="searchform"></g:render>
							<div id="searchform-actions" style="display:none">
								<g:textField name="child.searchvisit.time" placeholder="Date and Time" value="${new Date().format('dd-MMM-yyyy HH:mm')}" id="visit_time_search" class="datetime-picker"/>
								<input type="button" name="quick_checkin" id="checkin_btn" value="Check-In Selected"/>
							</div>
						</form>
					</div>
					<div id="tab-2">
						<g:render template="newclient"></g:render>
					</div>
					<div id="tab-3">
						<g:render template="groupclient"></g:render>
					</div>
				</div>
			</fieldset>
			<div class="wait">Loading, please wait...</div>
			<g:render template="liveform" var="thisInstance" bean="${parentInstance }" model="[mode:'edit']"></g:render>
			
		</div>

<br/><br/>
	<script>
		function getTimeRemaining(endtime) {
		  var t = Date.parse(endtime) - Date.parse(new Date());
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
			 var t = Date.parse(new Date()) - Date.parse(time);
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
				  	console.log("Time up for '" + id + "'! " + t.total + " : " + time)
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
				  	console.log("Time up for '" + id + "'! " + t.total + " : " + time)
			      //	clearInterval(timeinterval);
			    }		
			}
		    
		  }
		
		  updateClock();
		  var timeinterval = setInterval(updateClock, 1000);
		}
		
	
		$(document).ready(function() {	
			var sa = new Date();
			console.log(">> " + sa);
			var perth    = moment().tz("2016-04-17 18:40", "Australia/Perth");
			console.log(">> " + perth);
			
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
			initBirthDatePicker($( "#birth-date1" ),"-2y");
			initBirthDatePicker($( "#birth-date2" ),"-2y");
			initBirthDatePicker($( "#grp-birth-date1" ),"-2y");
			initBirthDatePicker($( "#grp-bookingdate" ),"-2y");
			
			//setup the time pickers
			initTimePicker($("#visit_time1"),"")
			initTimePicker($("#visit_time2"),"")
			initTimePicker($("#visit_time_search"),"")
		});

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
				altFormat: "yy-mm-dd HH:mm",
				stepMinute: 5
			});
		}
		function initVisits(livepanel){
			//ajax call here
			var jqxhr = $.ajax({ 
					url: "${request.contextPath}/child/visits",
					cache: false
				 })
			  .done(function(data) {
				  $.each(data,function(index,el){
					  var name = el.child.person.firstname + " " + el.child.person.lastname
					  var id = el.child.id
					  var tel = el.child.parent.person1.mobileno
					  var email = el.child.parent.person1.email
					  var parent_name = el.child.parent.person1.firstname + " " + el.child.parent.person1.lastname
					  var timein = el.starttime

					 
					  var deadline = new Date(Date.parse(timein));
					 // deadline.setHours(deadline.getHours() + 2)
					  
					  addActiveVisit(livepanel, "" + id,name,"assets/kidface.png",tel,timein,"--","clock-normal")
					  var countup =  true;
					  var warning_limit = 4000000; //milliseconds = 15 min
					  var done_limit = 9900000; //just over 2 hours
					  initializeClock('clockdiv_' + id, deadline,countup,warning_limit,done_limit);
				});
			  })
			  .fail(function() {
			    alert( "error" );
			  })
			  .always(function() {
			    console.log( "complete!" );
			  });
		
		}

		function addActiveVisit(el, divid,name,photo,tel,timein,extratime, clockstatus){
			var html = '<div class="person-card float-left">' +
			  '<img class="person-img" src="' + photo + '" alt="Child" />' +
			  '<div class="person-info">' +
				'<div class="details-title">' +
				  '<span>' + name + '</span><br/>' +
				  '<small>Tel: ' + tel + '</small>' +
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
				'<br/><div class="details-body">' +
				  '<span><b>Time in:</b> ' + timein + '</span><br/>' +
				  '<span><b>Extra:</b> ' + extratime + '</span><br/>' +
				  '<br/><span>' +
					'<g:submitButton class="button" id="btn_notify_' + divid +'" onclick="sendNotification(' + divid + ')" name="btn_' + divid + '" value="Notify" />' +
					 '<g:submitButton class="button" id="btn_checkout_' + divid +'" onclick="checkOut(this)" name="btn_' + divid + '" value="Check-Out" />' +
					 '<g:submitButton class="button" id="btn_view_' + divid +'" onclick="viewChild(this)" name="btn_' + divid + '" value="View More" />' +
				  '</span>' +
				'</div>' +
			  '</div>' +
			'</div>';

			el.prepend(html);

		}

		function sendNotification(_id){
			_id = 1;
		  	 var $dialog = $('<div><div id="wait" style="font-weight:bold;text-align:center;">Loading...</div></div>')             
		                .load('${g.createLink(controller: 'harare', action: 'smsdialogcreate',params:[id:_id])}')		                
		                .dialog({
		                	modal:true,
		                    autoOpen: false,
		                    dialogClass: 'no-close',
		                    width:800,
		                    beforeClose: function(event,ui){
		                    	
		                    },
		                    buttons:{
		                        "DONE":function(){			                      	 
		                         	 $dialog.dialog('close')
		                            },
		                         "CANCEL":function(){
		                      	   $dialog.dialog('close')
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
	</script>		
	</body>
</html>
