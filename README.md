# Rinit

Rinit is a `init-like` script witten in ruby.  

### This only works for Debian based systems currently.

## Installation

Add this line to your application's Gemfile:

    gem 'rinit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rinit

## Usage

Let's say you have a daemon script called `foodaemon.rb`.  
You want to be able to `start, stop, restart, and get the status` of said daemon.  
Better yet, you need a pid file so you can use monit to monitor the process.  
Create a file in `/etc/init.d/` (or where ever you like).  Name it what you want and make sure it is executable.

### your awesome damon script
```ruby
loop do
  puts "I am a daemon...and I loop loop loop and I loop loop loop!"
  sleep 10
end
```

### a init script to control said awesomeness

```ruby
#!/usr/bin/env ruby
require 'rinit'

extend Rinit
# app_name      This is a startup script for use in /etc/init.d
#
# description:  This will start, stop, and restart foo daemon

# this is an example of using ruby for a init script

APP_NAME = "foodaemon"
PIDFILE = "/tmp/#{APP_NAME}.pid"
PATH = "/home/bradleyd/Projects/rinit/test/"
DAEMON = "#{PATH}/foo_daemon.rb"
USER = ENV["USER"]

case ARGV.first
when 'status'
  puts "#{APP_NAME} is #{Rinit.status(PIDFILE)}"
when 'start'
  result = Rinit.start :cmd => "#{DAEMON}", 
                       :chuid => USER,
                       :pidfile => PIDFILE

  puts "#{APP_NAME} is started" unless result.nil?
when 'stop'
  Rinit.stop(PIDFILE)
  puts "#{APP_NAME} is stopped" 
when 'restart'
  puts "#{APP_NAME} is restarting..."
  Rinit.restart(PIDFILE, :cmd => "#{DAEMON}",
                         :chuid => USER,
                         :pidfile => PIDFILE)
end

unless %w{start stop restart status}.include? ARGV.first
  puts "Usage: #{APP_NAME} {start|stop|restart}"
  exit
end
```

Then you can do this

```bash
./foo status
foo is stoppped
```

```bash
./foo start
foo is running
```
You get the idea...

### Simple Template Builder

`rinit` also has a simple template builder.  For example,
to generate a init script to be used in `init.d/` one could do this

* only monit and init templates are supported as of now

```ruby
    -t, --template type              generator for init template
    -n, --daemon-name name           name of the dameon
    -h, --help                       Show this message
```

```ruby
rinit -t init -n foobar
```

This will create a file in the current directory where you ran `rinit`

* your milage may vary
 
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
