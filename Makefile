# Makefile für foldersize (Dateimanager-Python-Erweiterung)

DOMAIN = foldersize
LOCALEDIR = locale
PACK_DIR ?= dist
PACKAGE_NAME = foldersize
NAUTILUS_EXT_DIR = $(HOME)/.local/share/nautilus-python/extensions
CAJA_EXT_DIR = $(HOME)/.local/share/caja-python/extensions
NEMO_EXT_DIR = $(HOME)/.local/share/nemo-python/extensions
APT_GET ?= sudo apt-get
NAUTILUS_DEPS = python3-nautilus
CAJA_DEPS = python3-caja
NEMO_DEPS = nemo-python
FOLDERSIZE_COLUMN = FolderSize::size
CAJA_LOADER_SRC = /usr/lib/x86_64-linux-gnu/caja/extensions-2.0/libcaja-python.so
CAJA_LOADER_COMPAT_DIR = /usr/lib/caja/extensions-2.0
CAJA_LOADER_COMPAT = $(CAJA_LOADER_COMPAT_DIR)/libcaja-python.so

LANGS = de en es

all: compile

compile:
	@for lang in $(LANGS); do \
	  echo "Compiling $$lang..."; \
	  msgfmt $(LOCALEDIR)/$$lang/LC_MESSAGES/$(DOMAIN).po \
	    -o $(LOCALEDIR)/$$lang/LC_MESSAGES/$(DOMAIN).mo; \
	done
	@echo "Fertig: Alle Übersetzungen kompiliert."

define require_deb
	@if command -v dpkg-query >/dev/null 2>&1; then \
	  if ! dpkg-query -W -f='$${Status}' $(1) 2>/dev/null | grep -q "install ok installed"; then \
	    echo "Fehlt: $(1). Installieren mit: make $(2)"; \
	    exit 1; \
	  fi; \
	fi
endef

deps-nautilus:
	@$(APT_GET) install -y $(NAUTILUS_DEPS)

deps-caja:
	@$(APT_GET) install -y $(CAJA_DEPS)

deps-nemo:
	@$(APT_GET) install -y $(NEMO_DEPS)

deps-all: deps-nautilus deps-caja deps-nemo

check-deps-nautilus:
	$(call require_deb,$(NAUTILUS_DEPS),deps-nautilus)

check-deps-caja:
	$(call require_deb,$(CAJA_DEPS),deps-caja)

check-deps-nemo:
	$(call require_deb,$(NEMO_DEPS),deps-nemo)

check-caja-loader-path:
	@if command -v caja >/dev/null 2>&1 && command -v strings >/dev/null 2>&1; then \
	  if strings "$$(command -v caja)" | grep -q "$(CAJA_LOADER_COMPAT_DIR)" && \
	     [ -e "$(CAJA_LOADER_SRC)" ] && [ ! -e "$(CAJA_LOADER_COMPAT)" ]; then \
	    echo "Fehlt: $(CAJA_LOADER_COMPAT)"; \
	    echo "Dein Caja-Binary sucht diesen Pfad, python3-caja installiert den Loader aber unter:"; \
	    echo "  $(CAJA_LOADER_SRC)"; \
	    echo "Korrigieren mit: make fix-caja-loader-path"; \
	    exit 1; \
	  fi; \
	fi

fix-caja-loader-path:
	@pkexec mkdir -p "$(CAJA_LOADER_COMPAT_DIR)"
	@pkexec ln -sf "$(CAJA_LOADER_SRC)" "$(CAJA_LOADER_COMPAT)"
	@echo "Installiert: $(CAJA_LOADER_COMPAT) -> $(CAJA_LOADER_SRC)"

define ensure_column_visible
	@if command -v gsettings >/dev/null 2>&1 && gsettings writable $(1) default-visible-columns >/dev/null 2>&1; then \
	  python3 tools/ensure_gsettings_column.py $(1) "$(FOLDERSIZE_COLUMN)"; \
	fi
endef

install: install-nautilus

install-nautilus: check-deps-nautilus compile
	@mkdir -p "$(NAUTILUS_EXT_DIR)"
	@rm -f "$(NAUTILUS_EXT_DIR)/foldersize_nautilus.py"
	@rm -f "$(NAUTILUS_EXT_DIR)"/__pycache__/foldersize*
	@ln -sf "$(CURDIR)/foldersize.py" "$(NAUTILUS_EXT_DIR)/foldersize.py"
	@rm -rf "$(NAUTILUS_EXT_DIR)/foldersize_shared"
	@ln -s "$(CURDIR)/foldersize_shared" "$(NAUTILUS_EXT_DIR)/foldersize_shared"
	$(call ensure_column_visible,org.gnome.nautilus.list-view)
	@echo "Installiert: $(NAUTILUS_EXT_DIR)/foldersize.py -> $(CURDIR)/foldersize.py"
	@echo "Nautilus neu starten: nautilus -q"

install-caja: check-deps-caja check-caja-loader-path compile
	@mkdir -p "$(CAJA_EXT_DIR)"
	@rm -f "$(CAJA_EXT_DIR)/foldersize_caja.py"
	@rm -f "$(CAJA_EXT_DIR)"/__pycache__/foldersize*
	@ln -sf "$(CURDIR)/foldersize_caja.py" "$(CAJA_EXT_DIR)/foldersize.py"
	@rm -rf "$(CAJA_EXT_DIR)/foldersize_shared"
	@ln -s "$(CURDIR)/foldersize_shared" "$(CAJA_EXT_DIR)/foldersize_shared"
	$(call ensure_column_visible,org.mate.caja.list-view)
	@echo "Installiert: $(CAJA_EXT_DIR)/foldersize.py -> $(CURDIR)/foldersize_caja.py"
	@echo "Caja neu starten: caja -q"

install-nemo: check-deps-nemo compile
	@mkdir -p "$(NEMO_EXT_DIR)"
	@rm -f "$(NEMO_EXT_DIR)/foldersize_nemo.py"
	@rm -f "$(NEMO_EXT_DIR)"/__pycache__/foldersize*
	@ln -sf "$(CURDIR)/foldersize_nemo.py" "$(NEMO_EXT_DIR)/foldersize.py"
	@rm -rf "$(NEMO_EXT_DIR)/foldersize_shared"
	@ln -s "$(CURDIR)/foldersize_shared" "$(NEMO_EXT_DIR)/foldersize_shared"
	$(call ensure_column_visible,org.nemo.list-view)
	@echo "Installiert: $(NEMO_EXT_DIR)/foldersize.py -> $(CURDIR)/foldersize_nemo.py"
	@echo "Nemo neu starten: nemo -q"

install-all: install-nautilus install-caja install-nemo

uninstall: uninstall-nautilus

uninstall-nautilus:
	@rm -f "$(NAUTILUS_EXT_DIR)/foldersize.py"
	@rm -rf "$(NAUTILUS_EXT_DIR)/foldersize_shared"
	@rm -f "$(NAUTILUS_EXT_DIR)"/__pycache__/foldersize*
	@echo "Deinstalliert. Nautilus neu starten: nautilus -q"

uninstall-caja:
	@rm -f "$(CAJA_EXT_DIR)/foldersize.py"
	@rm -rf "$(CAJA_EXT_DIR)/foldersize_shared"
	@rm -f "$(CAJA_EXT_DIR)"/__pycache__/foldersize*
	@echo "Deinstalliert. Caja neu starten: caja -q"

uninstall-nemo:
	@rm -f "$(NEMO_EXT_DIR)/foldersize.py"
	@rm -rf "$(NEMO_EXT_DIR)/foldersize_shared"
	@rm -f "$(NEMO_EXT_DIR)"/__pycache__/foldersize*
	@echo "Deinstalliert. Nemo neu starten: nemo -q"

uninstall-all: uninstall-nautilus uninstall-caja uninstall-nemo

check:
	@python3 -m py_compile foldersize.py foldersize_caja.py foldersize_nemo.py foldersize_shared/core.py tools/ensure_gsettings_column.py
	@python3 -c "import foldersize; print(foldersize.FolderSizeNautilusExtension.__gtype_name__)"
	@python3 -c "import foldersize_caja; print(foldersize_caja.FolderSizeCajaExtension.__gtype_name__)"
	@python3 -c "import foldersize_nemo; print(foldersize_nemo.FolderSizeNemoExtension.__gtype_name__)"

pack: compile
	mkdir -p "$(PACK_DIR)"; \
	zip -qr "$(PACK_DIR)/$(PACKAGE_NAME).file-manager-extension.zip" . \
	  -x ".git/*" -x ".github/*" -x "$(PACK_DIR)/*" -x ".gitignore"; \
	echo "Created $(PACK_DIR)/$(PACKAGE_NAME).file-manager-extension.zip"

clean:
	@for lang in $(LANGS); do \
	  rm -f $(LOCALEDIR)/$$lang/LC_MESSAGES/$(DOMAIN).mo; \
	done
	@echo "Aufgeräumt."

.PHONY: all compile deps-nautilus deps-caja deps-nemo deps-all check-deps-nautilus check-deps-caja check-deps-nemo check-caja-loader-path fix-caja-loader-path install install-nautilus install-caja install-nemo install-all uninstall uninstall-nautilus uninstall-caja uninstall-nemo uninstall-all check pack clean
