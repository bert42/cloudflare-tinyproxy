# cloudflare-tinyproxy

A containerized HTTP proxy service to allow local browser access through a remote server, bypassing Cloudflare's browser verification.

## Quick Start

### On the remote server

1. Clone and configure:
```bash
cp tinyproxy.conf.example tinyproxy.conf
cp podman-compose.example.yml podman-compose.yml
```

2. Find your local machine's public IP:
```bash
# On your local machine
./scripts/show-my-ip.sh
```

3. Edit `tinyproxy.conf` and add your IP to the Allow list:
```
Allow YOUR.PUBLIC.IP.HERE
```

4. Build and run (use host networking to avoid podman network issues):
```bash
podman build -t cloudflare-tinyproxy .
podman run -d --name cloudflare-tinyproxy --network=host \
  -v ./tinyproxy.conf:/etc/tinyproxy/tinyproxy.conf:ro \
  cloudflare-tinyproxy:latest
```

5. Open firewall for your IP:
```bash
# Replace YOUR.PUBLIC.IP with your actual IP from show-my-ip.sh
iptables -I INPUT -p tcp -s YOUR.PUBLIC.IP --dport 61234 -j ACCEPT

# Or with firewalld
firewall-cmd --add-rich-rule='rule family="ipv4" source address="YOUR.PUBLIC.IP" port port="61234" protocol="tcp" accept'
```

### On your local machine

Launch a browser configured to use the proxy:
```bash
./scripts/launch-browser.sh your-remote-server.com
```

Or configure manually:
- HTTP Proxy: `your-remote-server.com:61234`

## Extracting Cookies for CLI Tools

After passing Cloudflare verification in the browser, you can extract cookies for use with CLI tools (like curl or custom applications).

**Chrome:**
1. Press F12 (DevTools)
2. Go to **Application** tab
3. Left sidebar → **Cookies** → select the site (e.g., `https://chaturbate.com`)
4. Find `cf_clearance` row → copy the **Value**
5. Also copy `sessionid` if you need authenticated access

**Firefox:**
1. Press F12 (DevTools)
2. Go to **Storage** tab
3. Left sidebar → **Cookies** → select the site
4. Find `cf_clearance` → copy the value

**Important:** The `cf_clearance` cookie is bound to:
- The **IP address** (must match the server IP)
- The **User-Agent** string (must match exactly when using the cookie)

Cookies expire after a few hours and need to be refreshed when you start getting 403 errors again.

## Files

- `Containerfile` - Container image definition
- `tinyproxy.conf.example` - Example proxy configuration
- `podman-compose.example.yml` - Example compose file
- `scripts/show-my-ip.sh` - Display your public IP
- `scripts/launch-browser.sh` - Launch browser with proxy settings

## Security Notes

- Only allowed IPs can connect (configured in tinyproxy.conf)
- Consider using a firewall to restrict port 61234 access
- For additional security, consider adding basic authentication or running behind a VPN

## Testing

Test the proxy with curl:
```bash
curl -x http://your-server:61234 https://ifconfig.me
```
