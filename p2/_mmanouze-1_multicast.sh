#!/bin/sh

# ====================================================================
# multicastRouter1.sh
# Configures Router 1 with VXLAN using multicast for VTEP discovery
# ====================================================================

# Create a bridge interface named br0
# This virtual bridge will connect the local network with the VXLAN tunnel
ip link add br0 type bridge

# Activate the bridge interface
ip link set dev br0 up

# Configure the physical interface (eth0) that connects to the infrastructure network
# This interface will carry the encapsulated VXLAN traffic between routers
# 10.1.1.1/24: IP address for Router 1 on the infrastructure network
ip addr add 10.1.1.1/24 dev eth0

# Create a VXLAN interface with the following parameters:
# - name vxlan10: Interface name
# - type vxlan: Defines this as a VXLAN interface
# - id 10: VXLAN Network Identifier (VNI) - must match across all routers
# - dev eth0: The physical interface that will carry the VXLAN traffic
# - group 239.1.1.1: Multicast group for VTEP discovery (all routers must use the same group)
# - dstport 4789: Standard VXLAN UDP port
ip link add name vxlan10 type vxlan id 10 dev eth0 group 239.1.1.1 dstport 4789

# Assign an IP address to the VXLAN interface
# This IP is used for management of the VXLAN interface itself
ip addr add 20.1.1.1/24 dev vxlan10

# Add the local network interface (eth1) to the bridge
# This connects the local hosts to the bridge
brctl addif br0 eth1

# Add the VXLAN interface to the bridge
# This connects the remote hosts (via VXLAN) to the bridge
brctl addif br0 vxlan10

# Activate the VXLAN interface
ip link set dev vxlan10 up

# ====================================================================
# NOTES:
# - The multicast group (239.1.1.1) allows automatic discovery of other VTEPs
# - Unlike static VXLAN, we don't need to specify remote router IPs
# - All routers participating in this VXLAN must:
#   1. Use the same VNI (10)
#   2. Join the same multicast group (239.1.1.1)
#   3. Use the same UDP port (4789)
# ====================================================================