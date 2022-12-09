class ImageUrlValidator < ActiveModel::EachValidator
  IMAGE_URL_REGEX = /\Ahttps?:\/\/[\S]+\.(gif|jpg|png)\z/

  def validate_each(record, attribute, value)
    record.errors.add attribute, "has invalid Image URL" if value !~ IMAGE_URL_REGEX
  end
end
