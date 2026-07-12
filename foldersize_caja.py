import os

import gi

os.environ["FOLDERSIZE_FILE_MANAGER"] = "Caja"
gi.require_version("Caja", "2.0")

from foldersize_shared.core import FolderSize as _FolderSize


class FolderSizeCajaExtension(_FolderSize):
    __gtype_name__ = "FolderSizeCajaAdapter"


del _FolderSize
