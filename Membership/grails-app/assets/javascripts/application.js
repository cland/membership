// This is a manifest file that'll be compiled into application.js.
//
// Any JavaScript file within this directory can be referenced here using a relative path.
//
// You're free to add application-wide JavaScript to this file, but it's generally better 
// to create separate JavaScript files as needed.
//
//= require jquery
//= require_tree jqueryui/
//= require moment.min.js
//= require moment-timezone-with-data.min.js
//= require_tree base/
//= require_tree .
//= require_self

if (typeof jQuery !== 'undefined') {
	(function($) {
		$('#spinner').ajaxStart(function() {
			$(this).fadeIn();
		}).ajaxStop(function() {
			$(this).fadeOut();
		});
	})(jQuery);
}

function sendToStown(msg,callback){
	var url = 'https://rest.clicksend.com/v3/sms/send'; // "http://localhost:8090/Membership/harare/htown"
	//ajax call here
	var jqxhr = $.ajax({
		  method: "POST",
		  url: url,
		  headers: { 
				'Content-Type': 'application/json',
				'Authorization':'Basic d2lnZ2x5dG9lc2lwYzp3aWdnbHl0b2VzaXBjMjAxNg==' },
		  data: msg
		})
	  .done(function(data) {
		 callback(data);
	  })
	  .fail(function() {
	    alert( "error" );
	  })
	  .always(function() {
	    console.log( "sendToStown complete!" );
	  });
}


