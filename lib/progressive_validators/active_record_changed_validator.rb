require 'active_model/validator'

module ProgressiveValidators
  class ActiveRecordChangedValidator < ActiveModel::Validator
    # example:
    # validates_with DecimalOverflowValidator
    # validates_with DecimalOverflowValidator, message: 'exceeds limit'
    # validates_with DecimalOverflowValidator, message: proc { |column, value| "#{value} is out of range" }
    def validate(record)
      return unless validator_allowable?(record)

      record.changed.each do |attribute|
        validate_changed_attribute(record, attribute) if not_skipped?(attribute)
      end
    end

    def validator_allowable?(record)
      record.class.respond_to?(:columns_hash)
    end

    def custom_options
      [:skip]
    end

    def error_options
      options.except(*custom_options)
    end

    def validate_changed_attribute(_record, _attribute)
      raise NotImplementedError, '#validate_changed_attribute must be defined'
    end

    private

    def skipped_attributes
      options.fetch(:skip, [])
    end

    def not_skipped?(attribute)
      !skipped_attributes.include?(attribute)
    end

  end
end
