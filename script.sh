#!/bin/sh
## DD-WRT firmware download: https://dd-wrt.com/support/other-downloads/?path=betas%2F
## Executing script: "sh /tmp/.rc_startup"
## Cron command: "0 4 * * * root /bin/sh /tmp/.rc_startup"
currentTime=$(date +%H:%M:%S)
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" | tee -a /var/log/messages
echo "SCRIPT STARTED @ $currentTime" | tee -a /var/log/messages
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" | tee -a /var/log/messages

## LED lights control
echo "%%%%% Running LEDs script" | tee -a /var/log/messages
for i in 2 3 8 9 10; do gpio enable $i ; done
for i in 11 12 13; do gpio disable $i ; done
et robowr 0x0 0x18 0x1ff
et robowr 0x0 0x18 0x0
et robowr 0x0 0x1a 0x0

## Ads blocking
echo "%%%%% Running ads blocking script" | tee -a /var/log/messages
rm -r /tmp/adhosts
mkdir /tmp/adhosts

(cd /tmp/adhosts && curl -o mvps.txt https://winhelp2002.mvps.org/hosts.txt)
echo "addn-hosts=/tmp/adhosts/mvps.txt" >> /tmp/dnsmasq.conf

(cd /tmp/adhosts && curl -o my_hosts.txt https://raw.githubusercontent.com/kennethshsu/DDWRT/master/my_hosts.txt)
echo "addn-hosts=/tmp/adhosts/my_hosts.txt" >> /tmp/dnsmasq.conf

killall dnsmasq
dnsmasq --conf-file=/tmp/dnsmasq.conf

## Ping Google and Google Ads
echo "%%%%% Running ping tests" | tee -a /var/log/messages
ping -c 5 www.google.com | tee -a /var/log/messages
ping -c 5 www.googleadservices.com | tee -a /var/log/messages

## Speedtests
echo "%%%%% Running speed tests" | tee -a /var/log/messages
speedtest_cli 1 1 1 1 | tee -a /var/log/messages

## Restart cron
echo "%%%%% Restarting cron" | tee -a /var/log/messages
stopservice cron && startservice cron

currentTime=$(date +%H:%M:%S)
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" | tee -a /var/log/messages
echo "SCRIPT ENDED @ $currentTime" | tee -a /var/log/messages
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" | tee -a /var/log/messages
