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

4. Build and run:
```bash
podman-compose up -d
```

### On your local machine

Launch a browser configured to use the proxy:
```bash
./scripts/launch-browser.sh your-remote-server.com
```

Or configure manually:
- HTTP Proxy: `your-remote-server.com:61234`

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
