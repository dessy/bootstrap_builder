// Reset the state of the submit button
$(document).ready(function() {
  $('input[type=submit].btn.change_to_text').show();
  $('.submit_text').hide();
});

// Shows the submit button replacement text on click
$('input[type=submit].btn.change_to_text input[type=submit]').live('click', function(){
  $(this).parent().next().show();
  $(this).parent().hide();
})
