import subprocess


def check_status_service(service_name: str) -> str | None:
    try:
        result = subprocess.run(
            ["systemctl", "is-active", service_name],
            capture_output=True,
            text=True,
            check=False,
        )

        if result.returncode == 0:
            return "active"
        return "inactive"
    except Exception as e:
        print(f"An error occurred: {e}")
        return "error"


def enable_service(service_name: str) -> None:
    try:
        result = subprocess.run(
            ["systemctl", "is-active", service_name],
            stdout=subprocess.PIPE,
            text=True,
            check=False,
        )
        if result.stdout.strip() == "active":
            print(f"{service_name} already active")
        else:
            subprocess.run(["sudo", "systemctl", "enable", service_name], check=True)
            print(f"Successfully enabled {service_name}")
    except subprocess.CalledProcessError as e:
        print(f"Failed to enable {service_name}: {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
