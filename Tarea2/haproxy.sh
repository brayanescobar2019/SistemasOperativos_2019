#!/usr/bin/env bash
apt-get update
apt-get install -y haproxy
sudo echo "ENABLED=1" >> /etc/default/haproxy
cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.original
sudo rm /etc/haproxy/haproxy.cfg
sudo echo "global
        log /dev/log   local0
        log 127.0.0.1   local1 notice
        maxconn 4096
        user haproxy
        group haproxy
        daemon

defaults
        log     global
        mode    http
        option  httplog
        option  dontlognull
        retries 3
        option redispatch
        maxconn 2000
        contimeout     5000
        clitimeout     50000
        srvtimeout     50000

listen webfarm
bind 0.0.0.0:80
    mode http
    stats enable
    stats uri /haproxy?stats
    balance roundrobin
    option httpclose
    option forwardfor
    server web01 192.168.200.3:80 check
    server web02 192.168.200.4:80 check" >> /etc/haproxy/haproxy.cfg
sudo service haproxy start
sudo service haproxy restart
