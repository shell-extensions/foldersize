# Folder Size (File Manager Extension)

![Release](https://img.shields.io/github/v/release/nautilus-extensions/foldersize?sort=semver) ![Nautilus](https://img.shields.io/badge/Nautilus-supported-4A86CF) ![Caja](https://img.shields.io/badge/Caja-supported-87A96B) ![Nemo](https://img.shields.io/badge/Nemo-supported-B8894D)

![Screenshot](image/Screenshot.png)
![Context menu](image/Screenshot_extension.png)

[English](README.md) | [Deutsch](README.de.md) | [Espanol](README.es.md)

Shows folder sizes in the list view of Nautilus, Caja and Nemo. Sizes are
calculated asynchronously (via `du`), cached, and shown with status icons
while a calculation is running or queued. A context menu entry lets you
recalculate a folder immediately, and a second entry (right-click on empty
space) toggles automatic scanning on/off.

This is a plain Python file-manager extension — no GNOME Shell component
required.

## Requirements
- One or more supported file managers:
  - Nautilus with `python3-nautilus`
  - Caja with `python3-caja`
  - Nemo with `nemo-python`
- `du` available in PATH (coreutils)

## Installation (local user)
```sh
git clone https://github.com/nautilus-extensions/foldersize.git
cd foldersize
make deps-nautilus    # installs python3-nautilus on Debian/Ubuntu
make deps-caja        # installs python3-caja on Debian/Ubuntu
make deps-nemo        # installs nemo-python on Debian/Ubuntu
make install-nautilus   # same as: make install
make install-caja
make install-nemo
```

Use `make deps-all` and `make install-all` to install all supported
file-manager adapters. The normal install targets verify the matching Python
loader package first and print the exact dependency target if it is missing.

The install targets compile translations, symlink the adapter plus the shared
implementation into the user extension directories, and add the
`FolderSize::size` column to the default visible list-view columns where the
file manager exposes that setting:

| Target | Extension directory | Restart |
|---|---|---|
| `make install-nautilus` | `~/.local/share/nautilus-python/extensions/` | `nautilus -q` |
| `make install-caja` | `~/.local/share/caja-python/extensions/` | `caja -q` |
| `make install-nemo` | `~/.local/share/nemo-python/extensions/` | `nemo -q` |

## Uninstall
```sh
make uninstall-nautilus   # same as: make uninstall
make uninstall-caja
make uninstall-nemo
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
nautilus -q   # or: caja -q / nemo -q
```
(Use `true` to switch back to binary units.) Unlike `auto_scan`, this and
every other key besides `auto_scan` is only read once when the file manager
starts the extension — restarting the affected file manager is required for
the change to take effect; simply saving the file is not enough.

## Pausing the scan externally
Toggling `auto_scan` in `~/.config/foldersize.conf` takes effect immediately
in any running supported file-manager process — the extension watches the
file for changes. This means any external tool (for example a service
pauser) can pause/resume scanning just by writing `auto_scan = false` /
`true` to that file; no D-Bus or GSettings integration is required.
[Loadshed](https://github.com/shell-extensions/loadshed) is one such tool
and ships a ready-made Folder Size file-target preset.

## Translations
Run `make compile` (or `make`) to compile `.po` files into `.mo`.

## Notes
- If a file manager still shows the old version after install/uninstall, restart it with `nautilus -q`, `caja -q` or `nemo -q`.
- All state is kept in-memory per file-manager process; sizes are recalculated after a restart (subject to `cache_ttl`).

## License

Folder Size is free software, licensed under the GNU General Public License v3.0 or later
(GPL-3.0-or-later). See the [LICENSE](LICENSE) file for the full text.
