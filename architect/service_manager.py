import logging
import subprocess

logging.basicConfig(
    level=logging.DEBUG,
    format="%(levelname)s - %(message)s",
    filename="./log/service_manager.log",
    filemode="w",
)


def check_if_service_installed() -> bool:
    service_pkgs = [
        "tlp",
        "thermald",
        "irqbalance",
        "scx",
        "greetd",
        "profile-sync-daemon",
    ]

    try:
        result = subprocess.run(
            ["pacman", "-Qq"],
            check=True,
            stdout=subprocess.PIPE,
            text=True,
        )
        installed_pkgs = result.stdout.splitlines()
    except subprocess.CalledProcessError:
        logging.exception("Failed get installed packages:")
        return False

    missing_services = [
        service
        for service in service_pkgs
        if not any(pkg.startswith(service) for pkg in installed_pkgs)
    ]

    if missing_services:
        logging.warning(f"Missing services: {missing_services}")
        return False

    return True


services = ["tlp", "thermald", "irqbalance", "scx", "greetd"]

user_services = ["psd"]


def check_status_service() -> dict:
    service_status = {}

    try:
        for service in services + user_services:
            command = (
                ["systemctl", "--user", "is-active", service]
                if service in user_services
                else ["systemctl", "is-active", service]
            )
            result = subprocess.run(
                command,
                capture_output=True,
                text=True,
                check=False,
            )
            service_status[service] = result.stdout.strip() == "active"
            logging.debug(
                f"Service {service} status: {
                    'active' if service_status[service] else 'inactive'
                }",
            )

    except subprocess.SubprocessError:
        logging.exception("Subprocess error")
        return {}
    except Exception:
        logging.exception("Error")
        return {}

    return service_status


def enable_services() -> None:
    statuses = check_status_service()
    for service, is_active in statuses.items():
        if not is_active:
            try:
                command = (
                    ["sudo", "systemctl", "enable", service]
                    if service in services
                    else ["systemctl", "--user", "enable", service]
                )
                subprocess.run(command, check=True)
                logging.info(f"Enabled {service}")
            except subprocess.CalledProcessError:
                logging.exception(f"Failed to enable {service}")
            except Exception:
                logging.exception(
                    f"Error while enabling {service}",
                )


enable_services()
