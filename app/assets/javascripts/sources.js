$(document).on('turbolinks:load', function () {
  $('[data-toggle="popover"]').popover();

  $('.selectize').each(function() {
    var $input = $(this);
    var options = JSON.parse($input.attr('data-options'));
    var items = JSON.parse($input.attr('data-items'));

    $input.selectize({
      plugins: ['remove_button'],
      delimiter: ',',
      persist: false,
      options: options,
      items: items,
      create: false
    });
  });
});
