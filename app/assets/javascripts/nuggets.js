$(document).ready(function() {
  $('#nugget_db_props').hide();
  $('#reveal_all_db_props').click(function(event) {
    event.preventDefault();
    $('#nugget_db_props').toggle();
  })
});