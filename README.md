# Mac OS Packer Filter (pf ) port forwarder

This sh script sets up Packet Filter rules and redirects all outgoing TCP traffic on port 80 and 443 to the defined proxy server.  

You also need to have root permission to run the `pfctl` command.

## Usage

```
usage: ./turn_pf_on.sh [-ld] [file...]
	 -f <file> - loads the given pf.conf file from the specific location
	 -d (default) - it creates a pf_custom.conf file and loads it with the default forwarding rules
```

You also have to make the file executable:

`chmod u+x turn_pf_on.sh`

## Example:

`./turn_pf_on.sh -f /tmp/custom_pf_file.conf`

or

`./turn_pf_on.sh -d`

The default Packet filter rules are:

`rdr pass on $INTERFACE inet proto tcp to any port {80, 443} -> $PROXY_HOST port $PROXY_PORT`

Feel free to modify the PROXY parameters / variables as you need.
   
## Output

```
[+] Enabling IPv4 and IPv6 forwarding...

Password:
net.inet.ip.forwarding: 0 -> 1
net.inet6.ip6.forwarding: 0 -> 1

[+] Creating and loading Packer Filter config file...

pfctl: Use of -f option, could result in flushing of rules
present in the main ruleset added by the system at startup.
See /etc/pf.conf for further details.

No ALTQ support in kernel
ALTQ related functions disabled

[+] Turning ON Packet Filter...
...
...

TRANSLATION RULES:
rdr pass on en0 inet proto tcp from any to any port = 80 -> 127.0.0.1 port 8088
rdr pass on en0 inet proto tcp from any to any port = 443 -> 127.0.0.1 port 8088

...
...
```
You can see the applied firewall rules under the "TRANSLATION RULES" section.

# To flush all the rules issue the following command:

`sudo pfctl -F all`
