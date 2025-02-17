#!/usr/bin/env nu
 
def install_packages [] {
    let config_path = $"($env.HOME)/architect/packages.json"
    let package_data = (open $config_path)
   
    let official_packages = $package_data.packages
    let aur_packages = $package_data."aur-packages"
    
    print "Installing official packages..."
    ^sudo pacman -S --needed ...$official_packages
    
    print "Installing AUR packages..."
    ^paru -S --needed  ...$aur_packages
}

install_packages
