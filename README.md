# Folder Size (Nautilus Extension)

![Release](https://img.shields.io/github/v/release/shell-extensions/foldersize?sort=semver) ![Nautilus](https://img.shields.io/badge/Nautilus-Extension-4A86CF)

![Screenshot](image/Screenshot.png)
![Context menu](image/Screenshot_extension.png)

[English](README.md) | [Deutsch](README.de.md) | [Espanol](README.es.md)

Shows folder sizes in Nautilus list view. Sizes are calculated asynchronously
(via `du`), cached, and shown with status icons while a calculation is
running or queued. A context menu entry lets you recalculate a folder
immediately, and a second entry (right-click on empty space) toggles
automatic scanning on/off.

This is a plain `nautilus-python` extension — no GNOME Shell component
required.

## Requirements
- Nautilus with `nautilus-python` support
- `du` available in PATH (coreutils)

## Installation (local user)
```sh
git clone https://github.com/shell-extensions/foldersize.git
cd foldersize
make install
nautilus -q
```
`make install` compiles the translations and symlinks `foldersize.py` into
`~/.local/share/nautilus-python/extensions/`. `nautilus -q` restarts
Nautilus so it picks up the extension.

## Uninstall
```sh
make uninstall
nautilus -q
```

## Configuration
Settings live in `~/.config/foldersize.conf` (INI format, section
`[FolderSize]`). The file is created with defaults on first use; edit it
directly or use the "Enable/Disable folder size scanning" context menu entry
for `auto_scan`. Available keys:

| Key | Default | Meaning |
|---|---|---|
| `cache_ttl` | `3600` | Seconds a cached size stays valid |
| `max_workers` | `10` | Parallel `du` worker threads |
| `du_timeout` | `1800` | Seconds before a `du` run is aborted |
| `skip_mountpoints` | `true` | Don't cross into other filesystems (`du -x`) |
| `queue_timeout` | `300` | Seconds before a stuck queued job is retried |
| `rotate_interval` | `10` | Seconds between status icon animation frames |
| `long_job_threshold` | `300` | Seconds before a running job is shown as "long" |
| `decimal_places` | `1` | Decimal places in the displayed size |
| `binary_units` | `true` | Use KiB/MiB/GiB instead of kB/MB/GB |
| `auto_scan` | `true` | Whether folders are scanned automatically |

### Switching units (MiB/GiB vs. MB/GB)
There is no settings dialog anymore, so this is done by editing the config
file directly:
```sh
sed -i 's/^binary_units = .*/binary_units = false/' ~/.config/foldersize.conf
nautilus -q
```
(Use `true` to switch back to binary units.) Unlike `auto_scan`, this and
every other key besides `auto_scan` is only read once when Nautilus starts
the extension — `nautilus -q` is required for the change to take effect;
simply saving the file is not enough.

## Pausing the scan externally
Toggling `auto_scan` in `~/.config/foldersize.conf` takes effect immediately
in any running Nautilus process — the extension watches the file for
changes. This means any external tool (for example a service pauser) can
pause/resume scanning just by writing `auto_scan = false` / `true` to that
file; no D-Bus or GSettings integration is required.

## Translations
Run `make compile` (or `make`) to compile `.po` files into `.mo`.

## Notes
- If Nautilus still shows the old version after install/uninstall, run `nautilus -q`.
- All state is kept in-memory per Nautilus process; sizes are recalculated after a restart (subject to `cache_ttl`).
