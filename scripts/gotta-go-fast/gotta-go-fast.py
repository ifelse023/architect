#!/usr/bin/env python

import os
import sys
import shutil
import argparse
import subprocess


def copy_template(src, dest):
    try:
        shutil.copytree(src, dest)
        print(f"Successfully copied {src} to {dest}")
    except Exception as e:
        print(f"Error copying template: {e}")
        return False
    return True


def initialize_git_repo(dest):
    try:
        subprocess.run(["git", "init"], cwd=dest, check=True)
        print(f"Initialized a new git repository in {dest}")
    except subprocess.CalledProcessError as e:
        print(f"Failed to initialize git repository: {e}")


def main():
    parser = argparse.ArgumentParser(
        description="Create a new project from a template."
    )
    parser.add_argument(
        "language", type=str, help="The programming language of the template."
    )
    parser.add_argument(
        "destination", type=str, help="The destination directory for the new project."
    )
    parser.add_argument(
        "--git",
        action="store_true",
        help="Initialize git repository in the new project directory",
    )

    args = parser.parse_args()
    project_root = "/home/wasd/architect/scripts/gotta-go-fast"
    src_path = os.path.join(project_root, args.language)

    if not os.path.exists(src_path):
        print(f"No template found for {args.language}")
        sys.exit(1)

    if os.path.exists(args.destination):
        print(f"The destination directory {args.destination} already exists.")
        sys.exit(1)

    if copy_template(src_path, args.destination):
        if args.git:
            initialize_git_repo(args.destination)


if __name__ == "__main__":
    main()
