function zellij_start
    if set -q ZELLIJ
        return 1
    end

    set -l sessions (zellij list-sessions -s 2>/dev/null)

    if not string match -q "*dev*" -- "$sessions"
        zellij -s dev
        return 0
    else if not string match -q "*hey*" -- "$sessions"
        zellij -s hey
        return 0
    else if not string match -q "*extra*" -- "$sessions"
        zellij -s extra
        return 0
    else
        zellij list-sessions
        return 1
    end
end

function zz
    zellij --layout welcome
end

function z_kill_all
    zellij kill-all-sessions -y
    zellij delete-all-sessions -y
end

function za
    set -l sessions (zellij list-sessions -s 2>/dev/null)
    set -l count (count $sessions)

    if test $count -eq 0
        zellij -s dev
        return
    end

    if test $count -eq 1
        zellij attach
        return
    end

    set -l session (string join \n $sessions | fzf  2>/dev/null)
    if test -n "$session"
        zellij attach $session
    end
end
