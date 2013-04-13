require 'sys/proctable'

module Rinit
  class << self
    include Sys

    # start the ruby daemon
    # @param  opts [Hash] opts :cmd, :chuid, :pidfile
    # #return [nil]
    def start(opts={})
      command = opts.fetch(:cmd) { raise Rinit::CommandException, "No command given" }
      user    = opts.fetch(:chuid) { raise Rinit::CommandException, "No user given" }

      pidfile  = opts.fetch(:pidfile) { raise Rinit::CommandException, "No pidfile was given" }

      start_stop_daemon = "start-stop-daemon --start --chuid #{user} --exec #{command}"
      pipe = IO.popen(start_stop_daemon, "r")
      write_pidfile(pipe.pid, pidfile)
    end

    def stop(pidfile)
      pid = get_pid_from_file(pidfile)
      kill_process(pid)
      pidfile_cleanup(pidfile)
    end

    def status pidfile
      pid = get_pid_from_file(pidfile)
      status = "stopped"
      ProcTable.ps{ |p|
        if p.pid == pid
          status = "running"
        end
      }
      status
    end

    def restart
    end

    private

    def get_pid_from_file(filename)
      begin
        pid = IO.readlines(filename)
      rescue Errno::ENONET => e
        raise Rinit::CommandException, "File: #{filename} does not exist, are you sure it is running?"
      end
      pid[0].to_i
    end


    def pidfile_cleanup pidfile
      begin
        FileUtils.rm(pidfile)
      rescue Errno::ENOENT => e
        puts "File: #{pidfile} does not exist, are you sure it is running?\n" + e
      end
    end  
    
    def kill_process(pid)
      begin
        Process.kill(9,pid)
      rescue Errno::ESRCH => e
        raise Rinit::CommandException, "The process with pid #{pid} does not seem to be running. 
                                        The pid file may not have been cleaned up properly."
      end
    end

    def write_pidfile(pid, pidfile)
      File.open(pidfile, 'w') { |f| f.write(pid) }
    end
  end
end
