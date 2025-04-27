# Create a VXLAN interface with the following parameters:
# - name vxlan10: The name assigned to this virtual interface
# - type vxlan: Defines this interface as a VXLAN tunnel interface
# - id 10: VXLAN Network Identifier (VNI) - all devices in the same VXLAN must use the same ID
# - dev eth0: The physical interface that will carry the encapsulated VXLAN traffic
# - remote 10.1.1.2: The IP address of the remote VTEP (VXLAN Tunnel End Point)
#   This is the IP of the other router that terminates this VXLAN tunnel
# - local 10.1.1.1: The IP address of this device on the underlay network
#   Used as the source IP for VXLAN-encapsulated packets
# - dstport 4789: The UDP port used for VXLAN traffic (4789 is the standard port)
ip link add name vxlan10 type vxlan id 10 dev eth0 remote 10.1.1.2 local 10.1.1.1 dstport 4789

# Assign an IP address to the VXLAN interface
# - 20.1.1.1/24: IP address and subnet for the VXLAN interface
# - This IP is only used for managing the VXLAN interface itself
# - It's not typically needed for bridged VXLAN operation but can be useful for troubleshooting
ip addr add 20.1.1.1/24 dev vxlan10

# Add the local network interface to the bridge
# - br0: The bridge interface previously created
# - eth1: The interface connected to the local network/host
# This command connects the local network segment to the bridge
brctl addif br0 eth1

# Add the VXLAN interface to the bridge
# - br0: The bridge interface
# - vxlan10: The VXLAN interface
# This command connects the VXLAN tunnel to the bridge
brctl addif br0 vxlan10

# Activate the VXLAN interface
# The interface must be set to "up" state to function
ip link set dev vxlan10 up