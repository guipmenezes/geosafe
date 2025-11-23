# frozen_string_literal: true

module Icon
  class IconComponent < ViewComponent::Base
    def initialize(name:, classes: '', size: 'md')
      super
      @name = name
      @classes = classes
      @size = size
    end

    def component_size
      {
        'sm' => 'w-10 h-10',
        'md' => 'w-20 h-20',
        'lg' => 'w-24 h-24'
      }[@size]
    end
  end
end
