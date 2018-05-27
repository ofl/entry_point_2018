# frozen_string_literal: true

module ErrorMessagesHelper
  def error_messages!(object)
    return '' unless object.errors.any?

    err = object.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    html = <<-HTML
    <div class="alert alert-danger">
      <a href="#" class="close" data-dismiss="alert">×</a>
      <ul>#{err}</ul>
    </div>
    HTML

    html.html_safe # rubocop:disable Rails/OutputSafety
  end
end
