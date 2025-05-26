#!/usr/bin/env python3

import subprocess
import sys
import argparse
from concurrent.futures import ThreadPoolExecutor
from typing import List, Dict, Any
from enum import Enum
from dataclasses import dataclass


class Color:
    RESET = "\033[0m"
    RED = "\033[31m"
    GREEN = "\033[32m"
    YELLOW = "\033[33m"
    BLUE = "\033[34m"
    CYAN = "\033[36m"
    MAGENTA = "\033[35m"


class ServiceType(str, Enum):
    SYSTEM = "system"
    USER = "user"


@dataclass
class Service:
    name: str
    type: ServiceType
    pkg: str
    enabled: bool = False
    active: bool = False


SERVICES = [
    Service(name="tlp", type=ServiceType.SYSTEM, pkg="tlp"),
    Service(name="throttled", type=ServiceType.SYSTEM, pkg="throttled"),
    Service(name="thermald", type=ServiceType.SYSTEM, pkg="thermald"),
    Service(name="scx", type=ServiceType.SYSTEM, pkg="scx-scheds-git"),
    Service(name="greetd", type=ServiceType.SYSTEM, pkg="greetd"),
    Service(name="psd", type=ServiceType.USER, pkg="profile-sync-daemon"),
    Service(name="hyprpolkitagent", type=ServiceType.USER, pkg="hyprpolkitagent"),
]


def print_msg(message: str, status: str = "", error: bool = False) -> None:
    color = Color.RED if error else Color.BLUE
    prefix = f"{color}[{'ERROR' if error else 'INFO'}]{Color.RESET}"

    if status:
        if status in ("active", "enabled"):
            status_color = f"{Color.GREEN}{status}{Color.RESET}"
        elif status in ("inactive", "disabled"):
            status_color = f"{Color.YELLOW}{status}{Color.RESET}"
        else:
            status_color = f"{Color.RED}{status}{Color.RESET}"
        print(f"{prefix} {message}: {status_color}")
    else:
        print(f"{prefix} {message}")


def print_service_status(service: Service, action: str = "") -> None:
    """
    Prints service status with color-coded indicators:
    - Green: Both enabled and active
    - Yellow: Either enabled or active but not both
    - Red: Neither enabled nor active
    - Cyan: Service is currently being enabled or started
    """
    if action:
        status_color = Color.CYAN
        status_text = f"[{action}]"
    elif service.enabled and service.active:
        status_color = Color.GREEN
        status_text = "[RUNNING]"
    elif service.enabled or service.active:
        status_color = Color.YELLOW
        status_text = "[PARTIAL]"
    else:
        status_color = Color.RED
        status_text = "[STOPPED]"

    enabled_status = (
        f"{Color.GREEN}enabled{Color.RESET}"
        if service.enabled
        else f"{Color.RED}disabled{Color.RESET}"
    )
    active_status = (
        f"{Color.GREEN}active{Color.RESET}"
        if service.active
        else f"{Color.RED}inactive{Color.RESET}"
    )

    service_type = f"{Color.MAGENTA}({service.type}){Color.RESET}"

    print(
        f"{Color.BLUE}[INFO]{Color.RESET} Service {status_color}{service.name}{Color.RESET} {service_type}: {status_text} {enabled_status}, {active_status}"
    )


def run_cmd(cmd: List[str]) -> Dict[str, Any]:
    result = subprocess.run(cmd, capture_output=True, text=True)
    return {
        "success": result.returncode == 0,
        "output": result.stdout.strip(),
        "error": result.stderr.strip(),
    }


def check_package(pkg: str) -> bool:
    return run_cmd(["pacman", "-Q", pkg])["success"]


def systemctl(service: Service, action: str) -> Dict[str, Any]:
    cmd = (
        ["systemctl", "--user"]
        if service.type == ServiceType.USER
        else ["sudo", "systemctl"]
    )
    cmd.append(action)
    cmd.append(service.name)
    return run_cmd(cmd)


def update_service_status(service: Service) -> Service:
    enabled_result = systemctl(service, "is-enabled")
    service.enabled = (
        enabled_result["success"] and enabled_result["output"] == "enabled"
    )

    active_result = systemctl(service, "is-active")
    service.active = active_result["success"] and active_result["output"] == "active"

    return service


def manage_service(service: Service, args: argparse.Namespace) -> bool:
    if not check_package(service.pkg):
        print_msg(f"Missing package for {service.name}: {service.pkg}", error=True)
        return False

    service = update_service_status(service)

    print_service_status(service)

    if args.status:
        return True

    success = True

    if (args.enable or args.all) and not service.enabled:
        if args.dry_run:
            print_msg(f"Would enable {service.name}")
        else:
            print_service_status(service, "ENABLING")
            result = systemctl(service, "enable")
            if result["success"]:
                service.enabled = True
                print_service_status(service)
            else:
                print_msg(
                    f"Failed to enable {service.name}: {result['error']}", error=True
                )
                success = False

    if (args.start or args.all) and not service.active:
        if args.dry_run:
            print_msg(f"Would start {service.name}")
        else:
            print_service_status(service, "STARTING")
            result = systemctl(service, "start")
            if result["success"]:
                service.active = True
                print_service_status(service)
            else:
                print_msg(
                    f"Failed to start {service.name}: {result['error']}", error=True
                )
                success = False

    if args.restart:
        if args.dry_run:
            print_msg(f"Would restart {service.name}")
        else:
            print_service_status(service, "RESTARTING")
            result = systemctl(service, "restart")
            if result["success"]:
                service.active = True
                print_service_status(service)
            else:
                print_msg(
                    f"Failed to restart {service.name}: {result['error']}", error=True
                )
                success = False

    return success


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Manage systemd services")

    actions = parser.add_argument_group("Actions")
    actions.add_argument(
        "--all", action="store_true", help="Enable and start all services (default)"
    )
    actions.add_argument(
        "--status", action="store_true", help="Show status of services"
    )
    actions.add_argument("--enable", action="store_true", help="Only enable services")
    actions.add_argument("--start", action="store_true", help="Only start services")
    actions.add_argument("--restart", action="store_true", help="Restart services")

    parser.add_argument(
        "--dry-run", action="store_true", help="Show actions without execution"
    )
    parser.add_argument(
        "--parallel", action="store_true", help="Process services in parallel"
    )
    parser.add_argument(
        "--services", type=str, nargs="+", help="Specific services to manage"
    )

    args = parser.parse_args()

    if not (args.all or args.status or args.enable or args.start or args.restart):
        args.all = True

    return args


def main() -> int:
    args = parse_args()

    # Filter services if specific ones were requested
    if args.services:
        services = [svc for svc in SERVICES if svc.name in args.services]
        if not services:
            print_msg(
                f"No matching services found. Available: {', '.join(s.name for s in SERVICES)}",
                error=True,
            )
            return 1
    else:
        services = SERVICES

    # Print summary of services to be managed
    print_msg(
        f"Managing {len(services)} services: {', '.join(s.name for s in services)}"
    )

    # Process services
    if args.parallel:
        print_msg("Processing services in parallel")
        with ThreadPoolExecutor() as executor:
            results = list(
                executor.map(lambda svc: manage_service(svc, args), services)
            )
            success = all(results)
    else:
        success = all(manage_service(service, args) for service in services)

    return 0 if success else 1


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        print("\nOperation cancelled by user")
        sys.exit(130)
