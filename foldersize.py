# SPDX-License-Identifier: GPL-3.0-or-later
#
# Folder Size — Folder size column for Nautilus, Caja and Nemo.
# Copyright (C) 2026 yurij.de
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

import os

import gi

os.environ["FOLDERSIZE_FILE_MANAGER"] = "Nautilus"
gi.require_version("Nautilus", "4.0")

from foldersize_shared.core import FolderSize as _FolderSize


class FolderSizeNautilusExtension(_FolderSize):
    __gtype_name__ = "FolderSizeNautilusAdapter"


del _FolderSize
