#!/bin/sh

# ====================================================================
# multicastRouter2.sh
# Configures Router 2 with VXLAN using multicast for VTEP discovery
# ====================================================================

# Create a bridge interface named br0
# This virtual bridge will connect the local network with the VXLAN tunnel
ip link add br0 type bridge

# Activate the bridge interface
ip link set dev br0 up

# Configure the physical interface (eth0) that connects to the infrastructure network
# This interface will carry the encapsulated VXLAN traffic between routers
# 10.1.1.2/24: IP address for Router 2 on the infrastructure network (different from Router 1)
ip addr add 10.1.1.2/24 dev eth0

# Create a VXLAN interface with the following parameters:
# - name vxlan10: Interface name
# - type vxlan: Defines this as a VXLAN interface
# - id 10: VXLAN Network Identifier (VNI) - must match Router 1's configuration
# - dev eth0: The physical interface that will carry the VXLAN traffic
# - group 239.1.1.1: Multicast group for VTEP discovery (same as Router 1)
# - dstport 4789: Standard VXLAN UDP port
ip link add name vxlan10 type vxlan id 10 dev eth0 group 239.1.1.1 dstport 4789

# Assign an IP address to the VXLAN interface
# This IP is used for management of the VXLAN interface itself
# 20.1.1.2/24: A unique IP in the same subnet as Router 1's VXLAN interface
ip addr add 20.1.1.2/24 dev vxlan10

# Add the local network interface (eth1) to the bridge
# This connects host_2 to the bridge
brctl addif br0 eth1

# Add the VXLAN interface to the bridge
# This connects the remote host (host_1 via VXLAN) to the bridge
brctl addif br0 vxlan10

# Activate the VXLAN interface
ip link set dev vxlan10 up

# ====================================================================
# NOTES:
# - This configuration mirrors Router 1's configuration with appropriate IP changes
# - Both routers use the same:
#   1. VNI (10)
#   2. Multicast group (239.1.1.1)
#   3. UDP port (4789)
# - When both routers are properly configured, host_1 and host_2 will be able to 
#   communicate as if they were on the same physical network
# ====================================================================