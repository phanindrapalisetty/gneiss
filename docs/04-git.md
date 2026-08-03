# Git Configuration

| Property | Value |
|----------|-------|
| Status | Complete |
| Project | Gneiss |
| Last Updated | 2026-08-03 |

---

# Purpose

Configure Git for version control and establish the development workflow for the Gneiss homelab.

Git serves as the single source of truth for:

- Documentation
- Docker Compose files
- Configuration files
- Utility scripts
- Infrastructure changes

---

# Prerequisites

The following steps should already be completed:

- Debian 13 installed
- System updated
- Essential utilities installed
- Internet connectivity available

Reference:

- docs/02-installation.md
- docs/03-post-installation.md

---

# Background

The Gneiss repository is maintained primarily from the MacBook.

Development workflow:

MacBook
→ Edit
→ Commit
→ Push

↓

GitHub

↓

Gneiss
→ Pull
→ Deploy

This approach separates development from deployment and keeps the server focused on running workloads instead of editing source files.

---

# Implementation

## Verify Git Installation

```bash
git --version
```

---

## Configure Git Identity

```bash
git config --global user.name "Phanindra Sai"
git config --global user.email "your-email@example.com"
```

---

## Configure Global Defaults

```bash
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.editor nano
git config --global color.ui auto
```

---

## Verify Configuration

```bash
git config --list
```

---

## Repository Structure

The repository is cloned under:

```text
/home/phanindra/Projects/gneiss
```

Create the workspace:

```bash
mkdir -p ~/Projects
cd ~/Projects
```

Clone the repository:

```bash
git clone git@github.com:<github-username>/gneiss.git
```

---

## Branch Strategy

The repository follows a feature-branch workflow.

```text
main

├── feature/networking
├── feature/storage
├── feature/docker
├── feature/casaos
├── feature/media
├── feature/data-platform
├── feature/monitoring
└── feature/backups
```

---

## Commit Convention

Feature

```text
feat(docker): install Docker Engine
```

Documentation

```text
docs: add Git configuration guide
```

Bug Fix

```text
fix(storage): correct external HDD mount
```

Maintenance

```text
chore: update Debian packages
```

---

# Verification

Verify Git installation:

```bash
git --version
```

Verify configuration:

```bash
git config --list
```

Verify repository:

```bash
git status
```

Expected:

```text
On branch main
nothing to commit, working tree clean
```

---

# Troubleshooting

## Git not found

```bash
sudo apt install git
```

---

## Permission denied (publickey)

Verify that:

- GitHub contains the server SSH public key.
- Repository uses SSH URL.
- SSH agent is configured.

Test:

```bash
ssh -T git@github.com
```

---

## Wrong Git identity

Update:

```bash
git config --global user.name "..."
git config --global user.email "..."
```

---

# Rollback

Remove Git configuration:

```bash
rm ~/.gitconfig
```

Remove repository:

```bash
rm -rf ~/Projects/gneiss
```

---

# Next Steps

Proceed to:

docs/05-networking.md