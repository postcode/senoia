window.senoia = {};

window.senoia.initDatepickers = function() {
  $('.dateTimeSelect').fdatetimepicker({
    format: 'mm/dd/yyyy H:ii p'
  });

  $('.dateSelect').fdatepicker({
    format: 'mm/dd/yyyy'
  });
  $('.time-input').timepicker();
};

$(function() {
  $('.time-input').timepicker();
  $('.command-list').hide()
  $('.communication-form').hide()
  $(".provider-information").hide()

  $('.communication-toggle').click( function(e){
    $(this).next('.communication-form').toggle()
  })

  // Enable the save button after an operational period date is set
  $("body").delegate('.dateSelect', 'hide', function(event) {
    var $this = $(this);
    if ($this.val().length > 0) {
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
    $(this).parent("div").next(".existing-comments").find(".resolved-comments").toggle()
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
    $("body").on("click", button, function(event) {
      var formElement = "." + asset + "-form";
      var $form = $(this).closest(formElement);
      $form.find('.error').fadeOut();
      var data = $form.find(":input").serialize();
      var url = $form.data().url;

      function error() {
        $form.find('.error').removeClass('hide').fadeIn();
      }

      if ($form.hasClass('new')) {
        $.post(url, data)
          .fail(error);
      } else {
        $.ajax({
          method: "PUT",
          url: url,
          data: data,
          success: document.location.reload(true),
          error: error
        });
      }
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
    });
  })

  $("body").on("click", ".save-operation-period", function(event) {
    if ($(this).hasClass("disabled")) {
        event.preventDefault();
        return;
    } else {
      var form = $(this).closest(".operation-period-form");
      form.find('.error').fadeOut();

      var data = form.find(":input").serialize();
      var url = form.data().url
      var req = $.post(url, data);
      req.error(function() {
        form.find('.error').fadeIn();
      });
      req.done(function() {
        $(document).foundation('tooltip','reflow');
        $(document).foundation().foundation('joyride', 'start', { start_offset: 9 });
      })
    }
  });

  $('.remove-user').click(function(event) {
    event.preventDefault()
    $(this).closest('tr').empty()
  })

  $('.na-check').click( function(e) {
    if($(this, "input:checked")) {
      $(this).siblings().children("input").prop("disabled", true)
    } else {
      $(this).siblings().children("input").prop("disabled", false)
    }
  })

  $('.command-radio').click( function(e) {
    if($(this).val() == "yes") {
      $('.command-list').show()
    } else {
      $('.command-list').hide()
    }
  })

  $('.provider-select').change( function() {
    if ( $("option:selected", this ).text() == "Other" ) {
      $(".provider-information").show()
    } else {
      $(".provider-information").hide()
    }
  })


  var updatePermitterContactInfo = function() {
    var activePermitterId = $("#plan_organization_id").val();
    $(".permitter.hidden").hide();
    if(activePermitterId) {
      $("[data-permitter-id=" + activePermitterId + "]").show();
    }
  };

  $("body").on("change", "#plan_organization_id", updatePermitterContactInfo);

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
