#!/usr/bin/perl
##
##  ping_checker   - 	Check the availability of an IP-target using icmp;
##			if target is not reachable, execute a given command
##
##  Copyright (c) 2016 Daniel Friedlmaier <daniel@friedlmaier.net>
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

use Net::Ping;
use Data::Validate::IP;
use warnings;

my $TARGET=shift;
my $TIMEOUT=int(shift);
my $INTERVAL=int(shift);
my $INTERVAL_FAILED=int(shift);
my $FAILED_MAX=int(shift);
my $COMMAND=shift;
my $failed=0;

#check if $TARGET is a valid IP
my $validate = Data::Validate::IP->new;

if(!($validate->is_ipv4($TARGET))){
	print "given target is not a valid IP!\n\n";
	exit 0;
}

logit("start ping_checker");
sleep $INTERVAL;
while (1>0){

	if(ping_target($TARGET, $TIMEOUT)){
		#target reached
		sleep $INTERVAL;
	}else {
		#target not reached
		logit("target not reached!!!!!!");
		$failed++;
		sleep $INTERVAL_FAILED;
	}

	if ($failed == $FAILED_MAX){
		#maximum failed couter reached -> perform given command and reset failed counter
		logit("max failed counter - execute command...");
		`$COMMAND`;
		logit("command executed, reset failed-counter to 0");
		$failed=0;
		logit("sleep original interval");
		sleep $INTERVAL;
	}
}

sub logit{
	#log given message to system log (e.g. /var/log/messages )
	my $MESSAGE = shift;
	`/usr/bin/logger -i -s -t ping_checker $MESSAGE `;
}

sub ping_target{
	#ping function
	$func = Net::Ping->new("icmp");
	$result = $func->ping(shift, shift);
	if ($result){
		return 1;
	} else {
		return 0;
	}
}
