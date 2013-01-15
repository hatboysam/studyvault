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
});	