require "open4"
module Rinit
  class << self
    include ProcessUtils

    # @param  opts [Hash] opts :cmd, :chuid, :pidfile
    # @return [nil]
    # @example
    #   {cmd: "/tmp/foo_daemon.rb", chuid: "foo", pidfile: "/tmp/foo.pid"}
    #
    # @todo 
    def start(opts={})
      command = opts.fetch(:cmd) { raise Rinit::CommandException.new "No command given" }
      user    = opts.fetch(:chuid) { raise Rinit::CommandException.new "No user given" }
      pidfile = opts.fetch(:pidfile) { raise Rinit::CommandException.new "No pidfile was given" }
      # @todo this needs to be changed to sys
      start_stop_daemon = "start-stop-daemon --start --chuid #{user} --exec #{command}"
      pipe = IO.popen(start_stop_daemon, "r")
      write_pidfile(pipe.pid, pidfile)
      pipe
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
      is_process_running?(pid) ? true : false
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
  end
end
