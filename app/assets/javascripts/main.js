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

  $("body").on("click", ".new-comment", function(event) {
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

  var updatePermitterContactInfo = function() {
    var activePermitterId = $("#plan_permitter_id").val();
    $(".permitter").hide();
    $("[data-permitter-id=" + activePermitterId + "]").show();
  };

  $("body").on("change", "#plan_permitter_id", updatePermitterContactInfo);

  updatePermitterContactInfo();

  // Highlight anchored comment
  if (window.location.hash.indexOf("comment-") != -1) {
    $(window.location.hash).effect("highlight", {}, 5000);       
  }

  $("body").on("click", "#invite", function() {
     var form = $(this).closest(".invitation-form");
     var url = form.data().url;
     var data = form.find(":input").serialize();
     $.post(url, data);
  });

});
