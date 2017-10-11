require 'test_helper'

class ProgressiveValidatorsTest < Minitest::Test

  def assert_error_with(attribute, value, message)
    record = Product.new
    record[attribute] = value
    refute record.valid?
    assert_equal [attribute], record.errors.messages.keys
    assert_equal [message], record.errors.messages[attribute]
  end

  def refute_error_with(attribute, value)
    record = Product.new
    record[attribute] = value
    assert record.valid?
    assert record.errors.empty?
  end

  def test_that_it_has_a_version_number
    refute_nil ::ProgressiveValidators::VERSION
  end

  def test_integer_without_limit
    refute_error_with :qty, nil
    refute_error_with :qty, 0
    refute_error_with :qty, -2147483648
    refute_error_with :qty, 2147483647

    assert_error_with :qty, -2147483649, 'integer overflow'
    assert_error_with :qty, 2147483648, 'integer overflow'
  end

  def test_integer_with_limit_4
    refute_error_with :qty_four, nil
    refute_error_with :qty_four, 0
    refute_error_with :qty_four, -2147483648
    refute_error_with :qty_four, 2147483647

    assert_error_with :qty_four, -2147483649, 'integer overflow'
    assert_error_with :qty_four, 2147483648, 'integer overflow'
  end

  def test_integer_with_limit_2
    refute_error_with :qty_two, nil
    refute_error_with :qty_two, 0
    refute_error_with :qty_two, -32768
    refute_error_with :qty_two, 32767

    assert_error_with :qty_two, -32769, 'integer overflow'
    assert_error_with :qty_two, 32768, 'integer overflow'
  end

  def test_integer_with_limit_8
    refute_error_with :qty_eight, nil
    refute_error_with :qty_eight, 0
    refute_error_with :qty_eight, -9223372036854775808
    refute_error_with :qty_eight, 9223372036854775807

    assert_error_with :qty_eight, -9223372036854775809, 'integer overflow'
    assert_error_with :qty_eight, 9223372036854775808, 'integer overflow'
  end

  def test_decimal_with_scale_and_precision
    # refute_error_with :price_scaled, nil
    refute_error_with :price_scaled, '0.0'.to_d
    # refute_error_with :price_scaled, '99.999'.to_d
    # refute_error_with :price_scaled, '999.99'.to_d
    # refute_error_with :price_scaled, '999.999'.to_d
    # refute_error_with :price_scaled, '-999.999'.to_d
    #
    # assert_error_with :price_scaled, '9999.999'.to_d, 'decimal overflow'
    # assert_error_with :price_scaled, '-9999.999'.to_d, 'decimal overflow'
    # assert_error_with :price_scaled, '999.9999'.to_d, 'decimal overflow'
    # assert_error_with :price_scaled, '-999.9999'.to_d, 'decimal overflow'
    # assert_error_with :price_scaled, '9999.9999'.to_d, 'decimal overflow'
  end

  def test_decimal_with_precision_and_without_scale
    refute_error_with :price_precised, nil
    refute_error_with :price_precised, '0.0'.to_d
    refute_error_with :price_precised, '99999999'.to_d
    refute_error_with :price_precised, '-99999999'.to_d
    refute_error_with :price_precised, '99999999.999999999999999'.to_d
    refute_error_with :price_precised, '-99999999.999999999999999'.to_d

    assert_error_with :price_precised, '999999999'.to_d, 'decimal overflow'
    assert_error_with :price_precised, '-999999999'.to_d, 'decimal overflow'
    assert_error_with :price_precised, '999999999.9'.to_d, 'decimal overflow'
    assert_error_with :price_precised, '-999999999.9'.to_d, 'decimal overflow'
  end

  def test_decimal_without_scale_and_precision
    refute_error_with :price, nil
    refute_error_with :price, '0.0'.to_d
    refute_error_with :price, "#{'9'*131072}.#{'9'*16383}".to_d
    refute_error_with :price, "-#{'9'*131072}.#{'9'*16383}".to_d
    refute_error_with :price, "0.#{'9'*16383}".to_d
    refute_error_with :price, "-0.#{'9'*16383}".to_d
    refute_error_with :price, "#{'9'*131072}".to_d
    refute_error_with :price, "-#{'9'*131072}".to_d

    assert_error_with :price, "#{'9'*131073}.#{'9'*16383}".to_d, 'decimal overflow'
    assert_error_with :price, "-#{'9'*131073}.#{'9'*16383}".to_d, 'decimal overflow'
    assert_error_with :price, "#{'9'*131072}.#{'9'*16384}".to_d, 'decimal overflow'
    assert_error_with :price, "-#{'9'*131072}.#{'9'*16384}".to_d, 'decimal overflow'
    assert_error_with :price, "0.#{'9'*16384}".to_d, 'decimal overflow'
    assert_error_with :price, "-0.#{'9'*16384}".to_d, 'decimal overflow'
    assert_error_with :price, "#{'9'*131073}".to_d, 'decimal overflow'
    assert_error_with :price, "-#{'9'*131073}".to_d, 'decimal overflow'
  end

end
