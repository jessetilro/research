$(document).on('turbolinks:load', function(){
  var typingTimer;
  var typingInterval = 500;

  var $input = $('#review-input');
  var $preview = $('#review-preview');
  var $panel = $preview.parent().parent();
  var $spinner = $panel.find('.spinner-container');

  var loadingAnimation = {
    start: function() {
      $panel.removeClass('panel-default');
      $panel.addClass('panel-info');
      $spinner.height($spinner.parent().height() + 2 * parseInt($spinner.parent().css('padding-bottom')));
      $spinner.show();

    },
    stop: function() {
      $panel.addClass('panel-default');
      $panel.removeClass('panel-info');
      $spinner.hide();
    }
  }

  $input.on('keyup', function() {
    clearTimeout(typingTimer);
    typingTimer = setInterval(refreshPreview, typingInterval);
    loadingAnimation.start();
    });

  $input.on('keydown', function() {
    clearTimeout(typingTimer);
    });

  function refreshPreview() {
    clearTimeout(typingTimer);
    $.ajax({
      url: $input.attr('data-url'),
      data: {
        review: {
          comment: $input.val()
        }
      },
      dataType: "script",
      success: loadingAnimation.stop
    });
  }
});
