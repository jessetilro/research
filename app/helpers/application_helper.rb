module ApplicationHelper

  def glyphicon icon
    content_tag(:span, '', class: "glyphicon glyphicon-#{icon}")
  end

end
