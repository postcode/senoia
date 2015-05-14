function update_first_aid() {
  var newText = "<tr>"
  $('input', '#new-first-aid-station').each(function(i, input) {
    $(input).addClass('disabled')
    newText += "<td>"+$(input)+"</td>"
    console.log(input)
  })
  newText += "</tr>"
  console.log($(".more", "#first_aid_table"))
  $(".more", "#first_aid_table").prepend(newText)
  $('.reveal-modal').foundation('reveal', 'close');
}