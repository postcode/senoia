$(function() {
  $('.dateSelect').fdatetimepicker({
    format: 'mm/dd/yyyy H:ii p'
  }); 

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

  $(".day-alert").parent().addClass("day-alert")
  $(".day-normal").parent().addClass("day-normal")

  $('.comment').click(function(e) {
    e.preventDefault();
    $(this).siblings('.new-comment-area').toggle();
  })

  $('.new-comment').on("click", function(event) {
    var form = $(this).closest(".new-comment-area");
    var data = form.find(":input").serialize();
    var url = form.data().url
    $.post(url, data);
  });

  $('body').on("click", "a.reply", function(event) {
    var form = $(this).closest(".reply-form");
    var data = form.find(":input").serialize();
    var url = form.data().url;
    $.post(url, data);
  });

  $('.remove-user').click(function(event) {
    event.preventDefault()
    $(this).closest('tr').empty()
  })
  
  $(document).on('opened.fndtn.reveal', '#new-first-aid-station[data-reveal]', function () {
    console.log("open!!")
  });
});
