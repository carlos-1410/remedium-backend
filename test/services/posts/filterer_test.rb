require "test_helper"

module Posts
  class FiltererTest < ActiveSupport::TestCase
    test "all filters" do
      expected = create(:post)
      _unexpected = create(:post)

      posts = Filterer.call(
        ids: [expected.id],
        title: expected.title,
        archived: expected.archived,
        created_at: expected.created_at
      )

      assert_equal 1, posts.size
      assert_equal expected, posts.first
    end

    test "filter by id" do
      expected_post = create(:post)
      _unexpected_post = create(:post)

      posts = Filterer.call(
        ids: expected_post.id
      )

      assert_equal 1, posts.size
      assert_equal expected_post.id, posts.first.id
    end

    test "filter by id as array" do
      expected_post_one, expected_post_two, _unexpected_post = create_list(:post, 3)

      posts = Filterer.call(
        ids: [expected_post_one.id, expected_post_two.id]
      )

      assert_equal 2, posts.size
      assert_includes posts.pluck(:id), expected_post_one.id
      assert_includes posts.pluck(:id), expected_post_two.id
    end

    test "filter by tags" do
      expected_post = create(:post)
      _unexpected_post = create(:post, tags: [])

      posts = Filterer.call(
        tags: ["example"]
      )

      assert_equal 1, posts.size
      assert_equal expected_post.id, posts.first.id
    end

    test "filter by meta_tags" do
      expected_post = create(:post)
      _unexpected_post = create(:post, meta_tags: [])

      posts = Filterer.call(
        meta_tags: ["tag1"]
      )

      assert_equal 1, posts.size
      assert_equal expected_post.id, posts.first.id
    end

    test "filter by title" do
      expected_post = create(:post)
      _unexpected_post = create(:post)

      posts = Filterer.call(
        title: expected_post.title[10..15]
      )

      assert_equal 1, posts.size
      assert_equal expected_post.id, posts.first.id
    end

    test "filter by visible_from_gte" do
      expected_post = create(:post, visible_from: "2023-02-01")
      unexpected_post = create(:post, visible_from: "2022-01-01")

      posts = Filterer.call(
        visible_from_gte: "2023-02-01"
      )

      assert_equal 1, posts.size
      assert_includes posts, expected_post
      assert_not_includes posts, unexpected_post
    end

    test "filter by visible_from_lte" do
      expected_post = create(:post, visible_from: "2022-01-01")
      unexpected_post = create(:post, visible_from: "2023-01-01")

      posts = Filterer.call(
        visible_from_lte: "2022-02-01"
      )

      assert_equal 1, posts.size
      assert_includes posts, expected_post
      assert_not_includes posts, unexpected_post
    end

    test "filter by visible_to_gte" do
      expected_post = create(:post, visible_to: "2023-02-01")
      unexpected_post = create(:post, visible_to: "2022-01-01")

      posts = Filterer.call(
        visible_to_gte: "2023-02-01"
      )

      assert_equal 1, posts.size
      assert_includes posts, expected_post
      assert_not_includes posts, unexpected_post
    end

    test "filter by visible_to_lte" do
      expected_post = create(:post, visible_to: "2022-01-01")
      unexpected_post = create(:post, visible_to: "2023-01-01")

      posts = Filterer.call(
        visible_to_lte: "2022-02-01"
      )

      assert_equal 1, posts.size
      assert_includes posts, expected_post
      assert_not_includes posts, unexpected_post
    end

    test "filter by created_at_gte" do
      expected_post = create(:post, created_at: "2023-02-01")
      unexpected_post = create(:post, created_at: "2022-01-01")

      posts = Filterer.call(
        created_at_gte: "2023-01-01"
      )

      assert_equal 1, posts.size
      assert_includes posts, expected_post
      assert_not_includes posts, unexpected_post
    end

    test "filter by created_at_lte" do
      expected_post = create(:post, created_at: "2022-01-01")
      unexpected_post = create(:post, created_at: "2023-01-01")

      posts = Filterer.call(
        created_at_lte: "2022-02-01"
      )

      assert_equal 1, posts.size
      assert_includes posts, expected_post
      assert_not_includes posts, unexpected_post
    end

    test "order by order column" do
      post1 = create(:post, created_at: "2000-01-01")
      post2 = create(:post, created_at: "2000-01-02")

      collection = Filterer.call(
        order_column: "created_at",
        order_direction: "desc"
      )

      assert_equal [post2, post1], collection
    end

    test "pagination with default order" do
      post1, post2 = create_pair(:post)

      posts_page_one = Filterer.call(page: 1, per_page: 1)
      posts_page_two = Filterer.call(page: 2, per_page: 1)

      posts_default_per_page = Filterer.call

      assert_equal 1, posts_page_one.size
      assert_equal 1, posts_page_two.size
      assert_equal post2, posts_page_one.first
      assert_equal post1, posts_page_two.first

      assert_equal 2, posts_default_per_page.size
    end

    test "has default pagination values" do
      assert Filterer.const_get(:DEFAULT_PAGE)
      assert Filterer.const_get(:DEFAULT_PER_PAGE)
    end

    test "has default order values" do
      assert Filterer.const_get(:DEFAULT_ORDER_COLUMN)
      assert Filterer.const_get(:DEFAULT_ORDER_DIRECTION)
      assert Filterer.const_get(:ORDER_COLUMN_WHITELIST)
      assert Filterer.const_get(:ORDER_DIRECTION_WHITELIST)
    end
  end
end
