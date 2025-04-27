# Create a VXLAN interface for Router 2 with the following parameters:
# - name vxlan10: The name assigned to this virtual interface
# - type vxlan: Defines this interface as a VXLAN tunnel interface
# - id 10: VXLAN Network Identifier (VNI) - must match Router 1's VNI
# - dev eth0: The physical interface that will carry the encapsulated VXLAN traffic
# - remote 10.1.1.1: The IP address of the remote VTEP (Router 1's IP)
#   This creates a point-to-point tunnel to Router 1
# - local 10.1.1.2: The IP address of this device (Router 2) on the underlay network
#   Used as the source IP for VXLAN-encapsulated packets
# - dstport 4789: The UDP port used for VXLAN traffic (standard port)
ip link add name vxlan10 type vxlan id 10 dev eth0 remote 10.1.1.1 local 10.1.1.2 dstport 4789

# Assign an IP address to the VXLAN interface
# - 20.1.1.2/24: IP address and subnet for the VXLAN interface
# - This is a different IP than Router 1's VXLAN interface (20.1.1.1)
# - This IP is primarily used for management and troubleshooting
ip addr add 20.1.1.2/24 dev vxlan10

# Add the local network interface to the bridge
# - br0: The bridge interface previously created
# - eth1: The interface connected to host_2
# This connects host_2 to the bridge
brctl addif br0 eth1

# Add the VXLAN interface to the bridge
# - br0: The bridge interface
# - vxlan10: The VXLAN interface
# This connects the VXLAN tunnel to the bridge, allowing traffic to flow between
# the local network (eth1) and the remote network (via vxlan10)
brctl addif br0 vxlan10

# Activate the VXLAN interface
# The interface must be activated to function
ip link set dev vxlan10 up