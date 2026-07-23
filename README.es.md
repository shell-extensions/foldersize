# Folder Size (extensión de gestores de archivos)

![Release](https://img.shields.io/github/v/release/nautilus-extensions/foldersize?sort=semver) ![Nautilus](https://img.shields.io/badge/Nautilus-compatible-4A86CF) ![Caja](https://img.shields.io/badge/Caja-compatible-87A96B) ![Nemo](https://img.shields.io/badge/Nemo-compatible-B8894D)

![Screenshot](image/Screenshot.png)
![Menú contextual](image/Screenshot_extension.png)

[English](README.md) | [Deutsch](README.de.md) | [Espanol](README.es.md)

Muestra el tamaño de las carpetas en la vista de lista de Nautilus, Caja y
Nemo. Los tamaños se calculan de forma asíncrona (mediante `du`), se guardan
en caché y se muestran con iconos de estado mientras un cálculo está en
curso o en cola. Una entrada del menú contextual permite recalcular una
carpeta de inmediato, y otra (clic derecho en un espacio vacío) activa o
desactiva el escaneo automático.

Es una extensión Python para gestores de archivos — no requiere ningún
componente de GNOME Shell.

## Requisitos
- Uno o varios gestores de archivos compatibles:
  - Nautilus con `python3-nautilus`
  - Caja con `python3-caja`
  - Nemo con `nemo-python`
- `du` en PATH (coreutils)

## Instalación (usuario actual)
```sh
git clone https://github.com/nautilus-extensions/foldersize.git
cd foldersize
make deps-nautilus    # instala python3-nautilus en Debian/Ubuntu
make deps-caja        # instala python3-caja en Debian/Ubuntu
make deps-nemo        # instala nemo-python en Debian/Ubuntu
make install-nautilus   # equivalente a: make install
make install-caja
make install-nemo
```

Usa `make deps-all` y `make install-all` para instalar todos los adaptadores
compatibles. Los objetivos normales de instalación comprueban primero el
paquete Python correspondiente y muestran el objetivo de dependencias exacto
si falta.

Los objetivos de instalación compilan las traducciones, enlazan el adaptador
más la implementación compartida en los directorios de extensión del usuario
y añaden la columna `FolderSize::size` a las columnas visibles por defecto
cuando el gestor de archivos ofrece ese ajuste:

| Objetivo | Directorio de extensión | Reinicio |
|---|---|---|
| `make install-nautilus` | `~/.local/share/nautilus-python/extensions/` | `nautilus -q` |
| `make install-caja` | `~/.local/share/caja-python/extensions/` | `caja -q` |
| `make install-nemo` | `~/.local/share/nemo-python/extensions/` | `nemo -q` |

## Desinstalar
```sh
make uninstall-nautilus   # equivalente a: make uninstall
make uninstall-caja
make uninstall-nemo
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
nautilus -q   # o: caja -q / nemo -q
```
(Usa `true` para volver a unidades binarias.) A diferencia de `auto_scan`,
esta y el resto de claves (salvo `auto_scan`) solo se leen una vez al
iniciar la extensión — hay que reiniciar el gestor de archivos afectado para
que el cambio surta efecto; guardar el archivo por sí solo no basta.

## Pausar el escaneo externamente
Cambiar `auto_scan` en `~/.config/foldersize.conf` tiene efecto inmediato
en cualquier proceso de gestor de archivos compatible en ejecución — la
extensión vigila el archivo en busca de cambios. Esto permite que cualquier
herramienta externa (por ejemplo, un pausador de servicios) pause o reanude
el escaneo simplemente escribiendo `auto_scan = false` o `true` en ese
archivo; no se necesita D-Bus ni GSettings.
[Loadshed](https://github.com/shell-extensions/loadshed) es una de esas
herramientas e incluye un preset de objetivo de archivo listo para Folder Size.

## Traducciones
Ejecutar `make compile` (o `make`) para compilar `.po` a `.mo`.

## Notas
- Si un gestor de archivos sigue mostrando la versión anterior tras instalar/desinstalar, reinícialo con `nautilus -q`, `caja -q` o `nemo -q`.
- El estado se mantiene en memoria por proceso del gestor de archivos; los tamaños se recalculan tras un reinicio (según `cache_ttl`).

## Licencia

Folder Size es software libre, publicado bajo la GNU General Public License v3.0 o posterior
(GPL-3.0-or-later). El texto completo está disponible en el archivo [LICENSE](LICENSE).
