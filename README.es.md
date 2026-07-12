# Folder Size (extensión de Nautilus)

![Release](https://img.shields.io/github/v/release/shell-extensions/foldersize?sort=semver) ![Nautilus](https://img.shields.io/badge/Nautilus-Extension-4A86CF)

![Screenshot](image/Screenshot.png)
![Menú contextual](image/Screenshot_extension.png)

[English](README.md) | [Deutsch](README.de.md) | [Espanol](README.es.md)

Muestra el tamaño de las carpetas en la vista de lista de Nautilus. Los
tamaños se calculan de forma asíncrona (mediante `du`), se guardan en caché
y se muestran con iconos de estado mientras un cálculo está en curso o en
cola. Una entrada del menú contextual permite recalcular una carpeta de
inmediato, y otra (clic derecho en un espacio vacío) activa o desactiva el
escaneo automático.

Es una extensión `nautilus-python` pura — no requiere ningún componente de
GNOME Shell.

## Requisitos
- Nautilus con `nautilus-python`
- `du` en PATH (coreutils)

## Instalación (usuario actual)
```sh
git clone https://github.com/shell-extensions/foldersize.git
cd foldersize
make install
nautilus -q
```
`make install` compila las traducciones y enlaza `foldersize.py` en
`~/.local/share/nautilus-python/extensions/`. `nautilus -q` reinicia
Nautilus para que cargue la extensión.

## Desinstalar
```sh
make uninstall
nautilus -q
```

## Configuración
Los ajustes se guardan en `~/.config/foldersize.conf` (formato INI, sección
`[FolderSize]`). El archivo se crea con valores por defecto en el primer
uso; puede editarse directamente, o alternar `auto_scan` con la entrada del
menú contextual "Activar/Desactivar el escaneo de tamaño de carpetas".
Claves disponibles:

| Clave | Por defecto | Significado |
|---|---|---|
| `cache_ttl` | `3600` | Segundos que un tamaño en caché permanece válido |
| `max_workers` | `10` | Hilos trabajadores paralelos de `du` |
| `du_timeout` | `1800` | Segundos antes de abortar una ejecución de `du` |
| `skip_mountpoints` | `true` | No cruzar a otros sistemas de archivos (`du -x`) |
| `queue_timeout` | `300` | Segundos antes de reintentar un trabajo atascado |
| `rotate_interval` | `10` | Segundos entre fotogramas de animación del icono de estado |
| `long_job_threshold` | `300` | Segundos antes de marcar un trabajo en curso como "largo" |
| `decimal_places` | `1` | Decimales en el tamaño mostrado |
| `binary_units` | `true` | Usar KiB/MiB/GiB en lugar de kB/MB/GB |
| `auto_scan` | `true` | Si las carpetas se escanean automáticamente |

### Cambiar de unidades (MiB/GiB vs. MB/GB)
Ya no existe un diálogo de preferencias, así que esto se hace editando el
archivo de configuración directamente:
```sh
sed -i 's/^binary_units = .*/binary_units = false/' ~/.config/foldersize.conf
nautilus -q
```
(Usa `true` para volver a unidades binarias.) A diferencia de `auto_scan`,
esta y el resto de claves (salvo `auto_scan`) solo se leen una vez al
iniciar la extensión — `nautilus -q` es necesario para que el cambio surta
efecto; guardar el archivo por sí solo no basta.

## Pausar el escaneo externamente
Cambiar `auto_scan` en `~/.config/foldersize.conf` tiene efecto inmediato
en cualquier proceso de Nautilus en ejecución — la extensión vigila el
archivo en busca de cambios. Esto permite que cualquier herramienta externa
(por ejemplo, un pausador de servicios) pause o reanude el escaneo
simplemente escribiendo `auto_scan = false` o `true` en ese archivo; no se
necesita D-Bus ni GSettings.

## Traducciones
Ejecutar `make compile` (o `make`) para compilar `.po` a `.mo`.

## Notas
- Si Nautilus sigue mostrando la versión anterior tras instalar/desinstalar, ejecutar `nautilus -q`.
- El estado se mantiene en memoria por proceso de Nautilus; los tamaños se recalculan tras un reinicio (según `cache_ttl`).
