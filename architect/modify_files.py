import os
import shutil


class ConfigModifier:
    def __init__(self, filepath):
        self.filepath = filepath
        self.backup_path = filepath + ".bak"

    def read_file(self):
        with open(self.filepath, "r") as file:
            return file.readlines()

    def write_file(self, lines):
        with open(self.filepath, "w") as file:
            file.writelines(lines)

    def create_backup(self):
        shutil.copy(self.filepath, self.backup_path)

    def replace_line_parts(self, replacements, separator=" "):
        lines = self.read_file()
        modified_lines = []
        for line in lines:
            for old, new in replacements:
                parts = line.split(separator)
                parts = [new if part == old else part for part in parts]
                line = separator.join(parts)
            modified_lines.append(line)
        self.write_file(modified_lines)

    def append_to_line(self, condition, append_text):
        lines = self.read_file()
        modified_lines = []
        for line in lines:
            if condition(line):
                line = line.strip() + " " + append_text + "\n"
            modified_lines.append(line)
        self.write_file(modified_lines)


class FileSystemModifier(ConfigModifier):
    def add_commit_if_ext4(self):
        lines = self.read_file()
        modified_lines = []
        for line in lines:
            if "ext4" in line:
                parts = line.split()
                options_index = 3
                options = parts[options_index].split(",")
                if "rw" in options and "commit=120" not in options:
                    options.append("commit=120")
                    parts[options_index] = ",".join(options)
                    line = " ".join(parts) + "\n"
            modified_lines.append(line)
        self.write_file(modified_lines)


def modify_boot_configurations(boot_dir, global_replacements, kernel_options):
    files = os.listdir(boot_dir)
    if not files:
        print(f"No files found in the directory: {boot_dir}")
        return
    file_path = os.path.join(boot_dir, files[0])
    boot_modifier = ConfigModifier(file_path)
    boot_modifier.replace_line_parts(global_replacements)
    boot_modifier.append_to_line(
        lambda line: line.strip().startswith("options"), kernel_options
    )


def main():
    fstab_modifier = FileSystemModifier("/etc/fstab")
    fstab_modifier.create_backup()
    fstab_modifier.replace_line_parts([("relatime", "noatime")])
    fstab_modifier.add_commit_if_ext4()

    boot_entries_path = "/boot/loader/entries/"
    kernel_options = "nowatchdog mitigations=off nopti tsx=on"
    replacements = [
        ("vmlinuz-linux", "vmlinuz-linux-cachyos"),
        ("initramfs-linux.img", "initramfs-linux-cachyos.img"),
    ]
    modify_boot_configurations(boot_entries_path, replacements, kernel_options)


if __name__ == "__main__":
    main()
