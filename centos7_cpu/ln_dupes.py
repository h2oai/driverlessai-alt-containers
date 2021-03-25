#!/usr/bin/env python
import re
import sys
import shlex
import argparse
from os import unlink, symlink
from os.path import relpath, dirname, basename, join

# Usage example: fdupes -r -S -n -1 -q . | ln_dupes.py -l 1000

group_start = re.compile("^\d+\sbyte.*each:$")


def symlink_dupes(source: str, targets: list):
    for dup_file in targets:
        rel_path = relpath(dirname(source), dirname(dup_file))
        target = join(rel_path, basename(source))

        try:
            unlink(dup_file)
            symlink(join(rel_path,basename(source)), dup_file)
            print(f'[LINKED] {source} -> {target}')
        except Exception:
            print(f'[NOT LINKED] {source} -> {target}')
            raise


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--input', type=argparse.FileType('r'), default=sys.stdin, help='Input file or STDIN')
    parser.add_argument('-l', '--limit', type=int, default=10, help='Size limit in bytes')
    args = parser.parse_args()

    collect = False
    for line in args.input:
        if group_start.match(line):
            collect = int(line.split(' ')[0]) > args.limit
        elif collect:
            collect = False
            files = shlex.split(line.strip())
            symlink_dupes(files[0], files[1:])
