class OneLevelNestingValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, "can have only one level of nesting" if record.parent_id? && record.parent.parent_id?
  end
end
