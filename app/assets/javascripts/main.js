
window.senoia = {};

window.senoia.initDatepickers = function() {
  $('.dateTimeSelect').fdatetimepicker({
    format: 'mm/dd/yyyy H:ii p'
  }); 

  $('.dateSelect').fdatepicker({
    format: 'mm/dd/yyyy'
  });
}

$(function() {

  $('.tabs').on('toggled', function (event, tab) {
    var map = $(tab).closest(".asset_map")
    console.log($(tab));
    reloadMap($(tab).find(".asset_map").attr("id"))
  });

  $('.time-input').timepicker();
  $('.command-list').hide()
  $('.communication-form').hide()

  $('.communication-toggle').click( function(e){
    $(this).next('.communication-form').toggle()
  })

  $("body").delegate('.dateSelect', 'hide', function(event) {
    if ($("#operation_period_start_date").val().length > 0 && $("#operation_period_start_date").val().length > 0) {
      $(".save-operation-period").prop("disabled", false)
                                 .removeClass("disabled");
    } else {
      $(".save-operation-period").prop("disabled", true)
                                 .addClass("disabled");
    }
  });

  senoia.initDatepickers();

  $(".show-resolved-comments").click( function(event) {
    event.preventDefault();
    $(this).closest(".existing-comments").find(".resolved-comments").toggle()
  })
  
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

  $("body").on("click", '.comment', function() {
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

  var assets = ["first-aid-station", "mobile-team", "transport", "dispatch"];

  $.each(assets, function(index, asset) {
    var button = ".save-" + asset
    console.log(button)
    $(button).prop("disabled", true)
    $("body").on("click", button, function(event) {
      var formElement = "." + asset + "-form"
      console.log(formElement)
      var form = $(this).closest(formElement);
      var data = form.find(":input").serialize();
      var url = form.data().url
      $.post(url, data);
    });
  })

  $.each(assets, function(index, asset) {
    var button = ".update-" + asset
    $("body").on("click", button, function(event) {
      var formElement = "." + asset + "-form"
      var form = $(this).closest(formElement);
      var data = form.find(":input").serialize();
      var url = form.data().url
      $.ajax({
        method: "PUT",
        url: url,
        data: data,
        success: document.location.reload(true)
      });
    });
  })

  $.each(assets, function(index, asset) {
    var select = "#"+asset+"_provider_id"
    $(select).change( function(event) {
      console.log($(select+" option:selected" ).val())
    });
  })

  $("body").on("click", ".save-operation-period", function(event) {
    if ($(this).hasClass("disabled")) {
        event.preventDefault();
        return;
    } else {
      var form = $(this).closest(".operation-period-form");
      var data = form.find(":input").serialize();
      var url = form.data().url
      $.post(url, data);
    }
  });

  $('.remove-user').click(function(event) {
    event.preventDefault()
    $(this).closest('tr').empty()
  })

  $('.na-check').click( function(e) {
    console.log($(this))
    if($(this, "input:checked")) {
      $(this).siblings().children("input").prop("disabled", true)
    } else {
      $(this).siblings().children("input").prop("disabled", false)
    }
  })

  $('.command-radio').click( function(e) {
    console.log($(this))
    if($(this).val() == "yes") {
      $('.command-list').show()
    } else {
      $('.command-list').hide()
    }
  })
  

  var updatePermitterContactInfo = function() {
    var activePermitterId = $("#plan_permitter_id").val();
    $(".permitter.hidden").hide();
    if(activePermitterId) {
      $("[data-permitter-id=" + activePermitterId + "]").show();
    }
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

  window.senoia.submitForm = function() {
    var form = $(this).closest(".js-form");
    var data = form.find(":input").serialize();
    var url = form.data().url
    var method = "POST";
    if (form.data().method == "PUT") {
      var method = "PUT";
    }
    $.ajax(url, { method: method, data: data });
  }

  $("body").on("click", ".js-form .js-submit", function() {
    senoia.submitForm.apply(this);
  });

  $("body").on("blur", ".js-form .js-submit-on-blur", function() {
    senoia.submitForm.apply(this);
  });
});