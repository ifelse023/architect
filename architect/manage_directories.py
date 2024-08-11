import shutil
import os


def manage_directories():
    dirs_to_keep = ["architect", "Downloads", "dev", "misc"]
    home_dir = "/home/wasd/"

    try:
        existing_dirs = set(os.listdir(home_dir))
        for item in existing_dirs:
            item_path = os.path.join(home_dir, item)
            if item.startswith(".") or not os.path.isdir(item_path):
                continue
            if item not in dirs_to_keep:
                shutil.rmtree(item_path)
                print(f"Deleted: {item_path}")

        for dir_name in dirs_to_keep:
            dir_path = os.path.join(home_dir, dir_name)
            if dir_name not in existing_dirs:
                os.makedirs(dir_path, exist_ok=True)
                print(f"Created: {dir_path}")

    except Exception as e:
        print(f"An error occurred: {e}")
        exit(1)


if __name__ == "__main__":
    manage_directories()
