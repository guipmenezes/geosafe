# frozen_string_literal: true

class LogoComponent < ViewComponent::Base
  extend Dry::Initializer

  option :size, optional: true, default: proc { :large }

  def logo_size
    case @size
    when :large
      "text-4xl"
    when :normal
      "text-lg"
    end
  end
end
