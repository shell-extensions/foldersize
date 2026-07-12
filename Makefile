# Makefile für foldersize (Nautilus-Python-Extension)

DOMAIN = foldersize
LOCALEDIR = locale
PACK_DIR ?= dist
NAUTILUS_EXT_DIR = $(HOME)/.local/share/nautilus-python/extensions

LANGS = de en es

all: compile

compile:
	@for lang in $(LANGS); do \
	  echo "Compiling $$lang..."; \
	  msgfmt $(LOCALEDIR)/$$lang/LC_MESSAGES/$(DOMAIN).po \
	    -o $(LOCALEDIR)/$$lang/LC_MESSAGES/$(DOMAIN).mo; \
	done
	@echo "Fertig: Alle Übersetzungen kompiliert."

install: compile
	@mkdir -p "$(NAUTILUS_EXT_DIR)"
	@ln -sf "$(CURDIR)/foldersize.py" "$(NAUTILUS_EXT_DIR)/foldersize.py"
	@echo "Installiert: $(NAUTILUS_EXT_DIR)/foldersize.py -> $(CURDIR)/foldersize.py"
	@echo "Nautilus neu starten: nautilus -q"

uninstall:
	@rm -f "$(NAUTILUS_EXT_DIR)/foldersize.py"
	@rm -f "$(NAUTILUS_EXT_DIR)"/__pycache__/foldersize*
	@echo "Deinstalliert. Nautilus neu starten: nautilus -q"

pack: compile
	@uuid=$$(python3 -c "import json; print(json.load(open('metadata.json', 'r', encoding='utf-8'))['uuid'])"); \
	mkdir -p "$(PACK_DIR)"; \
	zip -qr "$(PACK_DIR)/$$uuid.nautilus-extension.zip" . \
	  -x ".git/*" -x ".github/*" -x "$(PACK_DIR)/*" -x ".gitignore"; \
	echo "Created $(PACK_DIR)/$$uuid.nautilus-extension.zip"

clean:
	@for lang in $(LANGS); do \
	  rm -f $(LOCALEDIR)/$$lang/LC_MESSAGES/$(DOMAIN).mo; \
	done
	@echo "Aufgeräumt."

.PHONY: all compile install uninstall pack clean
