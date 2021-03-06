#!/usr/bin/env ruby
require 'rinit'

extend Rinit

# app_name      This is a startup script for use in /etc/init.d
#
# description:  This will start, stop, and restart foo daemon

# this is an example of using ruby for a init script

APP_NAME = "Foodaemon"
PIDFILE = "/tmp/#{APP_NAME}.pid"
PATH = File.expand_path File.dirname(__FILE__)
DAEMON = File.join(PATH, "foo_daemon.rb")
USER = ENV["USER"]

case ARGV.first
when "status"
  puts "#{APP_NAME} is #{Rinit.status(PIDFILE) ? "running" : "stopped"}"
when "start"
  result = Rinit.start(cmd: DAEMON, 
                       chuid: USER,
                       pidfile: PIDFILE)
 
  puts "#{APP_NAME} has started" unless result.nil?
when "stop"
  Rinit.stop(PIDFILE)
  puts "#{APP_NAME} is stopped"
when "restart"
  puts "#{APP_NAME} is restarting..."
  Rinit.restart(PIDFILE, cmd: DAEMON,
                         chuid: USER,
                         pidfile: PIDFILE)
end

unless %w{start stop restart status}.include? ARGV.first
  puts "Usage: #{APP_NAME} {start|stop|restart}"
  exit
end

