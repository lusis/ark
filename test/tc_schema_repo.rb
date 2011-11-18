class TestSchemaRepo < Test::Unit::TestCase
  FIXTURE_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures'))
  DB_PATH = "#{FIXTURE_PATH}/#{File.basename(__FILE__)}.git"

  def setup
    @db = Ark::Repo.connect(path=DB_PATH)
  end

  def teardown
    FileUtils.remove_dir(DB_PATH, true)
  end

  def test_save_schema
    json = File.open("#{FIXTURE_PATH}/valid_no_key.json", 'r') {|f| f.read}
    s = Ark::Schema.add(json)
    assert_equal(false,s.nil?)
  end

  def test_load_shortcut_schema
    json = File.open("#{FIXTURE_PATH}/valid_no_key.json", 'r') {|f| f.read}
    s = Ark::Schema.add(json)
    g = Ark::Schema['host'] 
    assert_equal(false, g.nil?)
  end
end