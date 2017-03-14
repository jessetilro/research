$(document).ready(function(){
  console.log('Loaded');

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
      $spinner.height($spinner.parent().height());
      $spinner.show();

    },
    stop: function() {
      $panel.addClass('panel-default');
      $panel.removeClass('panel-info');
      $spinner.hide();
    }
  }

  console.log('Initialised variables.');

  $input.on('keyup', function() {
    console.log('Key up, resetting timer.');
    clearTimeout(typingTimer);
    typingTimer = setInterval(refreshPreview, typingInterval);
    loadingAnimation.start();
    });

  $input.on('keydown', function() {
    console.log('Key down, killing timer.');
    clearTimeout(typingTimer);
    });

  function refreshPreview() {
    console.log('Refreshing preview.');
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
