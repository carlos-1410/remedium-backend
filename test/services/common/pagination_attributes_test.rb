require "test_helper"

module Common
  class PaginationAttributesTest < ActiveSupport::TestCase
    test "uses exact strategy" do
      collection = Post.page(1).per(25)

      attributes = PaginationAttributes.new(collection).call

      expected_attributes = {
        current_page: 1, next_page: nil, prev_page: nil, total_pages: 0, total_count: 0,
      }
      assert_equal expected_attributes, attributes
    end
  end
end
