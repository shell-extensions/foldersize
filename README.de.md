# Folder Size (Dateimanager-Erweiterung)

![Release](https://img.shields.io/github/v/release/nautilus-extensions/foldersize?sort=semver) ![Nautilus](https://img.shields.io/badge/Nautilus-unterstuetzt-4A86CF) ![Caja](https://img.shields.io/badge/Caja-unterstuetzt-87A96B) ![Nemo](https://img.shields.io/badge/Nemo-unterstuetzt-B8894D)

![Screenshot](image/Screenshot.png)
![Kontextmenü](image/Screenshot_extension.png)

[English](README.md) | [Deutsch](README.de.md) | [Espanol](README.es.md)

Zeigt Ordnergrößen in der Listenansicht von Nautilus, Caja und Nemo. Größen
werden asynchron berechnet (über `du`), zwischengespeichert und mit
Statussymbolen angezeigt, solange eine Berechnung läuft oder in der
Warteschlange steht. Ein Kontextmenü-Eintrag berechnet einen Ordner sofort
neu, ein zweiter (Rechtsklick auf leeren Bereich) schaltet den automatischen
Scan ein/aus.

Dies ist eine reine Python-Dateimanager-Erweiterung — keine GNOME-Shell-
Komponente nötig.

## Voraussetzungen
- Ein oder mehrere unterstützte Dateimanager:
  - Nautilus mit `python3-nautilus`
  - Caja mit `python3-caja`
  - Nemo mit `nemo-python`
- `du` im PATH (coreutils)

## Installation (nur aktueller Benutzer)
```sh
git clone https://github.com/nautilus-extensions/foldersize.git
cd foldersize
make deps-nautilus    # installiert python3-nautilus auf Debian/Ubuntu
make deps-caja        # installiert python3-caja auf Debian/Ubuntu
make deps-nemo        # installiert nemo-python auf Debian/Ubuntu
make install-nautilus   # gleichbedeutend mit: make install
make install-caja
make install-nemo
```

Mit `make deps-all` und `make install-all` werden alle unterstützten
Dateimanager-Adapter installiert. Die normalen Installationsziele prüfen
zuerst das passende Python-Loader-Paket und nennen das exakte Dependency-Ziel,
falls es fehlt.

Die Installationsziele kompilieren Übersetzungen, verlinken den passenden
Adapter plus gemeinsame Implementierung in die Benutzer-Erweiterungsverzeichnisse
und tragen die Spalte `FolderSize::size` in die standardmäßig sichtbaren
Listenansicht-Spalten ein, wenn der Dateimanager diese Einstellung bereitstellt:

| Ziel | Erweiterungsverzeichnis | Neustart |
|---|---|---|
| `make install-nautilus` | `~/.local/share/nautilus-python/extensions/` | `nautilus -q` |
| `make install-caja` | `~/.local/share/caja-python/extensions/` | `caja -q` |
| `make install-nemo` | `~/.local/share/nemo-python/extensions/` | `nemo -q` |

## Deinstallieren
```sh
make uninstall-nautilus   # gleichbedeutend mit: make uninstall
make uninstall-caja
make uninstall-nemo
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
nautilus -q   # oder: caja -q / nemo -q
```
(Mit `true` wieder zurück auf binäre Einheiten.) Anders als `auto_scan`
wird dieser und jeder andere Schlüssel außer `auto_scan` nur einmal beim
Start der Erweiterung eingelesen — ein Neustart des betroffenen
Dateimanagers ist für die Wirkung nötig, reines Speichern der Datei reicht
nicht.

## Scan von außen pausieren
Ändert man `auto_scan` in `~/.config/foldersize.conf`, wirkt sich das sofort
in jedem laufenden unterstützten Dateimanager-Prozess aus — die Erweiterung
überwacht die Datei auf Änderungen. Dadurch kann jedes externe Werkzeug
(etwa ein Service-Pauser) den Scan pausieren/fortsetzen, indem es
`auto_scan = false` bzw. `true` in diese Datei schreibt; weder D-Bus noch
GSettings sind dafür nötig.
[Loadshed](https://github.com/shell-extensions/loadshed) ist ein solches
Werkzeug und liefert ein fertiges Folder-Size-Dateiziel-Preset mit.

## Übersetzungen
`make compile` (oder `make`) ausführen, um `.po` zu `.mo` zu kompilieren.

## Hinweise
- Zeigt ein Dateimanager nach Installation/Deinstallation noch die alte Version, starte ihn mit `nautilus -q`, `caja -q` oder `nemo -q` neu.
- Der Zustand liegt im Arbeitsspeicher je Dateimanager-Prozess; nach einem Neustart werden Größen neu berechnet (abhängig von `cache_ttl`).

## Lizenz

Folder Size ist freie Software und steht unter der GNU General Public License v3.0 oder später
(GPL-3.0-or-later). Der vollständige Text befindet sich in der Datei [LICENSE](LICENSE).
