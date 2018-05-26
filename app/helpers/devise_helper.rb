# frozen_string_literal: true

module DeviseHelper
  def devise_error_messages! # rubocop:disable Metrics/MethodLength
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
      <button type="button" class="close" data-dismiss="alert">
        <span aria-hidden="true">&times;</span>
      </button>
      <strong>
       #{pluralize(resource.errors.count, 'error')} must be fixed
      </strong>
      #{messages}
    </div>
    HTML

    html.html_safe # rubocop:disable Rails/OutputSafety
  end

  def devise_error_messages?
    !resource.errors.empty?
  end
end
