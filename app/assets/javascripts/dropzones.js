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
    init: function() {
      var myDropzone = this;

      this.element.querySelector("[type=submit]").addEventListener("click", function(e) {
        e.preventDefault();
        e.stopPropagation();
        if (myDropzone.files.length) {
          myDropzone.processQueue();
        } else {
          $('#new-source-drop').submit();
        }
      });

      this.on("addedfile", function() {
        var message = this.element.querySelector('.dz-message');
        if (message !== null) {
          message.parentNode.removeChild(message);
        }
      });
      this.on("success", function(files, response) {
        Turbolinks.visit(window.location);
      });
    }
  });

  $("#update-source-drop").dropzone({
    autoProcessQueue: true,
    uploadMultiple: false,
    parallelUploads: 100,
    maxFiles: 1,
    thumbnailWidth: 80,
    thumbnailHeight: 80,
    addRemoveLinks: true,
    previewsContainer: '#preview',
    clickable: '#preview',
    hiddenInputContainer: '#preview',
    paramName: 'source[document]',
    init: function() {
      var myDropzone = this;

      this.on("addedfile", function() {
        var message = this.element.querySelector('.dz-message');
        if (message !== null) {
          message.parentNode.removeChild(message);
        }
      });
      this.on("success", function(files, response) {
        Turbolinks.visit(window.location);
      });
    }
  });
});
