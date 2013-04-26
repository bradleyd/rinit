require_relative "test_helper"
require 'tempfile'
require 'sys/proctable'
require "ostruct"

class RinitCommandsTest < MiniTest::Unit::TestCase
  extend Rinit
  include Sys

  DAEMON = File.join(File.expand_path(File.dirname(__FILE__)), "support", "foo_daemon.rb")
  USER   = ENV["USER"]

  def setup
    @rinit = Rinit
    @pidfile = Tempfile.new("foo.pid")
    @pidfile.rewind
  end

  def teardown
    #@pidfile.unlink
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
  
  def test_should_start_daemon_and_stop_daemon
    assert(@rinit.start(:cmd => DAEMON, 
                        :chuid => USER, 
                        :pidfile => @pidfile.path))

    assert(@rinit.status(@pidfile.path))
    assert(@rinit.stop(@pidfile.path))
  end

  def test_status_should_be_stopped
    refute(@rinit.status(@pidfile.path))  
  end

end
