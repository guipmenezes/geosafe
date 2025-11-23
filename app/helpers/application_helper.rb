# frozen_string_literal: true

module ApplicationHelper
  def nav_link_class(path)
    current_page?(path) ? 'text-blue-500 font-bold' : ''
  end
end
