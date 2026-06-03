# frozen_string_literal: true

require 'browser'

module SessionsHelper
  def session_device_icon(user_agent)
    browser = ::Browser.new(user_agent)
    if browser.device.mobile?
      'M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z'
    elsif browser.device.tablet?
      'M12 18h.01M7 21h10a2 2 0 002-2V5a2 2 0 00-2-2H7a2 2 0 00-2 2v14a2 2 0 002 2z'
    else
      'M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z'
    end
  end

  def session_browser_name(user_agent)
    browser = ::Browser.new(user_agent)
    "#{browser.name} no #{browser.platform.name}"
  end
end
