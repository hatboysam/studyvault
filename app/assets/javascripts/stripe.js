$(document).ready(function(){
	$('#stripeButton').click(function() {
		var token = function(res){
			console.log('Got token ID: ', res.id);
			$('#stripeToken').attr("value",res.id);
			$('#stripeToken').closest('form').submit();
		};

		StripeCheckout.open({
			key: "<%= Rails.configuration.stripe[:publishable_key] %>",
			address: false,
			amount: 499,
			name: "StudyHeist - Buy 10 Credits",
			panelLabel: "10 Credits - ",
			token: token 
		});
		return false;
	});
});