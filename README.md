
# DD-WRT Router Script
This script allows routers running DD-WRT firmwares to block ads network-wide. It also tracks and updates the host list(s) periodically through a cron job, as well as disable those annoying LED lights.

The router that I am using is **Netgear R7000P**, running **DD-WRT v3.0-r46069 std (03/17/21)** build. 

## Setup

 1. The router must already be running the compatible [DD-WRT
    firmware](https://dd-wrt.com). [Here](https://wiki.dd-wrt.com/wiki/index.php/Supported_Devices) is a list of compatible routers.
    
 2. Go to your router's landing page (usually [192.168.1.1](http://192.168.1.1/)). 
    
 3. Navigate: Administration > Commands Paste in the script.sh script in the Command Shell, and click Save Startup.
    
 4. Navigate: Administration > Management > Cron.
 5. Enable Cron.
 6. Paste in ```0 * * * * root /bin/sh /tmp/.rc_startup```.

## Updating Adhost Lists

Replace your ad hostlist under this line:

```bash
curl -k -o /jffs/adhosts.txt https://winhelp2002.mvps.org/hosts.txt
grep addn-hosts /tmp/dnsmasq.conf || echo "addn-hosts=/jffs/adhosts.txt" >> /tmp/dnsmasq.conf
```
If you have multiple host lists:
```bash
curl -k -o /jffs/adhosts1.txt https://adhost1.com/hosts.txt
curl -k -o /jffs/adhosts2.txt https://adhost2.com/hosts.txt
grep addn-hosts /tmp/dnsmasq.conf || echo "addn-hosts=/jffs/adhosts1.txt" >> /tmp/dnsmasq.conf
grep addn-hosts /tmp/dnsmasq.conf || echo "addn-hosts=/jffs/adhosts2.txt" >> /tmp/dnsmasq.conf
```

There is a [list](https://github.com/StevenBlack/hosts) of well known host lists consolidated by Steven that you can try.

## Changing Refresh Intervals
Cron job is customisizble:

 1. Learn about the cron interval setup, or use https://crontab.guru.
 2. Paste in the 5 time variables under Additional Cron Jobs.
 3. For example, ```0 * * * * root /bin/sh /tmp/.rc_startup``` runs the job at the top of every hour.

## Are Ads Coming Through?
Check your log:
 1. Navigate: Status > Syslog
 2. Look for ``` --- www.googleadservices.com ping statistics --- ``` 
 3. Hopfully the result is something like
```
--- www.googleadservices.com statistics ---
5 packets transmitted, 5 packets received, 0% packet loss
round-trip min/avg/max = 7.292/7.324/7.384 ms
PING www.googleadservices.com (0.0.0.0): 56 data bytes
64 bytes from 127.0.0.1: seq=0 ttl=64 time=0.260 ms
64 bytes from 127.0.0.1: seq=1 ttl=64 time=0.317 ms
64 bytes from 127.0.0.1: seq=2 ttl=64 time=0.240 ms
64 bytes from 127.0.0.1: seq=3 ttl=64 time=0.257 ms
64 bytes from 127.0.0.1: seq=4 ttl=64 time=0.250 ms
```
 4. If the IP pinged is not 127.0.0.1, 0.0.0.0, or something similar, ads are not currently being blocked.

Remember, this method of adblock only work for blocking DNS-based ads. If an ad is served on a non-known ad server, it will come through.

## License
[MIT](https://choosealicense.com/licenses/mit/)
