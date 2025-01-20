#!/usr/bin/env python3
# check_json.py

import glob
import json
import os
import sys

FILES_TO_READ = []
FILES_TO_READ.extend(glob.glob(r"**/*.json", recursive=True))


def main():
    status = 0

    for file in FILES_TO_READ:
        with open(file, encoding="ISO-8859-1") as f:
            try:
                json.load(f)
            except ValueError as exception:
                print("JSON error in {}".format(file))
                print(exception)
                status = 1
            else:
                print("Valid {}".format(file))

    sys.exit(status)


if __name__ == "__main__":
    main()
