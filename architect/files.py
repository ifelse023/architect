from os import listdir

path = "/boot/loader/entries/"

file_dir = listdir("/boot/loader/entries/")
file = file_dir[1]
file_path = path + file


def append_options_to_kernel_config():
    new_options = "nowatchdog mitigations=off nopti tsx=on"

    try:
        with open(file_path, "r") as file:
            lines = file.readlines()

        modified_lines = []
        for line in lines:
            if line.strip().startswith("options"):
                line = line.strip() + " " + new_options + "\n"
            modified_lines.append(line)

        with open(file_path, "w") as file:
            file.writelines(modified_lines)

        print("Options appended successfully.")
    except Exception as e:
        print(f"error occurred while modifying the file: {e}")


def replace(file_path, f, r):
    try:
        with open(file_path, "r") as file:
            lines = file.readlines()

        modified_lines = [line.replace(f, r) for line in lines]

        with open(file_path, "w") as file:
            file.writelines(modified_lines)

        print("File modified successfully.")
    except Exception as e:
        print(f"error occurred while modifying the file: {e}")


def main():
    replace("/etc/fstab", "relatime", "noatime")
    replace(
        "/boot/loader/entries/00-linux.conf", "vmlinuz-linux", "vmlinuz-linux-cachyos"
    )
    replace(
        "/boot/loader/entries/00-linux.conf",
        "initramfs-linux.img",
        "initramfs-linux-cachyos.img",
    )
    append_options_to_kernel_config()


main()
