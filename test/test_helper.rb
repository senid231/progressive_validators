$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'progressive_validators'
require 'active_record'

database_name = ENV.fetch('PG_DATABASE_NAME') { 'progressive_validators_test' }
ActiveRecord::Base.establish_connection(adapter: 'postgresql', database: database_name)

ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Migration.verbose = true

ActiveRecord::Schema.define do
  # Add your schema here
  create_table :products, force: true do |t|
    t.string :name
    t.integer :qty
    t.integer :qty_two, limit: 2
    t.integer :qty_four, limit: 4
    t.integer :qty_eight, limit: 8
    t.decimal :price
    t.decimal :price_precised, precision: 8
    t.decimal :price_scaled, precision: 6, scale: 3
  end
end

class Product < ActiveRecord::Base
  self.table_name = 'products'
  validates_with ProgressiveValidators::DecimalOverflowValidator, message: 'decimal overflow'
  validates_with ProgressiveValidators::IntegerOverflowValidator, message: 'integer overflow'
end

require 'minitest/autorun'
