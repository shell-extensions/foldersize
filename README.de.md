# Folder Size (Nautilus-Erweiterung)

![Release](https://img.shields.io/github/v/release/shell-extensions/foldersize?sort=semver) ![Nautilus](https://img.shields.io/badge/Nautilus-Extension-4A86CF)

![Screenshot](image/Screenshot.png)
![Kontextmenü](image/Screenshot_extension.png)

[English](README.md) | [Deutsch](README.de.md) | [Espanol](README.es.md)

Zeigt Ordnergrößen in der Nautilus-Listenansicht. Größen werden asynchron
berechnet (über `du`), zwischengespeichert und mit Statussymbolen
angezeigt, solange eine Berechnung läuft oder in der Warteschlange steht.
Ein Kontextmenü-Eintrag berechnet einen Ordner sofort neu, ein zweiter
(Rechtsklick auf leeren Bereich) schaltet den automatischen Scan ein/aus.

Dies ist eine reine `nautilus-python`-Erweiterung — keine GNOME-Shell-
Komponente nötig.

## Voraussetzungen
- Nautilus mit `nautilus-python`
- `du` im PATH (coreutils)

## Installation (nur aktueller Benutzer)
```sh
git clone https://github.com/shell-extensions/foldersize.git
cd foldersize
make install
nautilus -q
```
`make install` kompiliert die Übersetzungen und verlinkt `foldersize.py`
nach `~/.local/share/nautilus-python/extensions/`. `nautilus -q` startet
Nautilus neu, damit die Erweiterung geladen wird.

## Deinstallieren
```sh
make uninstall
nautilus -q
```

## Konfiguration
Einstellungen liegen in `~/.config/foldersize.conf` (INI-Format, Sektion
`[FolderSize]`). Die Datei wird beim ersten Gebrauch mit Standardwerten
angelegt; sie kann direkt bearbeitet werden, oder `auto_scan` über den
Kontextmenü-Eintrag „Ordnergrößen-Scan aktivieren/deaktivieren" umschalten.
Verfügbare Schlüssel:

| Schlüssel | Standard | Bedeutung |
|---|---|---|
| `cache_ttl` | `3600` | Sekunden, die eine zwischengespeicherte Größe gültig bleibt |
| `max_workers` | `10` | Parallele `du`-Worker-Threads |
| `du_timeout` | `1800` | Sekunden bis ein `du`-Lauf abgebrochen wird |
| `skip_mountpoints` | `true` | Andere Dateisysteme nicht betreten (`du -x`) |
| `queue_timeout` | `300` | Sekunden bis ein hängender Job erneut versucht wird |
| `rotate_interval` | `10` | Sekunden zwischen Animationsschritten des Statussymbols |
| `long_job_threshold` | `300` | Sekunden bis ein laufender Job als „lang" markiert wird |
| `decimal_places` | `1` | Nachkommastellen bei der angezeigten Größe |
| `binary_units` | `true` | KiB/MiB/GiB statt kB/MB/GB verwenden |
| `auto_scan` | `true` | Ob Ordner automatisch gescannt werden |

### Einheiten umschalten (MiB/GiB vs. MB/GB)
Einen Einstellungsdialog gibt es nicht mehr, das läuft über direktes
Bearbeiten der Konfigurationsdatei:
```sh
sed -i 's/^binary_units = .*/binary_units = false/' ~/.config/foldersize.conf
nautilus -q
```
(Mit `true` wieder zurück auf binäre Einheiten.) Anders als `auto_scan`
wird dieser und jeder andere Schlüssel außer `auto_scan` nur einmal beim
Start der Erweiterung eingelesen — `nautilus -q` ist für die Wirkung
nötig, reines Speichern der Datei reicht nicht.

## Scan von außen pausieren
Ändert man `auto_scan` in `~/.config/foldersize.conf`, wirkt sich das sofort
in jedem laufenden Nautilus-Prozess aus — die Erweiterung überwacht die
Datei auf Änderungen. Dadurch kann jedes externe Werkzeug (etwa ein
Service-Pauser) den Scan pausieren/fortsetzen, indem es `auto_scan = false`
bzw. `true` in diese Datei schreibt; weder D-Bus noch GSettings sind dafür
nötig.

## Übersetzungen
`make compile` (oder `make`) ausführen, um `.po` zu `.mo` zu kompilieren.

## Hinweise
- Zeigt Nautilus nach Installation/Deinstallation noch die alte Version: `nautilus -q`.
- Der Zustand liegt im Arbeitsspeicher je Nautilus-Prozess; nach einem Neustart werden Größen neu berechnet (abhängig von `cache_ttl`).
