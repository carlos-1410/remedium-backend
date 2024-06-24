# frozen_string_literal: true

class AddCms < ActiveRecord::Migration[7.0]
  def visibility_columns(t)
    t.boolean :included_in_sitemap, null: false, default: true
    t.boolean :hidden, null: false, default: false
    t.datetime :visible_from
    t.datetime :visible_to
  end

  def change
    create_table :settings do |t|
      t.string :ga_tracking_id
      t.string :contact_email, null: false
      t.string :contact_phone
      t.string :facebook_url
      t.string :instagram_url
      t.string :youtube_url
      t.string :meta_title, null: false
      t.string :meta_tags, null: false, array: true
      t.text :meta_description, null: false
    end

    create_table :banner_items do |t|
      t.belongs_to :banner
      t.string   :url
      t.string   :image
      t.integer  :clicks_counter
      t.integer  :views_counter
      t.boolean  :for_logged
      t.datetime :date_from
      t.datetime :date_to
      t.boolean  :is_active
      t.string   :url_target
      t.integer  :position
      t.timestamps
    end
    add_index :banner_items, :id

    create_table :banners do |t|
      t.string   :code
      t.integer  :banners_count
      t.timestamps
    end

    create_table :sategories do |t|
      t.string :code
      t.string :name
      t.timestamps
    end

    create_table :posts do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.string :tags, array: true
      t.string :meta_tags, array: true, default: []
      t.string :slug
      t.boolean :archived
      visibility_columns(t)
      t.timestamps
    end
    add_index :posts, :slug, unique: true

    create_table :categories_posts, id: false do |t|
      t.integer :category_id, null: false
      t.integer :post_id, null: false
    end
    add_index :categories_posts, %i[category_id post_id]

    create_table :galleries do |t|
      t.boolean :categorization
      t.string :code, null: false
      t.string :name
      t.string :slug
      t.integer :default_width
      t.integer :default_height
      t.integer :default_thumb_width
      t.integer :default_thumb_height
      t.integer :watermark_font_size
      t.string :watermark_font_family
      t.string :watermark_font_color
      t.string :watermark_text
      t.column :watermark_image, :oid
      visibility_columns(t)
      t.timestamps
    end

    create_table :events do |t|
      t.integer :event_type
      t.datetime :date
      t.string :title
      t.string :slug
      t.string :venue
      t.string :location
      t.text :desc
      t.text :link
      t.string :external_id
      t.timestamps
    end
    add_index :events, :slug, unique: true

    create_table :contact_requests do |t|
      t.string :name
      t.string :email
      t.string :subject
      t.text :message
      t.timestamps null: false
    end

    create_table :uploads do |t|
      t.integer :category_id
      t.string :title
      t.text :description
      t.string :slug
      t.boolean :hidden
      t.belongs_to :user
      t.timestamps
    end
    add_index :uploads, :slug, unique: true

    create_table :categories_uploads, id: false do |t|
      t.integer :category_id, null: false
      t.integer :upload_id, null: false
    end
    add_index :categories_uploads, %i[category_id upload_id]

    create_table :menu_items do |t|
      t.integer :data_type, null: false
      t.string :code
      t.string :extra_attributes
      t.string :fa_icon
      t.string :resource_type
      t.integer :resource_id
      visibility_columns(t)
      t.timestamps
    end
  end
end
