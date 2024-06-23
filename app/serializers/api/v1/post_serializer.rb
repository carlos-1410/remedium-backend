module Api
  module V1
    class PostSerializer < ActiveModel::Serializer
      attributes :id, :title, :body, :tags, :meta_tags, :slug, :archived,
        :included_in_sitemap, :hidden, :visible_from, :visible_to, :created_at, :updated_at
    end
  end
end
