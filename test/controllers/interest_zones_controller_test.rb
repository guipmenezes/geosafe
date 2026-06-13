# frozen_string_literal: true

require 'test_helper'

class InterestZonesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get interest_zones_index_url
    assert_response :success
  end
end
