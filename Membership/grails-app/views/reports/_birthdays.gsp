<fieldset><legend>Birthday List</legend>
	<div id="birthdaydatawait" class="hide">Loading list, please wait ...</div>
	<table class="inner-table">
	<thead>
			<tr id="birthday-report-header">
				<th>Date</th>
				<th>Child Name</th>
				<th>Age</th>
				<th>Gender</th>	
				<th>Visits</th>						
				<th>Contact No</th>
				<th>Email</th>
				<th>Action</th>									
			</tr>
		</thead>
		<tbody id="birthdaydata">
			
		</tbody>
	</table>
</fieldset>

<script>
$(document).ready(function() {	
	//birthdaylist()
});

function birthdaylist(){
   	var _tbody = $("#birthdaydata");
	var _waitrow = $("#birthdaydatawait");
	_waitrow.show();
	_tbody.html("")
	var _form = $("#birthdayform");
	var postdata = _form.serialize(); //{ 'status':status };			
	var jqxhr = $.ajax({ 
		url: "${request.contextPath}/child/birthdaylist",
		data:postdata,				
		cache: false
	 })
	  .done(function(data) {				  	
			 $.each(data,function(i,elem){	 				 
				 _btnfunc = "sendNotification('" + elem.id + "','0'); return false;";
				 _notifybtn = '<a href="" class="button2" onclick="' + _btnfunc + '">Send a Message</a>'
				 _tbody.append("<tr><td>" + elem.person.birthdate + "</td><td><a href='${request.contextPath}/child/show/" + elem.id + "'>" + elem.person.fullname + "</a></td><td>" + elem.person.age + "</td><td>" + elem.person.gender.label + "</td><td>" + elem.visitcount + "</td><td>" + elem.parent.person1.mobileno + "</td><td>" + elem.parent.person1.email + "</td><td>" + _notifybtn + "</td></tr>")
			 });
			 _waitrow.hide();
	  })
	  .fail(function() {
		  _waitrow.hide();
	  })
	  .always(function() {
	    	//console.log( "complete!" );
	  });

	return false;
} //end function
function sendNotification(_child_id,_visit_id){		
	 var _link = "${g.createLink(controller: 'harare', action: 'smsdialogcreate')}?cid=" + escape(_child_id) + "&vid=" + _visit_id ;
	 console.log(_link);
	 	
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
</script>