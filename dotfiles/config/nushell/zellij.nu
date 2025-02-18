# zellij.nu

# Get current ZELLIJ env var to check if we're already in a session
let in_zellij = (try { $env.ZELLIJ } catch { '' })

# Only proceed if we're not already in a Zellij session
if ($in_zellij | is-empty) {
    # Check number of existing sessions
    let existing_sessions = (zellij list-sessions | lines | length)
     if $existing_sessions < 3 {
        let session_name = if $existing_sessions == 0 {
            'x'
        } else if $existing_sessions == 1 {
            'y'
        } else {
            'z'
        }
        
        zellij -s $session_name
        
        # Handle auto-exit behavior
        let auto_exit = (try { $env.ZELLIJ_AUTO_EXIT } catch { 'false' }) == 'true'
        if $auto_exit {
            exit
        }
    }
}
