// Reset the state of the submit button
$(document).ready(function() {
  $('.form_element.submit.change_to_text').show();
  $('.submit_text').hide();
});

// Shows the submit button replacement text on click
$('.form_element.submit.change_to_text input[type=submit]').live('click', function(){
  $(this).parent().next().show();
  $(this).parent().hide();
})

// Activates the submit button click when clicking the image button
$('.form_element.submit a.submit_image').live('click', function(){
  $(this).prev().click();
  return false;
})
