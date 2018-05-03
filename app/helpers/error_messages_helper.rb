# frozen_string_literal: true

module ErrorMessagesHelper
  def error_messages!(object)
    return '' unless error_messages?(object)

    err = object.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    html = <<-HTML
    <ul>#{err}</ul>
    HTML

    html.html_safe # rubocop:disable Rails/OutputSafety
  end

  def error_messages?(object)
    !object.errors.empty?
  end
end
