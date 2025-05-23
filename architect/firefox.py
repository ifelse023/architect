#!/usr/bin/env python3

import os
import shutil
import re
import sys
import subprocess


def main():
    """
    Main function to:
    1. Delete all existing profile folders in ~/.mozilla/firefox
    2. Copy a specific profile folder from /mnt/usb to ~/.mozilla/firefox
    3. Modify the profiles.ini file in ~/.mozilla/firefox
    4. Modify the installs.ini file in ~/.mozilla/firefox
    """
    # Define paths
    firefox_dir = os.path.expanduser("~/.mozilla/firefox")
    usb_profile_path = "/mnt/usb/itb0rded.hey"
    profiles_ini_path = os.path.join(firefox_dir, "profiles.ini")
    installs_ini_path = os.path.join(firefox_dir, "installs.ini")

    print(f"Starting operations on {firefox_dir}")

    os.makedirs(firefox_dir, exist_ok=True)

    delete_profile_folders(firefox_dir)

    try:
        copy_profile_folder(usb_profile_path, firefox_dir)
    except FileNotFoundError:
        print(f"Error: Profile folder {usb_profile_path} not found on USB drive.")
        print("Make sure the USB drive is mounted at /mnt/usb")
        sys.exit(1)
    except PermissionError:
        print(f"Error: Permission denied when accessing {usb_profile_path}")
        print("Make sure you have read permissions for the USB drive")
        sys.exit(1)

    # 3. Modify profiles.ini
    modify_profiles_ini(profiles_ini_path)

    # 4. Modify installs.ini
    modify_installs_ini(installs_ini_path)

    print("Operations completed successfully")


def is_profile_folder(folder_name):

    return bool(re.match(r"^[a-z0-9]+\.(default(-release)?|hey)$", folder_name))


def delete_profile_folders(firefox_dir):

    print("Deleting existing profile folders...")
    try:
        for item in os.listdir(firefox_dir):
            item_path = os.path.join(firefox_dir, item)
            if os.path.isdir(item_path) and is_profile_folder(item):
                print(f"  Deleting: {item}")
                shutil.rmtree(item_path)
    except FileNotFoundError:
        print(f"  {firefox_dir} directory not found. Will be created.")
    except PermissionError:
        print(f"Error: Permission denied when accessing {firefox_dir}")
        print("Make sure you have write permissions for the directory")
        sys.exit(1)


def copy_profile_folder(source_path, firefox_dir):
    profile_name = os.path.basename(source_path)
    dest_path = os.path.join(firefox_dir, profile_name)

    print(f"Copying profile folder from {source_path} to {dest_path}")

    # Try to use rsync first, fall back to cp -r if rsync is not available

    try:
        # Check if rsync is available
        subprocess.run(
            ["which", "rsync"],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )

        # Use rsync to copy files (preserves permissions, handles special files)
        print("  Using rsync for copying...")
        result = subprocess.run(
            ["rsync", "-a", source_path + "/", dest_path],
            check=True,
            stderr=subprocess.PIPE,
        )

    except (subprocess.CalledProcessError, FileNotFoundError):
        # Rsync not available, try cp -r
        print("  Rsync not available, using cp -r instead...")
        try:
            # Ensure destination directory exists
            os.makedirs(dest_path, exist_ok=True)

            # Use cp -r to copy files
            result = subprocess.run(
                ["cp", "-r", source_path + "/.", dest_path],
                check=True,
                stderr=subprocess.PIPE,
            )

        except subprocess.CalledProcessError as e:
            print(f"Error copying profile: {e.stderr.decode()}")
            raise

    print("  Profile copied successfully")


def modify_profiles_ini(profiles_ini_path):

    profile_name = "itb0rded.hey"

    # Check if profiles.ini exists
    if not os.path.exists(profiles_ini_path):
        print(
            f"profiles.ini file not found at {profiles_ini_path}. Creating a new one."
        )
        create_new_profiles_ini(profiles_ini_path, profile_name)
        return

    print(f"Modifying {profiles_ini_path}...")

    try:
        # Read the existing file content
        with open(profiles_ini_path, "r") as f:
            content = f.read()

        # Process each section
        sections = {}
        current_section = None
        section_content = []

        for line in content.split("\n"):
            line = line.strip()
            if line == "":
                continue

            if line.startswith("["):
                # End of a section, save it
                if current_section:
                    sections[current_section] = section_content

                # Start a new section
                current_section = line
                section_content = []
            else:
                section_content.append(line)

        # Save the last section
        if current_section:
            sections[current_section] = section_content

        # Construct the new file content
        new_content = []

        # Add all non-Profile sections
        for section, lines in sections.items():
            if not section.startswith("[Profile"):
                new_content.append(section)
                for line in lines:
                    if section.startswith("[Install") and line.startswith("Default="):
                        new_content.append(f"Default={profile_name}")
                    else:
                        new_content.append(line)
                new_content.append("")  # Empty line

        # Add the new profile entry
        new_content.append("[Profile0]")
        new_content.append("Name=hey")
        new_content.append("IsRelative=1")
        new_content.append(f"Path={profile_name}")
        new_content.append("")  # Empty line

        # Write the new content to the file
        with open(profiles_ini_path, "w") as f:
            f.write("\n".join(new_content))

        print("  profiles.ini has been updated")

    except PermissionError:
        print(f"Error: Permission denied when modifying {profiles_ini_path}")
        print("Make sure you have write permissions for the file")
        sys.exit(1)


def create_new_profiles_ini(profiles_ini_path, profile_name):
    """
    Create a new profiles.ini file with the required structure.

    Args:
        profiles_ini_path: Path to the profiles.ini file
        profile_name: Name of the profile folder
    """
    try:
        lines = [
            "[Install1]",
            f"Default={profile_name}",
            "Locked=1",
            "",
            "[Profile0]",
            "Name=hey",
            "IsRelative=1",
            f"Path={profile_name}",
            "",
            "[General]",
            "StartWithLastProfile=1",
            "Version=2",
            "",
        ]

        with open(profiles_ini_path, "w") as f:
            f.write("\n".join(lines))

        print("  Created a new profiles.ini file")

    except PermissionError:
        print(f"Error: Permission denied when creating {profiles_ini_path}")
        print("Make sure you have write permissions for the directory")
        sys.exit(1)


def modify_installs_ini(installs_ini_path):
    """
    Modify the installs.ini file to update the Default= value to the correct profile folder name.

    Args:
        installs_ini_path: Path to the installs.ini file
    """
    profile_name = "itb0rded.hey"

    # Check if installs.ini exists
    if not os.path.exists(installs_ini_path):
        print(f"installs.ini file not found at {installs_ini_path}. Skipping.")
        return

    print(f"Modifying {installs_ini_path}...")

    try:
        # Read the existing file content
        with open(installs_ini_path, "r") as f:
            lines = f.readlines()

        # Process each line, updating the Default= line
        new_lines = []
        for line in lines:
            if line.strip().startswith("Default="):
                new_lines.append(f"Default={profile_name}\n")
            else:
                new_lines.append(line)

        # Write the updated content back to the file
        with open(installs_ini_path, "w") as f:
            f.writelines(new_lines)

        print(f"  installs.ini has been updated to use profile: {profile_name}")

    except FileNotFoundError:
        print(f"Error: {installs_ini_path} not found")
    except PermissionError:
        print(f"Error: Permission denied when modifying {installs_ini_path}")
        print("Make sure you have write permissions for the file")
        sys.exit(1)


if __name__ == "__main__":
    main()
