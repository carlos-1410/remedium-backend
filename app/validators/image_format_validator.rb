class ImageFormatValidator < ActiveModel::Validator
  def validate(object)
    if (fields = options[:image_fields]).blank?
      raise ArgumentError, "Invalid key, should be :image_fields"
    end

    fields.each do |field|
      image = object.try(field)
      next unless image.attached?
      next if image.blob.content_type.start_with? "image/"

      image.purge_later
      object.errors.add(field, "needs to be an image")
    end
  end
end
