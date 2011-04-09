class EmailFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value =~ /.+\@.+\..+/
      object.errors[attribute] << (options[:message] || "is not a valid email")
    end
  end
end
