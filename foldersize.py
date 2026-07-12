import os

import gi

os.environ["FOLDERSIZE_FILE_MANAGER"] = "Nautilus"
gi.require_version("Nautilus", "4.0")

from foldersize_shared.core import FolderSize as _FolderSize


class FolderSizeNautilusExtension(_FolderSize):
    __gtype_name__ = "FolderSizeNautilusAdapter"


del _FolderSize
