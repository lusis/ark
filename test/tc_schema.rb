class TestSchema < Test::Unit::TestCase
  FIXTURE_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures'))
  FIXTURE_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures'))
  DB_PATH = "#{FIXTURE_PATH}/#{File.basename(__FILE__)}.git"

  def setup
    @db = Ark::Repo.connect(path=DB_PATH)
  end

  def teardown
    FileUtils.remove_dir(DB_PATH, true)
  end

  def test_not_json
    expected_errors = [[:schema, :not_valid_json]]
    json = "foo"
    s = Ark::Schema.new
    s.definition = json
    assert_equal(false, s.valid?, "Schema should be invalid")
    assert_equal(expected_errors, s.errors, "Error should be :not_valid_json")
  end

  def test_valid_no_key_schema
    expected_errors = []
    json = File.open("#{FIXTURE_PATH}/valid_no_key.json", 'r') {|f| f.read}
    s = Ark::Schema.new
    s.definition = json
    assert_equal(true, s.valid?, "Schema should be valid")
    assert_equal(expected_errors, s.errors, "Errors should be empty")
  end

  def test_valid_key_schema
    expected_errors = []
    json = File.open("#{FIXTURE_PATH}/valid_with_key.json", 'r') {|f| f.read}
    s = Ark::Schema.new
    s.definition = json
    assert_equal(true, s.valid?, "Schema should be valid")
    assert_equal(expected_errors, s.errors, "Errors should be empty")
  end

  def test_invalid_schema
    expected_errors = [[:schema, :missing_required_key_id],[:schema, :missing_required_key_attributes],[:id, :not_string]]
    json = File.open("#{FIXTURE_PATH}/invalid.json", 'r') {|f| f.read}
    s = Ark::Schema.new
    s.definition = json
    assert_equal(false, s.valid?, "Schema should be invalid")
    assert_equal(expected_errors, s.errors, "Errors should not be empty")
  end

  def test_missing_attributes
    expected_errors = [[:schema, :missing_required_key_attributes]]
    json = File.open("#{FIXTURE_PATH}/missing_attributes.json", 'r') {|f| f.read}
    s = Ark::Schema.new
    s.definition = json
    assert_equal(false, s.valid?, "Schema should be invalid")
    assert_equal(expected_errors, s.errors, "Error should not be empty")
  end

  def test_invalid_id
    expected_errors = [[:id, :not_string]]
    json = File.open("#{FIXTURE_PATH}/invalid_id.json", 'r') {|f| f.read}
    s = Ark::Schema.new
    s.definition = json
    assert_equal(false, s.valid?, "Schema should be invalid")
    assert_equal(expected_errors, s.errors, "Error should not be empty")
  end

end