# Work MacBook (no Nix)

The Mac can't run Nix, so `export/darwin` evaluates the shared modules (git, zed, fish, CLI tools) on Linux. CI (`.github/workflows/darwin-dots.yml`) publishes the result as a `dots-<date>-<sha>` release on every relevant push to `main`. `just export-darwin` builds the same output locally.

On the Mac:

```sh
# once
curl -fsSL https://github.com/tfrancisl/nixos-config/releases/latest/download/darwin-dots.tar.gz -o /tmp/dd.tgz
mkdir /tmp/dd && tar -xzf /tmp/dd.tgz -C /tmp/dd && sh /tmp/dd/repo/export/darwin/acme-dots update --brew

# afterwards
acme-dots update            # latest release
acme-dots update <tag>      # a specific release
acme-dots use <tag>         # switch back to an already downloaded release
```

Set `ACME_REPO` to a checkout of this repo to link repo files (e.g. zed `settings.json`) into the checkout instead of the release, so edits land in git.
