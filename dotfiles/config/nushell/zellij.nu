# zellij.nu

# Get current ZELLIJ env var to check if we're already in a session
let in_zellij = (try { $env.ZELLIJ } catch { '' })

# Only proceed if we're not already in a Zellij session
if ($in_zellij | is-empty) {
    # Check number of existing sessions
    let existing_sessions = (zellij list-sessions | lines | length)
    
    # Start Zellij only if we have less than 3 sessions
    if $existing_sessions < 3 {
        zellij
        
        # Handle auto-exit behavior
        let auto_exit = (try { $env.ZELLIJ_AUTO_EXIT } catch { 'false' }) == 'true'
        if $auto_exit {
            exit
        }
    }
}
