$(function() {
  $('.dateSelect').fdatepicker({
    format: 'mm/dd/yyyy'
  }); 

  $('#all_plans tbody tr').css('cursor', 'pointer')
  $('#all_plans tbody tr').click(function() {
    window.location = $('a', $(this)).attr('href')
  }) 
});