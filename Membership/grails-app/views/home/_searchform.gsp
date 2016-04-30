<%@page import="org.apache.jasper.compiler.Node.ParamsAction"%>
<%@ page import="cland.membership.security.Person" %>
<%@ page import="cland.membership.Parent" %>		
		<div>
			<div id="group-finder-div">
				<input style="width:40em;padding:10px;" id="person-clients" name="query" value="" placeholder="Search for lastname or membership no.">
			</div>
		
			<table id="child-table" style="display:none">
			<thead>
				
			</thead>
			<tbody id="child-list">
			
			</tbody>
			</table>
			
		</div>
		
		<script type="text/javascript">
<!--  
function checkInForm(formid){
	var _action = $("#" + formid).prop("action"); //search_form
	var formdata = new FormData($("#" + formid)[0]);
	var jqxhr = $.ajax({ 
		url: _action,
		processData: false,
		contentType: false,
		data:formdata,		
		method:"POST",
		cache: false
	 })
  .done(function(data) {
	  if(data.result = "success"){		 
		  if(data.result === "success"){
			  var panel = $("#livepanel");
			  panel.html("")
			  clearSearchForm();
			  initVisits(panel);
		  }
	  }else{
		  alert("Failed to check in clients: '" + data.message + "'")
		}
  })
  .fail(function() {
    alert( "error" );
  })
  .always(function() {
    	//console.log( "complete!" );
  });
	return false;
}
function onprogressHandler(evt) {
    var percent = evt.loaded/evt.total*100;
    console.log('Upload progress: ' + percent + '%');
}
function checkIn(_timein,_contactno, _values){
	console.log(_timein + ": " + _values.toString());
	var postdata = new FormData(); // { 'values': _values.toString(), 'starttime': _timein,'contactno':_contactno };
	
	postdata.append('values',_values.toString());
	postdata.append('starttime',_timein);
	postdata.append('contactno',_contactno);

	$.each(_values, function(i,file){
		postdata.append('file_' + i,$("#file_"+i));
	});
	
	var jqxhr = $.ajax({ 
		url: "${request.contextPath}/parent/checkin",
		data:postdata.toString(),
		contentType: contentType = "multipart/form-data; boundary="+data.boundary,
		method:"POST",
		cache: false
	 })
  .done(function(data) {
	  if(data.result = "success"){		 
		  if(data.result === "success"){
			  var panel = $("#livepanel");
			  panel.html("")
			  clearSearchForm();
			  initVisits(panel);
		  }
	  }else{
		  alert("Failed to check in clients: '" + data.message + "'")
		}
  })
  .fail(function() {
    alert( "error" );
  })
  .always(function() {
    	//console.log( "complete!" );
  });
	return false;	  
}
function clearSearchForm(){
	var _tbody = $("#child-list");				
	_tbody.html("");
	 $("#child-table").hide();
	 $("#searchform-actions").hide()	 
}
$(document).ready(function() {
	
	$(document).on("click","#checkin_btn",function(){
			var checkin_time = $("#visit_time_search").val();
			var checkin_contactno = $("#checkin_contactno").val();
			var checkedValues = $('input[name="search_children"]:checked').map(function() {
			    return this.value;
			}).get();
	
			//checkIn(checkin_time,checkin_contactno,checkedValues);
			checkInForm("search_form")
		});

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
			$.ajax({
				url : "${g.createLink(controller: 'parent', action: 'search')}", 
				dataType: "json",
				data : request,
				success : function(data) {
					response(data); // set the response
				},
				error : function() { // handle server errors
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
			//process the children
			if(_childlist != null){
				$("#child-table").show();
				var _tbody = $("#child-list");				
				_tbody.html("<tr><td colspan='3'>Parent/Gardian: <a href='" + _parentlink + "'>" + _parentlabel + "</a></td><td colspan='2'>Today's visit contact number: <input type='type' id='checkin_contactno' name='contactno' value='" + _contactno +"'/>" );
				_tbody.append("<tr><td class='thead'></td><td class='thead'>Name</td><td class='thead'>Age</td><td class='thead'>Gender</td><td class='thead'>Today's Photo</td>");
				$.each(_childlist,function(item){
					var _sel = '';
					
					var _chbox = "<input type='checkbox' name='search_children' value='" + this.id + "' " +_sel+ "/>";
					var _photoinput = "<input type='file' id='file_" + this.id + "' name='visitphoto" + this.id + "'/>";
					if(this.isactive){
						_chbox = "<span style='font-weight:bold;color:green'>In</span>";
						_photoinput = "";
					} 											
					_tbody.append("<tr><td>" + _chbox + "</td><td>" + this.person.firstname + " " + this.person.lastname + "</td><td>" + this.person.age + "</td><td>" + this.person.gender + "</td><td>" + _photoinput + "</td>");	
				})
				initTimePicker($("#visit_time_search"),"")
				$("#searchform-actions").show()					
			}
			ui.item.value = ""
		}
	});

});
//-->
</script>