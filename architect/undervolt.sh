paru -S intel-undervolt
sudo modprobe msr
echo 'msr' | sudo tee /etc/modules-load.d/msr.conf
sudo intel-undervolt read
