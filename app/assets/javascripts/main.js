$(function() {
  // $('.dateSelect').fdatepicker({
  //   format: 'mm/dd/yyyy'
  // }); 

  $('#all_plans tbody tr').css('cursor', 'pointer')
  $('#all_plans tbody tr').click(function() {
    window.location = $('a', $(this)).attr('href')
  }) 

  // Handler adding form fields
  $('form .add_fields').on('click', function(event) {
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
    event.preventDefault();
    $(this).hide();
    // Lets the cancel button know about the extra fields.
    $('form .cancel').on('click', cancelClicked );
  });

  function cancelClicked(event) {
    $(this).hide();
    $(this).prev('fieldset').remove();
    event.preventDefault();
  }

  $("#new-first-aid-station-submit").click(function() {
    update_first_aid()
  })

  $(".day-alert").parent().addClass("day-alert")
  $(".day-normal").parent().addClass("day-normal")

  $('.comment').click(function(e) {
    e.preventDefault();
    $(this).siblings('.new-comment-area').toggle();
  })
  $('#new-comment').click(function(event) {
    event.preventDefault();
    $.post($(this).attr('data-href') + "?comment_text=" + $('#attendance_comment_text').val(), function(data){} );
  })
});