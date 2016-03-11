#!/usr/bin/ruby
# $ ./ping_checker 192.168.1.1 2 20 1 3 '/etc/init.d/ipsec restart'

##
##  ping_checker   - 	Check the availability of an IP-target using icmp;
##			if target is not reachable, execute a given command
##
##  Copyright (c) 2016 Michael Peter <michaeljohannpeter@gmail.com
##
##  Permission is hereby granted, free of charge, to any person obtaining
##  a copy of this software and associated documentation files (the
##  "Software"), to deal in the Software without restriction, including
##  without limitation the rights to use, copy, modify, merge, publish,
##  distribute, sublicense, and/or sell copies of the Software, and to
##  permit persons to whom the Software is furnished to do so, subject to
##  the following conditions:
##
##  The above copyright notice and this permission notice shall be included
##  in all copies or substantial portions of the Software.
##
##  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
##  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
##  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
##  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
##  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
##  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
##  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
##

require 'trollop'
require 'ipaddress'
require 'net/ping'

def logit (message)
  #log given message to system log (e.g. /var/log/messages )
  system("/usr/bin/logger -i -s -t ping_checker #{message}")
end

def ping_target(target, ping_timeout)
  # ping function
  p = Net::Ping::TCP.new(target, ping_timeout)
  if p.ping?
    return true
  else
    return false
  end
end


$opts = Trollop::options do
  version "ping_checker 0.2 (c) 2016 Michael Peter"
  banner <<-EOS
Description:
With ping_checker it is possible to check a target's (IP-address) availability. If the target is not reachable, a given command will be executed.

Call:
ping_checker TARGET PING_TIMEOUT PING_INTERVAL PING_INTERVAL_FAILED PING_FAILED_MAX COMMAND

Requirements:
 - gem install trollop, ipaddress, net-ping
 - /usr/bin/logger for logging mechanism

Usage:
EOS

  opt :target, "valid IPv4 address", :type => :string
  opt :ping_timeout, "a numeric tiemout for icmp-request", :type => :int
  opt :ping_interval, "check availability of target ping_interval in seconds", :type => :int
  opt :ping_interval_failed, "if one ping-request fails, check target availability more frequently", :type => :int
  opt :ping_max_failed, "count ammount of failed ping-request", :type => :int
  opt :command, "execute command if ping_max_failed ping-requests failed", :type => :string
end

target = $opts[:target]
ping_timeout = $opts[:ping_timeout]
ping_interval = $opts[:ping_interval]
ping_interval_failed = $opts[:ping_interval_failed]
ping_max_failed = $opts[:ping_max_failed]
command = $opts[:command]
failed=0

if not IPAddress.valid? target
  puts "#{target} is not a valid IPv4 address!\n"
  exit()
end

logit "start ping_checker\n"
# puts target
# puts ping_timeout
# puts ping_interval
# puts ping_interval_failed
# puts ping_max_failed
# puts command
sleep(ping_interval)

while true
  if ping_target(target, ping_timeout)
    # target reached
    sleep(ping_interval)
  else
    # target not reached
    puts "target not reached"
    logit "#{target} not reached!"
    failed+=1
    sleep(ping_interval_failed)
  end

  if failed == ping_max_failed
    puts "max reached"
    # maximum failed counter reached -> perform given command
    logit "max failed counter - executing #{command}\n"
    system("#{command}")
    logit "command executed, resetting failed counter to zero"
    failed = 0
    logit "sleeping normal #{ping_interval} seconds"
    sleep(ping_interval)
  end
end
