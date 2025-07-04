sudo pacman -S intel-undervolt --needed
sudo modprobe msr
echo 'msr' | sudo tee /etc/modules-load.d/msr.conf
sudo intel-undervolt read

sudo systemctl enable intel-undervolt.service
