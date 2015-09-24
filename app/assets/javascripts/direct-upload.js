window.initDirectUpload = function(url, formData, host) {
  $(function() {
    $('form, .js-form').find('input:file').each(function(i, elem) {
      var barContainer, fileInput, form, progressBar, submitButton;

      fileInput = $(elem);
      form = $(fileInput.closest('form, .js-form'));

      submitButton = form.find('input[type="submit"], .js-submit');
      progressBar = $('<span class="meter" style="width: 0%"></div>');
      barContainer = $('<div class="progress success" style="display: none"></div>').append(progressBar);
      fileInput.after(barContainer);
      
      fileInput.fileupload({
        fileInput: fileInput,
        url: url,
        type: 'POST',
        autoUpload: true,
        formData: formData,
        paramName: 'file',
        dataType: 'XML',
        replaceFileInput: false,
        
        progressall: function(e, data) {
          var progress;
          progress = parseInt(data.loaded / data.total * 100, 10);
          progressBar.css('width', progress + '%');
        },
        
        start: function(e) {
          fileInput.hide();
          barContainer.show();
          submitButton.prop('disabled', true);
          submitButton.addClass('disabled');
        },
        
        done: function(e, data) {
          var input, key;
          submitButton.prop('disabled', false);
          submitButton.removeClass('disabled');
          key = $(data.jqXHR.responseXML).find('Key').text();
          url = ('https://' + host + '/') + key;
          input = $('<input />', {
            type: 'hidden',
            name: fileInput.attr('name'),
            value: url
          });
          form.append(input);
          fileInput.remove();
        },
        
        fail: function(e, data) {
          submitButton.prop('disabled', false);
          progressBar.text('Upload failed');
        }
      });
    });
  });
};
