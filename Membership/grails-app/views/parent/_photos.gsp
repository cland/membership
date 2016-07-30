<%@ page import="org.joda.time.DateTime" %>
<%@ page import="cland.membership.lookup.*" %>
<g:set var="children" value="${parentInstance?.children}"/>
<g:set var="isEditMode" value="${mode?.equals("edit") }"/>
<g:set var="settingsInstance" value="${cland.membership.Settings.find{true}}"/>
<g:set var="isDebug" value="${settingsInstance?.debug }"/>

	
	
	<fieldset><legend>Profile Photos</legend>
		<g:if test="${parentInstance.children}" >
			<g:each in="${parentInstance?.children?.sort{it?.person.firstName} }" var="child" status="i">
			<div id="photo-container-${child?.id }" class="photo-container-div"> 
				<h2>${child?.person }</h2>
				<input type="hidden" name="photo_name_${child?.id }" id="photo_name_${child?.id }" value="${child?.parent?.membershipNo + child?.accessNumber + child?.id + child?.person?.firstName }"/>
				<div id="div-live-${child?.id }"  class="float-right live-webcam">					
					<input type=button value="Open WebCam" id="${child?.id }" class="init-webcam-btn button"/>
					<div id="my_camera_${child?.id }"></div><br/>
					<div id="pre_take_buttons_${child?.id }" class="pre_take_buttons_${child?.id} take_buttons" style="display:none">
						<input class="button2" type=button value="Take Snapshot" onClick="preview_snapshot('${child?.id }')">
					</div>
					<div id="post_take_buttons_${child?.id }" class="post_take_buttons_${child?.id}  take_buttons" style="display:none">
						<input class="button2" type=button value="&lt; Take Another" onClick="cancel_preview('${child?.id }')">
						<input class="button2" type=button value="Save Photo &gt;" onClick="save_photo('${child?.id }')" style="font-weight:bold;">
					</div>
				</div>
				<div id="div-result-${child?.id }">
					<g:set var="hasPhoto" value="0"/>
					<attachments:each bean="${child?.person}">
						<g:set var="hasPhoto" value="1"/>
						<img src="/wiggly/attachmentable/show/${attachment?.id }" alt="Current Profile Picture for ${child?.person }" title="Current Profile Picture for ${child?.person }"/><br/>
						<attachments:deleteLink
	                         attachment="${attachment}"
	                         label="${'[Delete] '}"
	                         returnPageURI="${createLink(action: 'show', id: parentInstance?.id, params:[tab:5])}"/>						    
						    <br/>				
					</attachments:each>
				</div>
				<g:if test="${hasPhoto == '0' }">					
					<img id="no-photo-${child?.id }" src="${assetPath(src: 'kidface.png')}" title="No Photo Available" alt="No Photo Available"/>
				</g:if>
				<div style="clear:both;"></div>
			</div>	
			</g:each>
		</g:if>		
	</fieldset>
	<script>
		
		$(document).ready(function() {	
			$(document).on("click",".init-webcam-btn",function(){				
				_id = $(this).prop("id") 
				_fileid = "profilephoto" + _id 
				_filename = $("#photo_name_" + _id).prop("value");
				_fmt = "png"
				Webcam.reset()
				$(".init-webcam-btn").show()
				$(".take_buttons").hide()
				init_webcam(_fileid,_fmt,'#my_camera_' + _id);
				$('#' + _id).hide();
				$('.pre_take_buttons_' + _id).show();
				$('.post_take_buttons_' + _id).hide();
			});
				
		});	
			
		function init_webcam(_name,_fmt, canvas){			
			Webcam.set({
				// live preview size
				width: 320,
				height: 240,
				
				// device capture size
				dest_width: 320,
				dest_height: 240,
				
				// final cropped size
				crop_width: 240,
				crop_height: 240,
				image_format: _fmt,
				jpeg_quality: 90,
				upload_name : _name
			});
			Webcam.attach( canvas );
		}
		function preview_snapshot(_id) {
			// freeze camera so user can preview pic
			Webcam.freeze();
			
			// swap button sets
			$('.pre_take_buttons_' + _id).hide();
			$('.post_take_buttons_' + _id).show();
		}
		
		function cancel_preview(_id) {
			// cancel preview freeze and return to live camera feed
			Webcam.unfreeze();
			
			// swap buttons back
			$('.pre_take_buttons_' + _id).show();
			$('.post_take_buttons_' + _id).hide();
		}
		
		function save_photo(_id) {
			// actually snap photo (from preview freeze) and display it
			var _link = "${g.createLink(controller: 'harare', action: 'doupload')}"
			Webcam.snap( function(data_uri) {
				// display results in page
				var form = new FormData();
				form.append("childid",_id)
				form.append("fileid","profilephoto" + _id)
				Webcam.upload( data_uri, _link,form, function(code, text) {
                            // Upload complete!
                            // 'code' will be the HTTP response code from the server, e.g. 200
                            // 'text' will be the raw response content
                    console.log("code: " + code + " text: " + text)
                    document.getElementById('div-result-' + _id).innerHTML = 
    					'<img src="'+data_uri+'"/>';
                });
				
				
				// swap buttons back
				$('.pre_take_buttons_' + _id).show();
				$('.post_take_buttons_' + _id).hide();
				$('#no-photo-' + _id).hide();
				Webcam.reset()
				$(".init-webcam-btn").show()
				$(".take_buttons").hide()
			} );
		}
	</script>		
	
