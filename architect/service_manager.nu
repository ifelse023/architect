def main [] {
    let services = [
        [name type pkg_pattern];
        [tlp system tlp]
        [thermald system thermald]
        [scx system scx-scheds-git]
        [greetd system greetd]
        [psd user profile-sync-daemon]
    ]

    let installed_pkgs = (^pacman -Qq | lines)
    let missing_pkgs = ($services 
        | where {|svc| 
            not ($installed_pkgs | any {|pkg| 
                $pkg | str contains $svc.pkg_pattern
            })
        }
        | get pkg_pattern
    )
    
    if not ($missing_pkgs | is-empty) {
        print $"Missing required packages: ($missing_pkgs | str join ', ')"
        return
    }

    $services | each {|svc|
        let status = (if $svc.type == "system" {
            ^systemctl is-enabled $svc.name
        } else {
            ^systemctl --user is-enabled $svc.name
        } | str trim)

        if $status != "enabled" {
            if $svc.type == "system" {
                ^sudo systemctl enable $svc.name
                print $"Enabled system service ($svc.name)"
            } else {
                ^systemctl --user enable $svc.name
                print $"Enabled user service ($svc.name)"
            }
        } else {
            print $"Service ($svc.name) is already enabled"
        }
    } | ignore
}
