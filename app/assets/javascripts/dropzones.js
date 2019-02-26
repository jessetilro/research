$(document).on('turbolinks:load', function() {
  $("#new-source-drop").dropzone({
    autoProcessQueue: false,
    uploadMultiple: false,
    parallelUploads: 100,
    maxFiles: 1,
    thumbnailWidth: 80,
    thumbnailHeight: 80,
    addRemoveLinks: true,
    previewsContainer: '#preview',
    clickable: '#preview',
    hiddenInputContainer: '#preview',
    paramName: 'source_drop[document]',
    dictDefaultMessage: "Drop a PDF file here or click to select one",
    // The setting up of the dropzone
    init: function() {
      var myDropzone = this;

      // First change the button to actually tell Dropzone to process the queue.
      this.element.querySelector("[type=submit]").addEventListener("click", function(e) {
        // Make sure that the form isn't actually being sent.
        e.preventDefault();
        e.stopPropagation();
        if (myDropzone.files.length) {
          myDropzone.processQueue(); // upload files and submit the form
        } else {
          $('#new-source-drop').submit(); // submit the form
        }
      });

      // Listen to the sendingmultiple event. In this case, it's the sendingmultiple event instead
      // of the sending event because uploadMultiple is set to true.
      this.on("addedfile", function() {
        // Gets triggered when the form is actually being sent.
        // Hide the success button or the complete form.
        var message = this.element.querySelector('.dz-message');
        if (message !== null) {
          message.parentNode.removeChild(message);
        }
      });
      this.on("success", function(files, response) {
        // Gets triggered when the files have successfully been sent.
        // Redirect user or notify of success.
        Turbolinks.visit(window.location);
      });
      this.on("error", function(files, response) {
        // Gets triggered when there was an error sending the files.
        // Maybe show form again, and notify user of error
      });
    }
  });
});
