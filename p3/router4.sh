#!/bin/sh

# Create and configure the bridge interface
ip link add br0 type bridge
ip link set dev br0 up
# Create VXLAN with the same VNI (10)
ip link add vxlan10 type vxlan id 10 dstport 4789
ip link set dev vxlan10 up
# Add interfaces to the bridge
brctl addif br0 vxlan10
brctl addif br0 eth0  # Connect eth0 to bridge

# Configure the router using vtysh
vtysh << EOF
configure terminal
!
# Disable IPv6 forwarding
no ipv6 forwarding
!
# Configure eth2 with IP and enable OSPF
interface eth2
  ip address 10.1.1.10/30
  ip ospf area 0
!
# Configure loopback with IP and enable OSPF
interface lo
  ip address 1.1.1.4/32
  ip ospf area 0
!
# BGP setup for EVPN
router bgp 1
  neighbor 1.1.1.1 remote-as 1
  neighbor 1.1.1.1 update-source lo
  !
  address-family l2vpn evpn
    neighbor 1.1.1.1 activate
    advertise-all-vni
  !
 exit-address-family
!
router ospf
!
end
EOF