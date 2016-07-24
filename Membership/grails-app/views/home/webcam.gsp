<g:set var="settingsInstance" value="${cland.membership.Settings.find{true}}"/>
<g:set var="isDebug" value="${settingsInstance?.debug }"/>

<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="maindialog"/>
		<title>WebCam</title>
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
	<asset:javascript src="webcam.js"/>
	</head>
	<body>
		<a href="#page-body" class="skip"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>		
		<div id="page-body" role="main">
			<div id="div-live">
				<div id="my_camera"></div>
				<div id="pre_take_buttons">
					<input type=button value="Take Snapshot" onClick="preview_snapshot()">
				</div>
				<div id="post_take_buttons" style="display:none">
					<input type=button value="&lt; Take Another" onClick="cancel_preview()">
					<input type=button value="Save Photo &gt;" onClick="save_photo()" style="font-weight:bold;">
				</div>
			</div>
			<div id="div-result">
				your result will appear here
			</div>
		</div>

	<script>
		
		$(document).ready(function() {	
			var _name = '${picname}';
			var _fmt = '${fmt}';
			console.log("name: " + _name + " fmt: " + _fmt);
			init_webcam(_name,_fmt,'#my_camera');
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
		function preview_snapshot() {
			// freeze camera so user can preview pic
			Webcam.freeze();
			
			// swap button sets
			document.getElementById('pre_take_buttons').style.display = 'none';
			document.getElementById('post_take_buttons').style.display = '';
		}
		
		function cancel_preview() {
			// cancel preview freeze and return to live camera feed
			Webcam.unfreeze();
			
			// swap buttons back
			document.getElementById('pre_take_buttons').style.display = '';
			document.getElementById('post_take_buttons').style.display = 'none';
		}
		
		function save_photo() {
			// actually snap photo (from preview freeze) and display it
			var _link = "${g.createLink(controller: 'harare', action: 'doupload')}"
			Webcam.snap( function(data_uri) {
				// display results in page
				
				Webcam.upload( data_uri, _link, function(code, text) {
                            // Upload complete!
                            // 'code' will be the HTTP response code from the server, e.g. 200
                            // 'text' will be the raw response content
                    console.log("code: " + code + " text: " + text)
                    document.getElementById('div-result').innerHTML = 
    					'<h2>Here is your image: (' + code +')</h2>' + 
    					'<img src="'+data_uri+'"/>';
                });
				
				
				// swap buttons back
				document.getElementById('pre_take_buttons').style.display = '';
				document.getElementById('post_take_buttons').style.display = 'none';
			} );
		}
	</script>		
	</body>
</html>
