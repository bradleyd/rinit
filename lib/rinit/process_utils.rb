require "sys/proctable"
require "fileutils"

module Rinit
  module ProcessUtils
    include Sys

    # @private
    def may_the_fork_be_with_you(command, pidfile)
      rd, wr = IO.pipe
      pid = fork do
        rd.close
        begin
          exec(command)
        rescue SystemCallError
          wr.write('!')
          exit 1
        end
      end
      wr.close
      command_result = if rd.eof?
                         write_pidfile(pid, pidfile)
                       else
                         nil
                       end
    end

    # @private 
    def get_pid_from_file(filename)
      begin
        pid = IO.readlines(filename)
      rescue Errno::ENOENT => e
        puts e.message + "---Are you sure it is running?"
        exit 1
      end
      # if the file is there but no pid was written to_i returns 0
      pid.empty? ? -1 : pid[0].to_i
    end

    # @private
    def is_process_running?(pidfile)
      pid = get_pid_from_file(pidfile)
      ProcTable.ps{ |process|
       return true if process.pid == pid
      }
      false
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
    def kill_process(pidfile)
      pid = get_pid_from_file(pidfile)
      # should never be negative unless there is an issue with writing the pid
      return if pid < 0
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
