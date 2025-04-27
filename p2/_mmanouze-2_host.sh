#!/bin/sh

# ====================================================================
# host_2 Configuration
# Configures the network interface on the second host in the VXLAN network
# ====================================================================

# Assign an IP address to host_2's network interface (eth1)
# - 192.168.10.2/24: The IP address (192.168.10.2) with subnet mask (255.255.255.0)
# - This puts host_2 in the same subnet (192.168.10.0/24) as host_1, but with a unique IP
# - dev eth1: Specifies which interface to configure (the one connected to router_2)
ip addr add 192.168.10.2/24 dev eth1

# Activate the network interface
# This enables the interface to send and receive network traffic
ip link set eth1 up

# ====================================================================
# NOTES:
# - Both host_1 (192.168.10.1) and host_2 (192.168.10.2) are in the same subnet
# - When the VXLAN is properly configured, these hosts will be able to communicate
#   directly as if they were on the same physical network
# - This works because the VXLAN tunnels Layer 2 (Ethernet) traffic between the routers
# ====================================================================