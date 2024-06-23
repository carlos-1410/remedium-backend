# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_240_619_123_902) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'action_text_rich_texts', force: :cascade do |t|
    t.string 'name', null: false
    t.text 'body'
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[record_type record_id name], name: 'index_action_text_rich_texts_uniqueness', unique: true
  end

  create_table 'active_storage_attachments', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.bigint 'blob_id', null: false
    t.datetime 'created_at', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness',
                                                    unique: true
  end

  create_table 'active_storage_blobs', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'filename', null: false
    t.string 'content_type'
    t.text 'metadata'
    t.string 'service_name', null: false
    t.bigint 'byte_size', null: false
    t.string 'checksum'
    t.datetime 'created_at', null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'active_storage_variant_records', force: :cascade do |t|
    t.bigint 'blob_id', null: false
    t.string 'variation_digest', null: false
    t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
  end

  create_table 'banner_items', force: :cascade do |t|
    t.bigint 'banner_id'
    t.string 'url'
    t.string 'image'
    t.integer 'clicks_counter'
    t.integer 'views_counter'
    t.boolean 'for_logged'
    t.datetime 'date_from'
    t.datetime 'date_to'
    t.boolean 'is_active'
    t.string 'url_target'
    t.integer 'position'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['banner_id'], name: 'index_banner_items_on_banner_id'
    t.index ['id'], name: 'index_banner_items_on_id'
  end

  create_table 'banners', force: :cascade do |t|
    t.string 'code'
    t.integer 'banners_count'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'categories_posts', id: false, force: :cascade do |t|
    t.integer 'category_id', null: false
    t.integer 'post_id', null: false
    t.index %w[category_id post_id], name: 'index_categories_posts_on_category_id_and_post_id'
  end

  create_table 'categories_uploads', id: false, force: :cascade do |t|
    t.integer 'category_id', null: false
    t.integer 'upload_id', null: false
    t.index %w[category_id upload_id], name: 'index_categories_uploads_on_category_id_and_upload_id'
  end

  create_table 'contact_requests', force: :cascade do |t|
    t.string 'name'
    t.string 'email'
    t.string 'subject'
    t.text 'message'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'events', force: :cascade do |t|
    t.integer 'event_type'
    t.datetime 'date'
    t.string 'title'
    t.string 'slug'
    t.string 'venue'
    t.string 'location'
    t.text 'desc'
    t.text 'link'
    t.string 'external_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['slug'], name: 'index_events_on_slug', unique: true
  end

  create_table 'galleries', force: :cascade do |t|
    t.boolean 'categorization'
    t.string 'code', null: false
    t.string 'name'
    t.string 'slug'
    t.integer 'default_width'
    t.integer 'default_height'
    t.integer 'default_thumb_width'
    t.integer 'default_thumb_height'
    t.integer 'watermark_font_size'
    t.string 'watermark_font_family'
    t.string 'watermark_font_color'
    t.string 'watermark_text'
    t.oid 'watermark_image'
    t.boolean 'included_in_sitemap', default: true, null: false
    t.boolean 'hidden', default: false, null: false
    t.datetime 'visible_from'
    t.datetime 'visible_to'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'menu_items', force: :cascade do |t|
    t.integer 'data_type', null: false
    t.string 'code'
    t.string 'extra_attributes'
    t.string 'fa_icon'
    t.string 'resource_type'
    t.integer 'resource_id'
    t.boolean 'included_in_sitemap', default: true, null: false
    t.boolean 'hidden', default: false, null: false
    t.datetime 'visible_from'
    t.datetime 'visible_to'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'posts', force: :cascade do |t|
    t.string 'title'
    t.text 'body'
    t.string 'tags', array: true
    t.string 'meta_tags', default: [], array: true
    t.string 'slug'
    t.boolean 'archived'
    t.boolean 'included_in_sitemap', default: true, null: false
    t.boolean 'hidden', default: false, null: false
    t.datetime 'visible_from'
    t.datetime 'visible_to'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['slug'], name: 'index_posts_on_slug', unique: true
  end

  create_table 'sategories', force: :cascade do |t|
    t.string 'code'
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'settings', force: :cascade do |t|
    t.string 'ga_tracking_id'
    t.string 'contact_email', null: false
    t.string 'contact_phone'
    t.string 'facebook_url'
    t.string 'instagram_url'
    t.string 'youtube_url'
    t.string 'meta_title', null: false
    t.string 'meta_tags', null: false
    t.text 'meta_description', null: false
  end

  create_table 'uploads', force: :cascade do |t|
    t.integer 'category_id'
    t.string 'title'
    t.text 'description'
    t.string 'slug'
    t.boolean 'hidden'
    t.bigint 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['slug'], name: 'index_uploads_on_slug', unique: true
    t.index ['user_id'], name: 'index_uploads_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.string 'first_name'
    t.string 'last_name'
    t.boolean 'admin', default: false, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'active_storage_variant_records', 'active_storage_blobs', column: 'blob_id'
end
