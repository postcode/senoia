function update_first_aid() {
  var newText = $("<tr>")
  $('input', '#new-first-aid-station').each(function(i, input) {
    $(input).addClass('disabled')
    newText.append($('<td>').append($(input)))
  })
  $(".more", "#first_aid_table").parent().prepend(newText)
  $('.reveal-modal').foundation('reveal', 'close');
}