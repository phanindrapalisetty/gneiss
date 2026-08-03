# docs/10-networking.md

# Network Configuration

| Property | Value |
|----------|-------|
| Status | Complete |
| Project | Gneiss |
| Last Updated | 2026-08-04 |

---

# Purpose

Provide a stable and predictable network configuration for Gneiss.

All services are exposed using a single reserved IP address assigned by the home router through DHCP reservation.

---

# Prerequisites

- Debian 13 installed
- Wi-Fi configured
- Router administrative access

---

# Background

Gneiss uses DHCP with a router-side reservation instead of configuring a static IP inside Debian.

Benefits:

- Centralized IP management
- No IP conflicts
- Easier recovery after OS reinstall
- Works well with home networks

---

# Network Information

Hostname

```
gneiss
```

Interface

```
wlp2s0
```

MAC Address

```
b4:6b:fc:79:73:7c
```

Reserved IP

```
192.168.1.9
```

Gateway

```
192.168.1.1
```

DNS

Router default

---

# Network Architecture

```
Internet
    │
    ▼
ISP
    │
    ▼
Home Router
    │
    ├── DHCP Reservation
    │      │
    │      ▼
    │   Gneiss
    │   MAC: b4:6b:fc:79:73:7c
    │   IP : 192.168.1.9
    │
    ├── MacBook
    ├── Android TV
    ├── Mobile Devices
    └── Other Clients
```

---

# Implementation

## Determine MAC Address

```bash
ip link
```

Wireless interface:

```
wlp2s0
```

MAC:

```
b4:6b:fc:79:73:7c
```

---

## Configure DHCP Reservation

Configure the router:

| Parameter | Value |
|----------|-------|
| Hostname | Gneiss |
| MAC Address | b4:6b:fc:79:73:7c |
| Reserved IP | 192.168.1.9 |

---

## Renew Lease

```bash
sudo systemctl restart NetworkManager
```

---

# Verification

Check IP:

```bash
hostname -I
```

Verify SSH:

```bash
ssh gneiss
```

Verify connectivity:

```bash
ping google.com
```

---

# Troubleshooting

## Incorrect IP Address

Verify:

- Router DHCP reservation
- Correct MAC address
- DHCP lease renewal

---

## Unable to Reach Server

Verify:

- Same Wi-Fi network
- Router status
- Firewall configuration

---

# Rollback

Remove the DHCP reservation from the router.

Restart the network connection.

## Design Decision

Gneiss uses **DHCP Reservation** instead of a manually configured static IP.

Reasons:

- Centralized network management through the router.
- Simplifies Debian configuration.
- Reduces the risk of IP conflicts.
- Easier to migrate to new hardware or reinstall the operating system.

## Moving to a New Network

When moving Gneiss to a new home:

1. Connect Gneiss to the new Wi-Fi or Ethernet.
2. Log in to the new router.
3. Create a DHCP reservation using:
   - MAC Address: `B4:6B:FC:79:73:7C`
   - Preferred IP: use `.9` if available on the new subnet (for example, `192.168.0.9` if the new router uses `192.168.0.x`).
4. Verify:

```bash
hostname -I
```

No changes are required on Debian or Docker unless you intentionally choose a different hostname.

---

# Next Steps

Deploy Homepage using Docker Compose.


## Known Issue: mDNS / Bonjour Discovery

### Summary

The hostname `gneiss.local` is not discoverable from a macOS 26.5.2 client despite Avahi being correctly configured and advertising services.

### Environment

| Component | Version |
|----------|---------|
| OS | Debian 13 (Trixie) |
| Avahi | 0.8 |
| Docker | 29.7.1 |
| Client | macOS 26.5.2 |
| Connection | Wi-Fi |

### Symptoms

On macOS:

```bash
ping gneiss.local
```

returns:

```text
Unknown host
```

Similarly:

```bash
dns-sd -Q gneiss.local A
dns-sd -B _http._tcp
dns-sd -B _smb._tcp
```

do not discover Gneiss.

### Investigation

Verified:

- ✅ Static hostname is `gneiss`
- ✅ Avahi daemon is running
- ✅ Avahi advertises only on `wlp2s0`
- ✅ Docker interface (`docker0`) excluded
- ✅ `avahi-publish` successfully registers services
- ✅ `avahi-browse` locally discovers published services
- ✅ Packet capture confirms mDNS advertisements are transmitted from `192.168.1.9`
- ✅ macOS receives mDNS advertisements from other devices (Android TV)

### Current Conclusion

This appears to be an interoperability issue between the current macOS release and Avahi (or another platform-specific mDNS behavior), rather than a configuration issue on Gneiss.

### Impact

None.

SSH, VS Code Remote, Docker, CasaOS, and all planned services function normally using:

- SSH alias (`ssh gneiss`)
- Static IP (`192.168.1.9`)

### Future Plan

Do not rely on `.local` for service discovery.

The homelab will instead use a reverse proxy with local DNS, providing URLs such as:

- `https://home.gneiss`
- `https://jellyfin.gneiss`
- `https://immich.gneiss`
- `https://grafana.gneiss`

This supersedes Bonjour-based discovery and provides a consistent experience across operating systems.