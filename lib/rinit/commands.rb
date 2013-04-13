require 'sys/proctable'

module Rinit
  class << self
    include Sys

    def get_pid_from_file(filename)
      begin
        pid = IO.readlines(filename).first
      rescue Errno::ENONET => e
        raise "File: #{filename} does not exist"
      end
      pid.to_i
    end

    # start the ruby daemon
    # @param  opts [Hash] opts :cmd, :chuid, :pidfile
    # #return [nil]
    def start(opts={})
      command = opts.fetch(:cmd) { raise Rinit::CommandException, "No command given" }
      user    = opts.fetch(:chuid) { raise Rinit::CommandException, "No user given" }

      pidfile  = opts.fetch(:pidfile) { raise Rinit::CommandException, "No pidfile was given" }

      start_stop_daemon = "start-stop-daemon --start --chuid #{user} --exec #{command}"
      pipe = IO.popen(start_stop_daemon, "r")
      "Started" if write_pidfile(pipe.pid, pidfile)
    end

    def stop(pidfile)
      pid = get_pid_from_file(pidfile)
      kill_process(pid)
    end

    def status ppid
      status = "stopped"
      ProcTable.ps{ |p|
        if p.pid == ppid
          status = "running"
        end
      }
      status
    end

    def restart

    end

    private
    def pidfile_cleanup pidfile
      begin
        FileUtils.rm(pidfile)
      rescue Errno::ENOENT => e
        puts "File: #{pidfile} does not exist, are you sure it is running?\n" + e
      end
    end  
    
    def kill_process(pid)
      Process.kill(9,pid) 
    end

    def write_pidfile(pid, pidfile)
      File.open(pidfile, 'w') { |f| f.write(pid) }
    end
  end
end
