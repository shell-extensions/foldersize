#!/usr/bin/env python3
import ast
import subprocess
import sys


def get_list(schema, key):
    raw = subprocess.check_output(["gsettings", "get", schema, key], text=True)
    value = ast.literal_eval(raw.strip())
    if not isinstance(value, list):
        raise ValueError(f"{schema} {key} is not a list")
    return value


def set_list(schema, key, values):
    subprocess.check_call(["gsettings", "set", schema, key, repr(values)])


def ensure_column(schema, column):
    for key in ("default-column-order", "default-visible-columns"):
        values = get_list(schema, key)
        if column not in values:
            values.append(column)
            set_list(schema, key, values)


def main():
    if len(sys.argv) != 3:
        print("usage: ensure_gsettings_column.py SCHEMA COLUMN", file=sys.stderr)
        return 2
    ensure_column(sys.argv[1], sys.argv[2])
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
