<%@ page import="cland.membership.lookup.*" %>
<%@page import="org.apache.jasper.compiler.Node.ParamsAction"%>
<%@ page import="cland.membership.security.Person" %>
<%@ page import="cland.membership.Parent" %>
<% def grpchildcount=settings?.maxbooking %>
<% def childcount=settings?.newchildcount %>
<div class="bookingwait">Saving booking, please wait...</div>
<div id="booking-message"></div>
<g:formRemote name="newgroup_form" url="[controller:'booking',action:'newbooking']" 
			update="bookingpanel" 
			onSuccess="onSuccessBookingCallbackHander(data,textStatus)"
			onLoading="onBookingLoading()"
			onComplete="onBookingComplete()"
			onFailure="onBookingFailure(data,textStatus)">

	<fieldset><legend>Booking</legend>
		<input type="hidden" name="booking.bookingtype" value="${Keywords.findByName("Birthday")?.id }"/>
		<div class="table">
			<div class="row">
				<div class="cell">	
					<div class="table">
						<div class="row">	
							<div class="cell"><label id="">Date:</label><br/>
								<g:textField name="booking.date" id="grp-bookingdate" class="datepick_single_past" value=""/>			
							</div>
							<div class="cell"><label for="booking.office" id=""><g:message code="visitBooking.office.label" default="Wiggly Play Centre:" />	</label><br/>
								<g:select id="booking.office" name="booking.office.id" from="${cland.membership.Office.list()}" optionKey="id" value="${visitBookingInstance?.office?.id}" required="" class="many-to-one" noSelection="['null': '']"/>			
							</div>
							<div class="cell"><label id="">Total number of kids incl birthday child?:</label><br/>
								<g:textField name="booking.totalkidcount"  value=""/><br/>					
							</div>
							<div class="cell"><label id="">Total number of adults:</label><br/>
								<g:textField name="booking.totaladultcount" placeholder=""  value=""/>
							</div>
						</div>
					</div>
				</div>		
			</div>
			<div class="row">
				<div class="cell">
					<div class="table" style="width:100%;">
						<div class="row">
							<div class="cell" style="width:26%"><label id="">Time slot:</label><br/>
								<% def _timeslots = cland.membership.lookup.Keywords.findByName("PartyTimeSlots")?.values?.sort{it.id}.reverse() %>
								<g:radioGroup id="key_PartyTimeSlots"
									values="${_timeslots?.id}"
									labels="${_timeslots}" 
									name="booking.timeslot">
									${it.radio} <g:message code="${it.label}" /><br/>
								</g:radioGroup>	
							</div>
							<div class="cell" style="width:26%"><label id="">Room:</label><br/>
								<% def _rooms = cland.membership.lookup.Keywords.findByName("Room")?.values?.sort{it.id} %>
								<g:radioGroup id="key_Room"
									values="${_rooms?.id}"
									labels="${_rooms}" 
									name="booking.room">
									${it.radio} <g:message code="${it.label}" /><br/>
								</g:radioGroup>	
							</div>
							<div class="cell" style="width:26%"><label id="">Party Package:</label><br/>
							<% def _packages = cland.membership.lookup.Keywords.findByName("PartyPackage")?.values?.sort{it.id} %>
								<g:radioGroup id="key_PartyPackage"
									values="${_packages?.id}"
									labels="${_packages}" 
									name="booking.partyPackage">
									${it.radio} <g:message code="${it.label}" /><br/>
								</g:radioGroup>	
							</div>
							<div class="cell"><label id="">Theme:</label><br/>
							<% def _themes = cland.membership.lookup.Keywords.findByName("PartyTheme")?.values?.sort{it.label} %>
								<g:radioGroup id="key_PartyTheme"
									values="${_themes?.id}"
									labels="${_themes}" 
									name="booking.partyTheme">
									${it.radio} <g:message code="${it.label}" /><br/>
								</g:radioGroup>	
							</div>						
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="cell">
					<label>Comments: </label><br/>
					<textarea name="booking.comments" rows="5" cols="70" style="width:84%"></textarea>
				</div>		
			</div>
		</div>
	</fieldset>		
<fieldset><legend>Contact Person</legend>
		<div>
			<div id="group-finder-div">
				<asset:image src="spinner.gif" class="spinner-wait" id="spinner-wait-search" title="Searching, please wait..." alt="Searching, please wait...!"/>
				<input style="width:98%;padding:10px;border-color:rgba(8, 7, 7, 0.52);" id="person-clients" name="query" value="" placeholder="Search for lastname or membership no.">
			</div>
			<div style="overflow-x:auto;">
				<table id="child-table" style="display:none">
					<thead>
						
					</thead>
					<tbody id="child-list">
					
					</tbody>
				</table>
			</div>
		</div>
	<div class="table">
				<div class="row">
					<div class="cell"><label id="">First name:</label></div>
					<div class="cell">
						<span class="property-value" aria-labelledby="home-label">
							<g:textField name="parent.person1.firstName" required="" value=""/>
						</span>
					</div>	
					<div class="cell"><label id="">Cell number:</label></div>
					<div class="cell">
						<span class="property-value" aria-labelledby="home-label">
							<g:textField name="parent.person1.mobileNo" value=""/>
						</span>
					</div>			
				</div>
				<div class="row">
					<div class="cell"><label id="">Surname:</label></div>
					<div class="cell">
						<span class="property-value" aria-labelledby="home-label">
							<g:textField name="parent.person1.lastName" required="" value=""/>
						</span>
					</div>
					<div class="cell"><label id="">Email:</label></div>
					<div class="cell">
						<span class="property-value" aria-labelledby="home-label">
							<g:textField name="parent.person1.email" value=""/>
						</span>
					</div>			
				</div>
		
				<div class="row">
					<div class="cell"><label id="">Id number:</label></div>
					<div class="cell">
						<span class="property-value" aria-labelledby="home-label">
							<g:textField name="parent.person1.idNumber" value=""/>
						</span>
					</div>		
					<div class="cell"><label id="">Relationship:</label></div>
					<div class="cell">
						<% def reltypes = cland.membership.lookup.Keywords.findByName("RelationshipTypes")?.values?.sort{it.id} %>
						<g:radioGroup 
							values="${reltypes?.id}"
							labels="${reltypes}" 
							name="parent.relationship">
							${it.radio} <g:message code="${it.label}" />
						</g:radioGroup>
					</div>			
				</div>				
			</div>
	</fieldset>	
	<fieldset><legend>Birthday Child Details</legend>
	<div id="existing-client-children"></div>
	<div class="table">
			<div class="row">
				<div class="cell">
					<div class="table">
						<g:each in="${(1..childcount).toList()}" var="index">
							<div class="row child-form-entry" id="child${index }">
								<div class="cell" style="width:20px;"><h1>${index }.</h1>
									<asset:image src="skin/icon_cross.png" class="child${index }-rmicon rm-child-icon" id="rmicon-child${index }" title="Remove this entry" alt="Remove this entry!"/>
								</div>
								<div class="cell border-bottom">
									<g:textField class="child${index }" name="child.person.firstname${index }" placeholder="First Name"  value="" id="child-firstname-${index }"/><br/>
									<g:textField class="child${index }" name="child.person.lastname${index }" placeholder="Last Name"  value="" id="child-lastname-${index }"/><br/>
									<label>Check-in now:</label> 
									<g:checkBox class="child-checkbox${index }" name="child.checkin${index }" value="Yes" />
									<g:textField class="child-starttime${index }" name="child.visit.time${index }" placeholder="Date and Time" value="${new Date().format('dd-MMM-yyyy HH:mm')}" id="visit_time${index }" class="datetime-picker"/>
								</div>
								<div class="cell border-bottom">
									<g:textField class="child${index }" name="child.person.dateOfBirth${index }" placeholder="Date of Birth" id="birth-date${index }" class="datepick_single_past" value=""/>						
									<% def gender = cland.membership.lookup.Keywords.findByName("Gender")?.values?.sort{it?.label} %>
									<br/><g:radioGroup style="margin-top:15px;" 
										class="child${index }"
										values="${gender?.id}"
										labels="${gender}" 
										name="child.person.gender${index }">
										${it.radio} <g:message code="${it.label}" />
									</g:radioGroup>
									<br/><span class="visit-wbn-input"><br/><g:textField class="child-wbn${index }" name="child.visit.visitno${index }" placeholder="Wrist Band No."  value="" id="visit-visitno-${index }"/></span>
								</div>
								<div class="cell border-bottom">
									<label>Profile Photo:</label> <input type="file" name="profilephoto${index }"/><br/>
									<span class="visit-photo-input"><label>Full Body Photo:</label> <input type="file" name="visitphoto${index }"/><br/></span>
									
								</div>			
							</div>
						</g:each>				
					</div>
				</div>
			</div>
			<div class="row">
					<input type="hidden" name="currentChildCount" id="curchild-count" value="1"/>
					<input type="button" class="button2" id="next-child-btn" name="add-child_btn" value="Add Another Child" style="margin-left:30px;"/>
			</div>			
			
		</div>
	</fieldset>
	<fieldset>
		<legend>List of Children</legend>
		<div class="table">
			
			<g:each in="${(1..grpchildcount).toList()}" var="index">
				<div class="row">
					<div class="cell" style="width:20px;"><h1>${index+1 }.</h1></div>
					<div class="cell">
						<input type="text" name="childlead.firstName" value="" placeholder="First Name" id="lead-firstname-${index }" />
					</div>
					<div class="cell">
						<input type="text" name="childlead.lastName" value="" placeholder="Last Name" id="lead-lastname-${index }" />
					</div>
					<div class="cell">
						<input type="text" name="childlead.mobileNo" value="" placeholder="Mobile Number" id="lead-mobileno-${index }" />
					</div>
				</div>
			</g:each>
			
		</div>
	</fieldset>
	<fieldset class="buttons">
		<g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Submit')}" />
		<input type="button" name="cancel" onclick="document.location='${request.contextPath}/'" class="cancel" value="${message(code: 'default.button.cancel.label', default: 'Cancel')}" />
	</fieldset>
</g:formRemote>
<script type="text/javascript">
	$(document).ready(function(){
		var _spinner = $("#spinner-wait-search");
		_spinner.hide();
		
		initBirthDatePicker($( "#grp-birth-date1" ),"-2y");
		initBirthDatePicker($( "#grp-bookingdate" ),"-2y");

		//birthday children
		$(".visit-photo-input").hide();
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

		//search form
		$(document).on("click","#clear_btn",function(){
			clearSearchForm();
		});
		//** PERSON CLIENT Auto Complete Call **//
		 $.widget( "custom.catcomplete", $.ui.autocomplete, {
			_create: function() {
				this._super();		
				this.widget().menu( "option", "items", "> :not(.ui-autocomplete-category)" );			
			},
			_renderMenu: function( ul, items ) {
				var that = this,
				currentCategory = "";			
				$.each( items, function( index, item ) {
					var li;
					if ( item.category != currentCategory ) {
						ul.append( "<li class='ui-autocomplete-category'>" + item.category + "</li>" );
						currentCategory = item.category;
					}
					li = that._renderItemData( ul, item );
					if ( item.category ) {
						li.attr( "aria-label", item.category + " : " + item.label );
					}
				});
			}
		});

		//** Parent/Child Picker			
		$( "#person-clients" ).catcomplete({
			source: function(request,response) {
				var _spinner = $("#spinner-wait-search");
				_spinner.show();
				$.ajax({
					url : "${g.createLink(controller: 'parent', action: 'search')}", 
					dataType: "json",
					data : request,
					success : function(data) {
						_spinner.hide();					
						if(data.id != -1) response(data); // set the response
					},
					error : function() { // handle server errors
						_spinner.hide();
						alert("Unable to retrieve records");
					}
				});
			},
			minLength : 2, // triggered only after minimum 2 characters have been entered.
			select : function(event, ui) { // event handler when user selects a company from the list.
				//parent details
				var _parentid = ui.item.id;
				var _parentlabel = ui.item.label;
				var _contactno = ui.item.contactno;
				var _category = ui.item.category;
				var _childlist = (ui.item.childlist == null?null:ui.item.childlist)			
				var _parentlink = "${request.contextPath}/parent/show/" + _parentid;
				var _coupon ="";
				if(ui.item.activecoupon != null){
					_cpn = ui.item.activecoupon;
					_coupon = "<br/><span class='coupon-display-span'><b>Active coupon " + _cpn.refno + ":</b> <span class='coupon-balance'>" + _cpn.balance + "</span> of " + _cpn.maxvisits + " hrs left | Expiry date: " + moment(_cpn.expirydate).format("DD MMM YYYY") + "</span>";
				}
				var _partnerMembership = ""
				if(ui.item.partnercontract){
					_verifybtn = "";
					if(!ui.item.partnercontract.isvalidmember){
						_verifybtn = "<a id='confirm-membership' class='' href='#' onclick='return confirmMembership(" + ui.item.partnercontract.id + ")'>[Confirm]</a>"
					}else{
						_verifybtn = "<img src='${request.contextPath}/static/plugins/famfamfam-1.0.1/images/icons/tick.png' title='Confirmed' alt='Confirmed'>";
					}									
					_partnerMembership = "<br/><span class='partnercontract-display-span'><b>" + ui.item.partnercontract.partner.name + "</b> membership no.: <b>" + ui.item.partnercontract.membershipno.toString().toUpperCase() + "</b></span><img src='${request.contextPath}/assets/spinner.gif' class='spinner-membership-wait hide' id='spinner-membership-wait' title='Processing, please wait...' alt='Processing, please wait...!'/> <span id='membership-container'>" + _verifybtn + "</span>"
				}
				
				var _todaybookings = "";
				if(ui.item.booking){
					$.each(ui.item.booking,function(index, bItem){
						_todaybookings += "<div style='font-size:small'><b>Date/Time:</b> " + bItem.bookingdate + "</div>"
					});
				}else{
					_todaybookings = "<div>No bookings!</div>"
				}
					
				//process the children
				if(_childlist != null){
					$("#child-table").show();
					var _tbody = $("#child-list");				
					_tbody.html("<tr><td colspan='4'><label>Parent/Gardian: </label><br/><a href='" + _parentlink + "'>" + _parentlabel + "</a>" + _coupon + _partnerMembership + "</td><td colspan='2'><label>Today's visit contact number:</label> <br/><input type='type' id='checkin_contactno' name='contactno' value='" + _contactno +"'/><br/><label>Today's bookings: </label><br/>" + _todaybookings + "</td></tr>");			
					_tbody.append("<tr><td class='thead'></td><td class='thead'>Name</td><td class='thead col-not-important'>Age</td><td class='thead col-not-important'>Gender</td><td class='thead visit-wbn-col'>Wrist Band No.</td><td class='thead visit-photo-col col-not-important'>Today's Photo</td></tr>");
					$.each(_childlist,function(item){
						var _sel = '';
						
						var _chbox = "<input type='checkbox' name='search_children' value='" + this.id + "' " +_sel+ "/>";
						var _photoinput = "<input type='file' id='file_" + this.id + "' name='visitphoto" + this.id + "'/>";
						var _inputbandno = "<input type='text' id='wbn_" + this.id + "' name='visitno" + this.id + "' value=''/>";
						
						if(this.isactive){
							_chbox = "<span style='font-weight:bold;color:green'>In</span>";
							_photoinput = "";
						} 											
						_tbody.append("<tr><td>" + _chbox + "</td><td>" + this.person.firstname + " " + this.person.lastname + "</td><td class='col-not-important'>" + this.person.age + "</td><td class='col-not-important'>" + this.person.gender.label + "</td><td class='visit-wbn-input'>" + _inputbandno + "</td><td class='visit-photo-input col-not-important'>" + _photoinput + "</td></tr>");	
					})
					
					$("#searchform-actions").show()		
					//$(".visit-wbn-input").hide();
					$(".visit-photo-col").hide(); $(".visit-photo-input").hide();		//depending on settings			
				}
				ui.item.value = ""
			}
		});
	});  //End ready
	function initBirthDatePicker(el,def){
		el.datepicker({
			dateFormat: "dd-M-yy",
			altFormat: "yy-mm-dd",
			defaultDate : def,					
			maxDate:"-0y",
			minDate:"-90y"
			});
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
	function clearSearchForm(){
		var _tbody = $("#child-list");				
		_tbody.html("");
		 $("#child-table").hide();
		 $("#searchform-actions").hide()	 
	}
</script>