#!/bin/sh

# Start a vtysh session to configure the FRRouting (FRR) router
vtysh << EOF
# Enter configuration mode
configure terminal
!
# Disable IPv6 forwarding
no ipv6 forwarding
!
# Configure interface eth0 with IP address 10.1.1.1 and subnet mask /30
interface eth0
  ip address 10.1.1.1/30
!
# Configure interface eth1 with IP address 10.1.1.5 and subnet mask /30
interface eth1
  ip address 10.1.1.5/30
!
# Configure interface eth2 with IP address 10.1.1.9 and subnet mask /30
interface eth2
  ip address 10.1.1.9/30
!
# Configure loopback interface with IP address 1.1.1.1/32
interface lo
  ip address 1.1.1.1/32
!
# BGP configuration for ASN 1
router bgp 1
  # Define a peer-group named 'ibgp'
  neighbor ibgp peer-group
  # Set remote AS for peer-group 'ibgp' to 1 (iBGP)
  neighbor ibgp remote-as 1
  # Use loopback interface as the source of BGP updates
  neighbor ibgp update-source lo
  # Listen for BGP peers in the 1.1.1.0/29 subnet and associate them with the 'ibgp' peer-group
  bgp listen range 1.1.1.0/29 peer-group ibgp
  !
  # Configure EVPN address family
  address-family l2vpn evpn
    # Activate the 'ibgp' peer-group in EVPN address family
    neighbor ibgp activate
    # Make peers in 'ibgp' route reflector clients
    neighbor ibgp route-reflector-client
  exit-address-family
!
# Enable OSPF routing
router ospf
  # Include all interfaces in OSPF area 0
  network 0.0.0.0/0 area 0
!
# Enter line configuration mode for VTY lines (usually for remote access like SSH)
line vty
!
# Exit configuration mode
end
EOF



////////////////////////////


!
no ipv6 forwarding
!
interface eth0
  ip address 10.1.1.1/30
!
interface eth1
  ip address 10.1.1.5/30
!
interface eth2
  ip address 10.1.1.9/30
!
interface lo
  ip address 1.1.1.1/32
!
router bgp 1
  neighbor ibgp peer-group
  neighbor ibgp remote-as 1
  neighbor ibgp update-source lo
  bgp listen range 1.1.1.0/29 peer-group ibgp
  !
  address-family l2vpn evpn
    neighbor ibgp activate
    neighbor ibgp route-reflector-client
  exit-address-family
!
router ospf
  network 0.0.0.0/0 area 0
!
line vty
!