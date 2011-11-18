require 'fileutils'

class TestRepo < Test::Unit::TestCase
  FIXTURE_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures'))
  DB_PATH = "#{FIXTURE_PATH}/#{File.basename(__FILE__)}.git"

  def setup
    @db = Ark::Repo.connect(path=DB_PATH)
  end

  def teardown
    FileUtils.remove_dir(DB_PATH, true)
  end

  # We're not testing Grit here.
  # Just testing our usage of it

  def test_connect
    assert_equal(true, File.directory?(DB_PATH))
    assert_equal(true, File.exist?("#{DB_PATH}/HEAD"))
  end

  def test_empty_keys
    assert_equal([], @db.keys)
  end

  def test_set_get
    c = @db.set("test_key", "my_val")
    assert_equal(false, c.nil?)
  end

  def test_get
    test_key = "test_key2"
    test_val = "my_val2"
    @db.set(test_key, test_val)
    assert_equal(test_val, @db.get(test_key))
  end

  def test_set_with_message
    test_key = "test_key3"
    test_val = "test_val3"
    log_message = "test key3 committed"
    c = @db.set(test_key, test_val, log_message)
    assert_equal(false, c.nil?)
    assert_equal(log_message, @db.log(test_key).first['message'])
  end

  def test_delete
    test_key = "test_key4"
    test_val = "my_val4"
    c = @db.set(test_key, test_val)
    d = @db.delete(test_key)
    g = @db.get(test_key)
    assert_equal(false, c.nil?)
    assert_equal(false, d.nil?)
    assert_equal(true, g.nil?)
  end

  def test_populated_keys
    5.times do |i|
      test_key = "test_key#{i}"
      test_val = "my_val#{i}"
      @db.set(test_key, test_val)
    end
    keys = @db.keys
    5.times do |i|
      assert_equal(true, keys.member?("test_key#{i}"))
    end
  end

  def test_inspect
    format = %Q{#<Ark::Repo "path=#{DB_PATH}/">}
    assert_equal(format, @db.inspect)
  end
end