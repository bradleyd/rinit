require 'sys/proctable'
require "fileutils"

module Rinit
  class << self
    include Sys

    # @param  opts [Hash] opts :cmd, :chuid, :pidfile
    # @return [nil]
    # @example
    #   {cmd: "/tmp/foo_daemon.rb", chuid: "foo", pidfile: "/tmp/foo.pid"}
    #
    def start(opts={})
      command = opts.fetch(:cmd) { raise Rinit::CommandException, "No command given" }
      user    = opts.fetch(:chuid) { raise Rinit::CommandException, "No user given" }
      pidfile = opts.fetch(:pidfile) { raise Rinit::CommandException, "No pidfile was given" }
      
      # @todo this needs to be changed to sys
      start_stop_daemon = "start-stop-daemon --start --chuid #{user} --exec #{command}"
      pipe = IO.popen(start_stop_daemon, "r")
      write_pidfile(pipe.pid, pidfile)
    end

    # @param pidfile [String] the full pidfile path
    # @return [nil] if there were not any errors
    def stop(pidfile)
      pid = get_pid_from_file(pidfile)
      kill_process(pid)
      pidfile_cleanup(pidfile)
    end

    # @param pidfile [String] the full pidfile path
    # @return process_status [String] Started or Stopped
    def status pidfile
      pid = get_pid_from_file(pidfile)
      process_status = "stopped"
      ProcTable.ps{ |p|
        if p.pid == pid
          process_status = "running"
        end
      }
      process_status
    end

    # @param pidfile [String] the full pidfile path
    # @param opts [Hash] see #start
    # @return process_status [String] Started or Stopped
    # @example
    #   "/tmp/foo.pid", {cmd: "/tmp/foo_daemon.rb", chuid: "foo", pidfile: "/tmp/foo.pid"}
    def restart(pidfile, opts={})
      stop(pidfile)
      start(opts)
    end

    private
    # @private 
    def get_pid_from_file(filename)
      begin
        pid = IO.readlines(filename)
      rescue Errno::ENOENT => e
        puts e.message
        puts "Are you sure it is running?"
        exit 1
      end
      pid[0].to_i
    end

    # @private 
    def pidfile_cleanup pidfile
      begin
        FileUtils.rm(pidfile)
      rescue Errno::ENOENT => e
        puts e.message
        exit 1
      end
    end  
    
    # @private 
    def kill_process(pid)
      begin
        Process.kill(9,pid)
      rescue Errno::ESRCH => e
        puts e.message
        puts "The pid file may not have been cleaned up properly."
        exit 1
      end
    end
   
    # @private 
    def write_pidfile(pid, pidfile)
      File.open(pidfile, 'w') { |f| f.write(pid) }
    end
  end
end
