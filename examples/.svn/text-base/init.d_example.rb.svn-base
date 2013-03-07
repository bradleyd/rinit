#!/usr/bin/env ruby
require 'rinitd/rinitd'
include RInitd
# app_name      This is a startup script for use in /etc/init.d
#
# description:  This will control the start,stop,restart of srcipt/server in gannon
#include the ruby init_d libs
#this is an example of using ruby for a init.d script for a rails server
APP_NAME = 'What ever you like'
PIDFILE = "/var/run/#{APP_NAME}.pid"
PATH = "path to executable"
DAEMON = "#{PATH}/server"
USER = "user to run exexcutable as"

case ARGV.first
    when 'status':
           pid=RInitd.get_pid(PIDFILE).to_i
           status=RInitd.status(pid)
    	   puts "#{APP_NAME} is #{status}"
    when 'start':
                RInitd.start :cmd => "#{DAEMON}", 
                  :chuid => USER,
                  :pidfile => PIDFILE
                 puts "#{APP_NAME} is started"
                
    when 'stop':
                RInitd.stop(PIDFILE)
                puts "#{APP_NAME} is stopped"
    when 'restart':
                puts "#{APP_NAME} is stopping..."
		RInitd.stop(PIDFILE)
                sleep 1#for good measure
                puts "#{APP_NAME} is starting..."
                RInitd.start :cmd => "#{DAEMON}",
                  :pidfile => PIDFILE	
                                       
end

unless %w{start stop restart status}.include? ARGV.first
        puts "Usage: #{APP_NAME} {start|stop|restart}"
        exit
end

