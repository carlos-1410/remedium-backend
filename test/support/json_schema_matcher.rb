require "json-schema"

module Minitest
  module Assertions
    def assert_json_schema_match(schema, json, strict: true, validate_schema: true)
      error_message = json_schema_match schema, json, strict, validate_schema
      assert_nil error_message, error_message
    end

    def refute_json_schema_match(schema, json, strict: false, validate_schema: true)
      error_message = json_schema_match schema, json, strict, validate_schema
      assert_not error_message.nil?, "Expected #{json} to not match with #{schema} schema"
    end

    private

    def json_schema_match(
      schema,
      json,
      strict,
      validate_schema,
      schema_directory = File.join(Dir.pwd, "test", "support", "json_schemas")
    )
      schema = File.join schema_directory, "#{schema}.json"

      error_message = nil
      begin
        JSON::Validator.validate!(schema, json, strict:, validate_schema:)
      rescue JSON::Schema::ValidationError
        error_message = $ERROR_INFO.message
      end
      error_message
    end
  end
end
