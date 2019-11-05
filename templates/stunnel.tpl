pid = /var/run/stunnel/stunnel.pid
debug = 7
delay = yes
options = NO_SSLv3
foreground = yes
setuid = stunnel
setgid = stunnel
[redis-cli]
   client = yes
   accept = 127.0.0.1:6379
   connect = ${redis_host}:${redis_port}
