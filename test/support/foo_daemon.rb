#!/usr/bin/env ruby
# encoding: utf-8

loop do 
 File.open("/tmp/looper", "a+") { |f| f.write "loop de do!!" }
 sleep 30
 exit
end
