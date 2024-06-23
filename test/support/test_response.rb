module TestResponse
  # Parse JSON response body
  #
  # @return [Hash] Parsed JSON
  def json
    MultiJson.load(body, symbolize_keys: true)
  end
end

ActionDispatch::TestResponse.include(TestResponse)
