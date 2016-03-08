# ping_checker

With ping_checker it is possible to check a targets (IP-address) availability. If the target is not reachable, a given command will be executed.

Usage
-----
ping_checker TARGET PING_TIMEOUT PING_INTERVAL PING_INTERVAL_FAILED PING_FAILED_MAX COMMAND

- **TARGET**
  valid IPv4 address
- **PING_TIMEOUT**
  a nummeric timeout for icmp-request
- **PING_INTERVAL**
  check availability of TARGET PING_INTERVAL seconds
- **PING_INTERVAL_FAILED**
  if one ping-request fails, check TARGET availability more frequently
- **PING_FAILED_MAX**
  count amount of failed ping-requests
- **COMMAND**
  execute COMMAND if PING_FAILED_MAX ping-requests failed

Example
--------
`$ ./ping_checker 192.168.1.1 2 20 1 3 '/etc/init.d/ipsec restart'`

Crontab
-------
` @reboot /etc/scripts/ping_checker 192.168.1.1 2 20 1 3 '/etc/init.d/ipsec restart'`



Licensing
---------
Copyright (c) 2016 Daniel Friedlmaier &lt;daniel@friedlmaier.net&gt;

Author
------
Daniel Friedlmaier<br/>
[http://www.friedlmaier.net](http://www.friedlmaier.net)<br/>
[daniel@friedlmaier.net](mailto:daniel@friedlmaier.net)<br/>
