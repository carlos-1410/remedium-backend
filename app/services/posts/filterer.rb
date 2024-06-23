module Posts
  class Filterer
    include Virtus.value_object

    DEFAULT_PAGE = 1
    DEFAULT_PER_PAGE = 25
    DEFAULT_ORDER_COLUMN = "updated_at".freeze
    DEFAULT_ORDER_DIRECTION = "desc".freeze

    ORDER_COLUMN_WHITELIST = %w(id updated_at created_at visible_from visible_to
                                archived hidden included_in_sitemap).freeze
    ORDER_DIRECTION_WHITELIST = %w(asc desc ASC DESC).freeze

    values do
      attribute :ids, [Integer]
      attribute :title, String
      attribute :body, String
      attribute :tags, [String]
      attribute :meta_tags, [String]
      attribute :archived, Boolean
      attribute :hidden, Boolean
      attribute :included_in_sitemap, Boolean
      attribute :created_at_gte, Date
      attribute :created_at_lte, Date
      attribute :visible_from_gte, Date
      attribute :visible_from_lte, Date
      attribute :visible_to_gte, Date
      attribute :visible_to_lte, Date
      attribute :order_column, String
      attribute :order_direction, String
      attribute :page, Integer
      attribute :per_page, Integer
    end

    def self.call(*, **)
      new(*, **).call
    end

    def call
      apply_id_filter
      apply_title_filter
      apply_body_filter
      apply_tags_filter
      apply_meta_tags_filter
      apply_boolean_filters
      apply_date_filters

      apply_pagination
      apply_order

      scope
    end

    private

    def apply_id_filter
      return if ids.blank?

      @scope = scope.where(id: ids)
    end

    def apply_title_filter
      apply_like_fragment(:title)
    end

    def apply_body_filter
      apply_like_fragment(:body)
    end

    def apply_tags_filter
      apply_array_filter(:tags)
    end

    def apply_meta_tags_filter
      apply_array_filter(:meta_tags)
    end

    def apply_boolean_filters
      apply_boolean_filter(where: { archived: }, key: :archived)
      apply_boolean_filter(where: { hidden: }, key: :hidden)
      apply_boolean_filter(where: { included_in_sitemap: }, key: :included_in_sitemap)
    end

    def apply_date_filters # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      apply_filter(
        where: Post.arel_table[:created_at].gteq(created_at_gte),
        key: :created_at_gte
      )

      apply_filter(
        where: Post.arel_table[:created_at].lteq(created_at_lte),
        key: :created_at_lte
      )

      apply_filter(
        where: Post.arel_table[:visible_from].lteq(visible_from_lte),
        key: :visible_from_lte
      )

      apply_filter(
        where: Post.arel_table[:visible_from].gteq(visible_from_gte),
        key: :visible_from_gte
      )

      apply_filter(
        where: Post.arel_table[:visible_to].lteq(visible_to_lte),
        key: :visible_to_lte
      )

      apply_filter(
        where: Post.arel_table[:visible_to].gteq(visible_to_gte),
        key: :visible_to_gte
      )
    end

    def apply_order
      @scope = scope.order(order_column => order_direction)
    end

    def apply_pagination
      @scope = scope.page(page).per(per_page)
    end

    def apply_filter(where:, key:)
      @scope = attributes[key].present? ? scope.where(where) : scope
    end

    def apply_boolean_filter(where:, key:)
      return if attributes[key].nil?

      @scope = scope.where(where)
    end

    def apply_like_fragment(field)
      return if attributes[field].blank?

      sanitized_where =
        ApplicationRecord.sanitize_sql_array(["posts.#{field} ILIKE ?", "%#{attributes[field]}%"])
      @scope = scope.where(sanitized_where)
    end

    def apply_array_filter(field)
      return if attributes[field].blank?

      sanitized_where =
        ApplicationRecord.sanitize_sql("posts.#{field} && '{#{attributes[field].join(",")}}'")
      @scope = scope.where(sanitized_where)
    end

    def page
      Integer(@page.presence || DEFAULT_PAGE)
    end

    def per_page
      [Integer(@per_page.presence || DEFAULT_PER_PAGE), DEFAULT_PER_PAGE].min
    end

    def order_column
      @order_column.presence_in(ORDER_COLUMN_WHITELIST) || DEFAULT_ORDER_COLUMN
    end

    def order_direction
      @order_direction.presence_in(ORDER_DIRECTION_WHITELIST) || DEFAULT_ORDER_DIRECTION
    end

    def scope
      @scope ||= Post.all
    end
  end
end
