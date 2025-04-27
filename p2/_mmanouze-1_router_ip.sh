# Configure the network interface (eth0) with an IP address
# - 10.1.1.1: The specific IP address assigned to this device
# - /24: Subnet mask in CIDR notation (equivalent to 255.255.255.0)
#   This means all devices with addresses from 10.1.1.0 to 10.1.1.255 
#   are considered to be on the same network segment
# - dev eth0: Specifies which interface to configure
#   (eth0 is typically the first Ethernet interface on the device)
ip addr add 10.1.1.1/24 dev eth0