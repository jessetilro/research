$(document).on('turbolinks:load', function(){
  $('.minicolors').each(function() {
    var $input = $(this);
    console.debug($input);
    $input.minicolors({
      theme: 'bootstrap'
    });
  });
});
