if (tty) == "/dev/tty1" {
    do -i {
        uwsm check may-start
        uwsm select
        exec systemd-cat -t uwsm_start uwsm start default
    }
}
