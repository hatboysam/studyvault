//** BEGIN GOOGLE ANALYTICS **//
var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-28046262-1']);
_gaq.push(['_trackPageview']);

(function() {
var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();
//** END GOOGLE ANALYTICS **//

$(document).ready(function () {	
		//makes sure all download links open in a new window
		$(".downloadlink").click(
			function() {
				//window.location.replace(window.location.pathname+"/?downloaded=true&swag=50");
				window.location.replace(window.location.pathname+"/?downloaded=true");
		});
		$(".disabled").live("click",function(e){
			e.preventDefault();
			return true;
		});
});	

//** FORM VALIDATION **//
$(document).ready(function() {
	//Disable button if validating a form
	if($("[data-validate='parsley']").size() > 0) {
		$('.btn-success').addClass('disabled');
		//Fix for form not submitting (only for Parsley 1.0.0)
		//$('.btn-success').click(function(e) {
			//var form = $(this).closest('form');
			//form.unbind('submit');
			//form.submit();
		//});
	}
	//Only enable button when # of success = # validated
	$('.parsley-validated').live('change', function(e) {
		var num_validated = $('.parsley-validated').size();
		var num_success = $('.parsley-success').size();
		if(num_validated == num_success) {
			$('.btn-success').removeClass('disabled');
		} else {
			$('.btn-success').addClass('disabled');
		}
	});
});

//** AUTOCOMPLETE **//
function get_school_suggestions(key,cont) {
	var path = "/schools.js";
	var params = { "term":key };
	$.get(
	  path,
	  params,
	  function(obj){
	    cont(JSON.parse(obj));
	  }
	);
}

function get_course_suggestions(key,cont) {
	var path = "/courses.js";
	var params = { "term":key };
	$.get(
	  path,
	  params,
	  function(obj){
	    cont(JSON.parse(obj));
	  }
	);
}

function get_professor_suggestions(key,cont) {
	var path = "/professors.js";
	var params = { "term":key };
	$.get(
	  path,
	  params,
	  function(obj){
	    cont(JSON.parse(obj));
	  }
	);
}

function auto_complete(selector, callback) {
	add_loading_spinner(selector);
	$(selector).autocomplete({
		ajax_get : callback,
		minchars : 1,
		timeout : 4000,
		noresults : 'No matches'
	});
}

//Remove loading spinner once a selection is made
$(document).ready(function() {
	$('.jqac-highlight').live('click', function(e) {
		$('input').removeClass('inputloading');
	});
});

//Add a loading spinner to an input
function add_loading_spinner(selector) {
	$(selector).bind('keyup', function(){
		if ($(this).val().length >= 1) {
			$(this).addClass("inputloading");
		} else {
			$(this).removeClass("inputloading");
		}
	});
}

function auto_school(selector) {
	auto_complete(selector, get_school_suggestions);
}

function auto_course(selector) {
	auto_complete(selector, get_course_suggestions);
}

function auto_professor(selector) {
	auto_complete(selector, get_professor_suggestions);
}


