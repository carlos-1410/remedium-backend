module Common
  class PaginationAttributes
    attr_reader :collection

    def initialize(collection)
      @collection = collection
    end

    def call
      { current_page:, next_page:, prev_page:, total_pages:, total_count: }
    end

    private

    def current_page
      collection.respond_to?(:current_page) ? collection.current_page : 1
    end

    def next_page
      collection.next_page if collection.respond_to?(:next_page)
    end

    def prev_page
      collection.prev_page if collection.respond_to?(:prev_page)
    end

    def total_pages
      collection.respond_to?(:total_pages) ? collection.total_pages : 1
    end

    def total_count
      collection.respond_to?(:total_count) ? collection.total_count : collection.count
    end
  end
end
