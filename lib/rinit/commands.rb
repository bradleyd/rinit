require "open4"
require "shelltastic"
module Rinit
  class << self
    include ProcessUtils

    # @param  opts [Hash] opts :cmd, :chuid, :pidfile
    # @return [nil]
    # @example
    #   {cmd: "/tmp/foo_daemon.rb", chuid: "foo", pidfile: "/tmp/foo.pid"}
    #
    def start(opts={})
      command = opts.fetch(:cmd) { raise Rinit::CommandException.new "No command given" }
      user    = opts.fetch(:chuid) { raise Rinit::CommandException.new "No user given" }
      pidfile = opts.fetch(:pidfile) { raise Rinit::CommandException.new "No pidfile was given" }
      may_the_fork_be_with_you(command, pidfile)
    end

    # @param pidfile [String] the full pidfile path
    # @return [nil] if there were not any errors
    def stop(pidfile)
      kill_process(pidfile)
      pidfile_cleanup(pidfile)
    end

    # @param pidfile [String] the full pidfile path
    # @return process_status [String] Started or Stopped
    def status pidfile
      is_process_running?(pidfile)
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
