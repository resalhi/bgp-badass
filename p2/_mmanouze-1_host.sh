#!/bin/sh

# ====================================================================
# hostConfig.sh
# Configures the network interface on a host inside the VXLAN network
# ====================================================================

# Assign an IP address to the host's network interface (eth1)
# - 192.168.10.1/24: The IP address with subnet mask (255.255.255.0)
# - This allows the host to communicate with other devices in the 192.168.10.0/24 subnet
# - dev eth1: Specifies which interface to configure (the one connected to the router)
ip addr add 192.168.10.1/24 dev eth1

# Activate the network interface
# The interface won't send/receive any traffic until it's brought up
# This is equivalent to connecting a network cable to a physical interface
ip link set eth1 up

# ====================================================================
# NOTES:
# - All hosts in the VXLAN should be in the same subnet (192.168.10.0/24)
# - Each host needs a unique IP address in this subnet
# - Host_2 would use 192.168.10.2/24 instead
# - After configuration, hosts should be able to communicate across the VXLAN
# ====================================================================