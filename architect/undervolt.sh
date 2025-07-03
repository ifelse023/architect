sudo pacman -S intel-undervolt stress-ng --needed
sudo modprobe msr
echo 'msr' | sudo tee /etc/modules-load.d/msr.conf
sudo rsync -rvh --no-perms --no-owner --no-group ~/architect/config-files/etc/ /etc/
sudo intel-undervolt read

sudo intel-undervolt apply

# Check if system is stable - run stress test
stress-ng --cpu 4 --timeout 300s
