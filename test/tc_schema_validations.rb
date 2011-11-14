class TestSchemaValidations < Test::Unit::TestCase
  FIXTURE_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures'))

  def test_unknown_validation_type
    expected_errors = [[:foobar, :unknown_validation_type]]
    json = File.open("#{FIXTURE_PATH}/unknown_validation.json", 'r') {|f| f.read}
    s = Ark::Schema.new(json)
    assert_equal(false, s.valid?)
    assert_equal(expected_errors, s.errors)
  end

  def test_members_is_array
    expected_errors = [[:member, :member_must_be_array]]
    json = File.open("#{FIXTURE_PATH}/members_is_array.json", 'r') {|f| f.read}
    s = Ark::Schema.new(json)
    assert_equal(false, s.valid?)
    assert_equal(expected_errors, s.errors)
  end

  def test_required_is_array
    expected_errors = [[:required, :required_must_be_array]]
    json = File.open("#{FIXTURE_PATH}/required_is_array.json", 'r') {|f| f.read}
    s = Ark::Schema.new(json)
    assert_equal(false, s.valid?)
    assert_equal(expected_errors, s.errors)
  end

  def test_unique_is_array
    expected_errors = [[:unique, :unique_must_be_array]]
    json = File.open("#{FIXTURE_PATH}/unique_is_array.json", 'r') {|f| f.read}
    s = Ark::Schema.new(json)
    assert_equal(false, s.valid?)
    assert_equal(expected_errors, s.errors)
  end

  def test_unique_is_attribute
    expected_errors = [[:unique, :unknown_attribute_in_validation]]
    json = File.open("#{FIXTURE_PATH}/unique_is_attribute.json", 'r') {|f| f.read}
    s = Ark::Schema.new(json)
    assert_equal(false, s.valid?)
    assert_equal(expected_errors, s.errors)
  end

  def test_required_is_attribute
    expected_errors = [[:required, :unknown_attribute_in_validation]]
    json = File.open("#{FIXTURE_PATH}/required_is_attribute.json", 'r') {|f| f.read}
    s = Ark::Schema.new(json)
    assert_equal(false, s.valid?)
    assert_equal(expected_errors, s.errors)
  end

  def test_members_is_attribute
    expected_errors = [[:member, :unknown_attribute_in_validation]]
    json = File.open("#{FIXTURE_PATH}/members_is_attribute.json", 'r') {|f| f.read}
    s = Ark::Schema.new(json)
    assert_equal(false, s.valid?)
    assert_equal(expected_errors, s.errors)
  end
end
