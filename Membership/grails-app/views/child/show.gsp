<%@ page import="cland.membership.SystemRoles" %>
<g:set var="activeVisit" value="${childInstance?.activeVisit }"/>
<g:set var="parent" value="${childInstance?.parent }"/>
<g:set var="visits" value="${childInstance.visits?.sort{it.starttime}.reverse() }"/>
<g:set var="settingsInstance" value="${cland.membership.Settings.find{true}}"/>
<%@ page import="cland.membership.Child" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'child.label', default: 'Child')}" />
		<title><g:message code="default.show.label" args="[entityName]" />: ${childInstance }</title>
		<g:render template="head" var="thisInstance" bean="${parentInstance }" model="[sidenav:page_nav]"></g:render>
		
	</head>
	<body>
		<a href="#show-child" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav navpage" role="navigation">
			<ul>
				
				<li><g:link class="create" controller="parent" action="show" id="${parent?.id }">Parent: ${parent }</g:link></li>	
				<li><a href="" class="button2" onclick="sendNotification('${childInstance?.id}','0'); return false;">Send Notification</a></li>			
			</ul>
		</div>
		<div id="show-child" class="content scaffold-show" role="main">
			<h1 class="hide">Child: ${childInstance } (${parent?.membershipNo +"-" + childInstance?.accessNumber})</h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<g:render template="childform" var="childInstance" bean="${childInstance }" model="[mode:'read',settings:settingsInstance]"></g:render>
			<g:form url="[resource:childInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${childInstance}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<sec:ifAnyGranted roles="${SystemRoles.ROLE_MANAGER },${SystemRoles.ROLE_ADMIN }">
						<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
					</sec:ifAnyGranted>
				</fieldset>
			</g:form>
		</div>
		<script>
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
		}); 

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
				  $("#current-visit-div").html("<div class='message' role='status'>Checked-out successfully!</div>"); //remove();
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

		  function getAussieDate(fmt,datestring){
				if(fmt === undefined || fmt ==="") fmt = 'DD MMMM YYYY HH:mm:ss';
				if(datestring === undefined || datestring === "") 
					return moment().tz("Australia/Perth").format(fmt);
				else
					return moment(datestring).tz("Australia/Perth").format(fmt);
			}
		</script>
	</body>
</html>
