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

  def popover options
    config = {
      text: raw(glyphicon 'question-sign'),
      url: 'javascript:void(0)',
      data: {
        content: '',
        toggle: 'popover',
        trigger: 'hover',
        placement: 'top'
      }
    }

    config = config.deep_merge options if options.is_a? Hash
    config[:data][:content] = options if options.is_a? String

    link_to config[:text], config[:url], config.except(:text, :url)
  end

  def link_to_new_window url, text=nil
    return '' unless url.present?
    link_to (text || raw("#{url} #{glyphicon 'new-window'}")),
        url,
        target: '_blank'
  end

  def tag_tag tag, options={}
    unless options[:type].present?
      content_tag :span, tag.name, options.except(:type).merge({ class: 'label', style: "background-color: #{tag.effective_color}" })
    else
      content_tag :span, tag.name, options.except(:type).merge({ class: "label label-#{options[:type]}" })
    end
  end

end
