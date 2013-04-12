require_relative "test_helper"
require 'tempfile'

class RinitCommandsTest < MiniTest::Unit::TestCase
  
  extend Rinit::Commands
  def setup
    @rinit = Rinit
    @pidfile = Tempfile.new('tempfile')
    @pidfile.write(1)
    @pidfile.close
  end

  def test_get_pid_from_file
    p Rinit.methods.sort - Object.methods
    pid = get_pid_from_file @pidfile
    assert_equal pid, "1"
  end

end


