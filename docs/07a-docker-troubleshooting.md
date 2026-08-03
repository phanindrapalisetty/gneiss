# VS Code Remote Server Issues

## Symptoms

- Docker extension reports:
  - "Failed to connect"
  - "Permission denied while trying to connect to Docker daemon"

- Docker works correctly from a normal SSH session.

---

## Cause

The VS Code Remote Server was started before the user's group memberships changed (for example, after adding the user to the `docker` group).

The remote server continued using the stale login session.

---

## Resolution

1. Close all VS Code Remote sessions.
2. Open a separate SSH session from another terminal.

```bash
ssh gneiss
```

3. Remove the remote server:

```bash
rm -rf ~/.vscode-server
```

4. Disconnect.

5. Reconnect using VS Code Remote SSH.

The server will reinstall automatically and inherit the latest user permissions.

---

## Verification

```bash
id
docker info
```

Docker should be accessible without `sudo`.