import os

import gi

os.environ["FOLDERSIZE_FILE_MANAGER"] = "Nemo"
gi.require_version("Nemo", "3.0")

from foldersize_shared.core import FolderSize as _FolderSize


class FolderSizeNemoExtension(_FolderSize):
    __gtype_name__ = "FolderSizeNemoAdapter"


del _FolderSize
