$(document).on('turbolinks:load', function () {
  $('[data-toggle="popover"]').popover();

  $('input.selectize').each(function() {
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

  $('select.selectize').selectize();

  $('select.submit').on('change', function(){
    $(this).closest('form').submit();
  });
});
