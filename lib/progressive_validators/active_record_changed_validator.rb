module ProgressiveValidators
  class ActiveRecordChangedValidator < ActiveModel::Validator
    # example:
    # validates_with DecimalOverflowValidator
    # validates_with DecimalOverflowValidator, message: 'exceeds limit'
    # validates_with DecimalOverflowValidator, message: proc { |column, value| "#{value} is out of range" }
    def validate(record)
      return unless validator_allowable?(record)

      record.changed.each do |changed_attribute|
        validate_changed_attribute(record, changed_attribute)
      end
    end

    def validator_allowable?(record)
      record.class.respond_to?(:columns_hash)
    end

    def validate_changed_attribute(_record, _attribute)
    end

  end
end
