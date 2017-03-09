module ApplicationHelper

  def glyphicon icon
    content_tag(:span, '', class: "glyphicon glyphicon-#{icon}")
  end

  def click_to_select_box text, options={}
    options = {
      class: 'form-control',
      onclick: 'this.setSelectionRange(0, this.value.length)',
      rows: 10
    }.merge options

    content_tag(:textarea, text, options) + content_tag(:small, raw("#{glyphicon 'info-sign'} Click above box to select all contents"))
  end

end
