require_relative "test_helper"

class RinitCommandsTest < MiniTest::Unit::TestCase

  def setup
    @rinit = Rinit
  end

  def test_that_respond_to_start
    assert_respond_to @rinit, :start
  end
 
  def test_that_respond_to_stop
    assert_respond_to @rinit, :stop
  end

  def test_that_respond_to_status
    assert_respond_to @rinit, :status
  end

  def test_that_respond_to_restart
    assert_respond_to @rinit, :restart
  end

end
