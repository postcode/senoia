function update_first_aid() {
  var newText = $("<tr>")
  newText.append($('<td><a href="#" class="edit_first_aid">Edit</a>'))
  $('input', '#new-first-aid-station').each(function(i, input) {
    $(input).prop('disabled', true);
    newText.append($('<td>').append($(input)))
  })
  $(".more", "#first_aid_table").parent().prepend(newText)
  $('.reveal-modal').foundation('reveal', 'close');

  $("tr").on("click", ".edit_first_aid", function() {
    $(this).parents("tr").find("input").prop("disabled", false)
  })
}