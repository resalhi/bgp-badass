# Configure the network interface (eth0) with an IP address
# - 10.1.1.2: The specific IP address assigned to this device (Router 2)
# - /24: Subnet mask in CIDR notation (equivalent to 255.255.255.0)
#   This defines a network with 254 usable addresses (10.1.1.1 - 10.1.1.254)
# - dev eth0: Specifies which interface to configure
#   (eth0 is the interface connected to the switch/infrastructure network)
ip addr add 10.1.1.2/24 dev eth0