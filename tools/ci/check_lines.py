#!/usr/bin/env python3
# check_lines.py

import glob
import os
import sys

TAB_INDENT = b'\t'
WINDOWS_NEWLINE = b'\r\n'

FILES_TO_READ = []
FILES_TO_READ.extend(glob.glob(r"**/*.css", recursive=True))
FILES_TO_READ.extend(glob.glob(r"**/*.dm", recursive=True))
FILES_TO_READ.extend(glob.glob(r"*.dme"))
FILES_TO_READ.extend(glob.glob(r"**/*.dmf", recursive=True))
FILES_TO_READ.extend(glob.glob(r"**/*.dmm", recursive=True))
FILES_TO_READ.extend(glob.glob(r"**/*.html", recursive=True))
FILES_TO_READ.extend(glob.glob(r"**/*.js", recursive=True))
FILES_TO_READ.extend(glob.glob(r"**/*.json", recursive=True))
FILES_TO_READ.extend(glob.glob(r"**/*.MD", recursive=True))
FILES_TO_READ.extend(glob.glob(r"**/*.md", recursive=True))
FILES_TO_READ.extend(glob.glob(r"**/*.py", recursive=True))
FILES_TO_READ.extend(glob.glob(r"**/*.rs", recursive=True))
FILES_TO_READ.extend(glob.glob(r"**/*.sh", recursive=True))
FILES_TO_READ.extend(glob.glob(r"**/*.sql", recursive=True))
FILES_TO_READ.extend(glob.glob(r"**/*.toml", recursive=True))
FILES_TO_READ.extend(glob.glob(r"**/*.ts", recursive=True))
FILES_TO_READ.extend(glob.glob(r"**/*.txt", recursive=True))
FILES_TO_READ.extend(glob.glob(r"**/*.yml", recursive=True))


def report(files, condition):
    if files:
        print(f"\nFound files with {condition}.")
        files.sort()
        for i in files:
            print(i)
        return True

    print(f"\nFound no files with {condition}.")
    return False


def main():
    tab_files = []
    win_files = []

    for file in FILES_TO_READ:
        data = open(file, "rb")
        lines = data.readlines()
        for line in lines:
            if line.startswith(TAB_INDENT):
                tab_files.append(file)
                break
            if line.endswith(WINDOWS_NEWLINE):
                win_files.append(file)
                break
        data.close()

    exit_flag = False
    exit_flag |= report(tab_files, "tab indents")
    exit_flag |= report(win_files, "Windows line endings")

    if exit_flag:
        sys.exit(1)

    sys.exit(0)


if __name__ == "__main__":
    main()
