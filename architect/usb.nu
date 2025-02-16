#!/usr/bin/env nu

def main [] {
    let mount_point = "/mnt/usb"
    let usb = "/dev/disk/by-label/linux-usb"
    if not ($mount_point | path exists) {
        sudo mkdir $mount_point
    }
    
    if ($usb | path exists) {
        let mount_check = (mount | find $usb | length)
        
        if $mount_check == 0 {
            sudo mount $usb $mount_point
        } else {
            print $usb " is already mounted."
        }
    } else {
        print  $usb " does not exist."
        exit 1
    }
    
    let ssh_source = $"($mount_point)/.ssh"
    let ssh_dest = $"($env.HOME)/.ssh"
    
    if ($ssh_source | path exists) {
        ^rsync -avz --delete $ssh_source $env.HOME
        
        ^sudo chown -R $"($env.USER):($env.USER)" $ssh_dest
        
        chmod 600 $"($ssh_dest)/id_ed25519"
        chmod 644 $"($ssh_dest)/id_ed25519.pub"
    } else {
        print "No .ssh directory found on the USB drive."
    }
    
    let misc_dest = $"($env.HOME)/misc"
    if not ($misc_dest | path exists) {
        mkdir $misc_dest
    }
    
    cp -r $"($mount_point)/books" $misc_dest
    cp -r $"($mount_point)/firefox.sh" $misc_dest

    sudo umount /mnt/usb
}
