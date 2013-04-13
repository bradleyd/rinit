require_relative "test_helper"
require 'tempfile'
require 'sys/proctable'

class RinitCommandsTest < MiniTest::Unit::TestCase
  extend Rinit
  include Sys

  def setup
    @rinit = Rinit
    @pidfile = Tempfile.new('tempfile')
    @pidfile.write(1)
    @pidfile.close
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

  def test_status_should_be_stopped
    ProcTable.expects(:ps).returns("stopped")   
    assert_equal @rinit.status(1), "stopped"  
  end

  def test_that_respond_to_restart
    assert_respond_to @rinit, :restart
  end

  def test_get_pid_from_file
    pid = Rinit.get_pid_from_file @pidfile
    assert_equal pid, "1"
  end


end
