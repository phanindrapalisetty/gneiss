# Networking

| Property | Value |
|----------|-------|
| Status | Complete |
| Project | Gneiss |
| Last Updated | 2026-08-03 |

---

# Purpose

Configure secure remote administration for Gneiss using SSH.

The objective is to allow administration from the MacBook without requiring a monitor, keyboard or mouse connected to the server.

---

# Prerequisites

- Debian installed
- Git configured
- Gneiss connected to the local network

---

# Background

SSH (Secure Shell) provides encrypted remote access.

Instead of working directly on the laptop, all administration is performed from the MacBook using:

- Terminal
- VS Code Remote SSH
- GitHub

Authentication uses SSH key pairs rather than passwords.

---

# Implementation

## Generate SSH Key (Mac)

Verify existing keys:

```bash
ls ~/.ssh
```

Generate one if required:

```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
```

---

## Configure SSH Client

Edit:

```bash
nano ~/.ssh/config
```

Configuration:

```text
Host gneiss
    HostName 192.168.1.9
    User phanindra
    IdentityFile ~/.ssh/id_ed25519
    AddKeysToAgent yes
    UseKeychain yes
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

---

## Copy Public Key

Display the public key:

```bash
cat ~/.ssh/id_ed25519.pub
```

Append it to:

```text
/home/phanindra/.ssh/authorized_keys
```

on Gneiss.

---

## Configure Permissions

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

---

## Store Passphrase in macOS Keychain

```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

Older macOS versions:

```bash
ssh-add -K ~/.ssh/id_ed25519
```

---

## Connect

```bash
ssh gneiss
```

---

## VS Code Remote

Install:

- Remote - SSH

Connect using:

```
Remote-SSH: Connect to Host...
```

Select:

```
gneiss
```

VS Code installs its remote server automatically on first connection.

---

# Verification

SSH login:

```bash
ssh gneiss
```

Expected:

```text
phanindra@gneiss:~$
```

Verify hostname:

```bash
hostname
```

Expected:

```text
gneiss
```

Verify VS Code connection:

- Explorer visible
- Terminal connected
- Files editable

---

# Troubleshooting

## Permission denied (publickey)

Verify:

```bash
cat ~/.ssh/authorized_keys
```

contains the Mac public key.

---

## Incorrect permissions

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

---

## Host key changed

Remove the old entry:

```bash
ssh-keygen -R gneiss
```

or

```bash
ssh-keygen -R 192.168.1.9
```

Reconnect.

---

## VS Code cannot connect

Verify:

```bash
ssh gneiss
```

works before troubleshooting VS Code.

---

# Rollback

Remove the Mac public key:

```bash
nano ~/.ssh/authorized_keys
```

Delete the corresponding line.

Remove the client configuration:

```bash
rm ~/.ssh/config
```

---

# Next Steps

Proceed to:

docs/06-storage.md