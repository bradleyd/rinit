require "sys/proctable"
require "fileutils"

module Rinit
  module ProcessUtils
    include Sys
    # @private 
    def get_pid_from_file(filename)
      begin
        pid = IO.readlines(filename)
      rescue Errno::ENOENT => e
        puts e.message
        exit 1
      end
      pid[0].to_i
    end

    # @private
    def is_process_running?(pid)
      ProcTable.ps{ |p|
        if p.pid == pid
          true
        end
      }
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
