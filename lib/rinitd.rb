#!/usr/bin/ruby
##need to install sys-proctable for this to work correctly

require 'rubygems'
require 'sys/proctable'
require 'fileutils'


module RInitd
  include Sys

  def self.get_pid(file)
    begin
      pid=IO.readlines(file).first
    rescue Errno::ENOENT => e
      print "File does not exist \n TRACE: #{e}\n"
    end
    return pid if pid
  end

  def self.status(ppid)
    status="stopped"
    ProcTable.ps{ |p|
      if p.pid == ppid
        status = "running"
      end
    }
    return status
  end
 
  ##needs better exception handling if cmd does not exist 
  def self.start(options)
    if ! options.key?(:cmd) && options.key?(:pidfile) 
      raise "need to pass hash in init.d script--{ :cmd => command, :chuid => user, :pidfile => pidfile }" 
    end
    #grab paramters to start process and write pidfile
    command=options[:cmd]
    user=options[:chuid]
    pdfile=options[:pidfile] 
    #start and write
    #TODO: use sys-start-stop-daemon source
    ssd="start-stop-daemon --start --chuid #{user} --exec #{command}"
    pipe = IO.popen(ssd, "r")
    File.open(pdfile, 'w') { |f| f.write(pipe.pid) }
  end
  
  
  def self.stop(pidfile)
    begin
      pid=self.get_pid(pidfile)
      Process.kill(9,pid.to_i) 
    rescue Errno::ENOENT => e
      print "File: #{pidfile} does not exist, are you sure it is running?\n" + e
    end
    #remove pidfile for cleanup
    begin
      FileUtils.rm(pidfile)
    rescue Errno::ENOENT => e
     print "File: #{pidfile} does not exist, are you sure it is running?\n" + e
    end

  end

   
end

