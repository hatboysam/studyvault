    Stripe.setPublishableKey('pk_k9dYTK1ZBDiSkBte8pLqAoLuuKGuy');

	function stripeResponseHandler(status, response) {
		if (response.error) {
			// re-enable the submit button
			$('.submit-button').removeAttr("disabled");
			// show the errors on the form
			$(".payment-errors").html(response.error.message);
		} else {
			// token contains id, last4, and card type
			var form$ = $("#new_purchase");
			var token = response['id'];
			// insert the token into the form so it gets submitted to the server
			form$.append("<input type='hidden' name='stripeToken' value='" + token + "' />");
			// and submit
			form$.get(0).submit();
		}
	}
	
	$(document).ready(function() {
  		$("#new_purchase").submit(function(event) {
    		// disable the submit button to prevent repeated clicks
    		$('.submit-button').attr("disabled", "disabled");
			
    		var amount = 5000; //amount you want to charge in cents
    		Stripe.createToken({
        		number: $('.card-number').val(),
        		cvc: $('.card-cvc').val(),
        		exp_month: $('.card-expiry-month').val(),
        		exp_year: $('.card-expiry-year').val(),
				name: $('.name').val(),
				address_zip: $('.address_zip').val()
    			}, amount, stripeResponseHandler);

    			// prevent the form from submitting with the default action
    			return false;
  			});
		});