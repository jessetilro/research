$(document).on('turbolinks:load', function() {
  $('.enter-submit').keydown(function (event) {
    var keypressed = event.keyCode || event.which;
    if (keypressed == 13) {
      event.preventDefault();
      $(this).closest('form').submit();
    }
  });

  $('.change-submit').change(function (event) {
    $(this).closest('form').submit();
  });
});
