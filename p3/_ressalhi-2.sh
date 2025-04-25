#!/bin/sh

# Create a bridge interface named br0
ip link add br0 type bridge
# Bring the bridge interface up
ip link set dev br0 up
# Create a VXLAN interface with VNI 10, using the default VXLAN UDP port 4789
ip link add vxlan10 type vxlan id 10 dstport 4789
# Bring the VXLAN interface up
ip link set dev vxlan10 up
# Add the VXLAN interface to the bridge
brctl addif br0 vxlan10
# Add eth1 to the bridge, connecting this switch to the physical/virtual network
brctl addif br0 eth1

# Configure the FRR router
vtysh << EOF
configure terminal
!
# Disable IPv6 forwarding
no ipv6 forwarding
!
# Configure eth0 with IP and enable OSPF
interface eth0
  ip address 10.1.1.2/30
  ip ospf area 0
!
# Configure loopback with IP and enable OSPF
interface lo
  ip address 1.1.1.2/32
  ip ospf area 0
!
# BGP configuration for ASN 1
router bgp 1
  neighbor 1.1.1.1 remote-as 1
  neighbor 1.1.1.1 update-source lo
  !
  address-family l2vpn evpn
    neighbor 1.1.1.1 activate
    advertise-all-vni  # Advertise all VNIs this router knows about
  exit-address-family
!
# Start OSPF routing process
router ospf
!
end
EOF