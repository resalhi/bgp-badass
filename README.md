# BGP Badass

Welcome to the **BGP Badass** repository! This project explores the Border Gateway Protocol (BGP), a core component of the internet's routing infrastructure. We will simulate a network and configure it using GNS3 with docker images.

---

## What is BGP?

The **Border Gateway Protocol (BGP)** is the protocol that makes the internet work by exchanging routing information between autonomous systems (AS). It controls how data is routed across the internet through the exchange of reachability information between BGP systems.

## What is VXLAN and how is it different from VLAN?

VXLAN (Virtual Extensible LAN) is a Layer 2 overlay network protocol over a Layer 3 network.

It allows you to create virtual Layer 2 networks over IP infrastructure, supporting much more scale than VLAN.

In short: VXLAN solves VLAN limitations (especially scalability and multi-DC connectivity) using tunneling and control-plane learning.

| Feature | **VLAN** | **VXLAN** |
|--------|---------|-----------|
| Layer | Layer 2 | Layer 2 over Layer 3 (overlay) |
| Identifier | 12-bit VLAN ID (4096 max) | 24-bit VNI (16 million+) |
| Scalability | Limited | Highly scalable |
| Transport | Ethernet only | IP network (UDP encapsulation) |
| Learning | Flood and learn (classic) | BGP EVPN (control-plane learning) |

## What is a Switch?

A switch is a Layer 2 device that connects devices within a LAN and forwards Ethernet frames based on MAC addresses.

It builds a MAC address table dynamically by learning which MACs are on which ports.

Supports full-duplex communication, VLANs, and segmentation.

## What is a Bridge?

A bridge is a simpler version of a switch.

It connects two or more network segments and also works at Layer 2, forwarding frames based on MAC addresses.

Originally software or hardware that connects segments to reduce collision domains.

Modern switches are essentially multi-port bridges with added features.

## Differences between Broadcast and Multicast

| Type | **Broadcast** | **Multicast** |
|------|---------------|----------------|
| Destination | All devices in the network | Specific group of subscribed devices |
| Efficiency | Less efficient (everyone receives) | More efficient (only group members receive) |
| Address range | MAC: `FF:FF:FF:FF:FF:FF` | MACs starting with `01:00:5E` (IPv4) |
| Use cases | ARP, DHCP | Streaming, group chat, routing protocols (e.g., OSPF, PIM) |

In short:

Broadcast = “Everyone gets it.”

Multicast = “Only those who asked for it get it.”

## What is BGP-EVPN?

- BGP-EVPN (Border Gateway Protocol - Ethernet VPN) is a control plane solution for VXLAN networks.
  
- It uses BGP to distribute MAC address and IP address mappings across the network.
  
- Instead of relying on flood-and-learn like traditional VXLAN, it learns who is where via BGP advertisements.
  
- EVPN helps build layer 2 (MAC learning) and layer 3 (IP routing) connectivity across a large, scalable network, like a data center or WAN.

## The Principle of Route Reflection

In BGP, every router (by default) needs to connect to every other router (full mesh), which becomes hard to manage.

Route reflection allows one router (the Route Reflector, or RR) to redistribute routes between clients.

Clients send updates to the RR, and the RR forwards them to other clients, avoiding full-mesh connectivity.

It reduces the number of BGP sessions needed — crucial in large EVPN setups.

## What VTEP Means (VTEP = VXLAN Tunnel Endpoint).

It is the device (usually a switch or server) that encapsulates original Ethernet frames inside VXLAN packets and sends them over the IP network.

- It has two sides:

Underlay side (IP network)

Overlay side (original Ethernet network / VLANs)

## What VNI Means (VNI = VXLAN Network Identifier).

It's like a VLAN ID but for VXLAN — a 24-bit number (0–16 million) that identifies different VXLAN segments.

Each VXLAN segment (like a virtual LAN) has its own VNI, keeping traffic isolated.

## The Difference Between Type 2 and Type 3 Routes (in BGP-EVPN)

In BGP-EVPN, several "route types" exist.

- Type 2 (MAC/IP Advertisement Route):

  Used to advertise a MAC address and its corresponding IP address.
  
  Basically says, "This MAC (and maybe this IP) lives behind me."
  
- Type 3 (Inclusive Multicast Ethernet Tag Route):

  Used to set up multicast or broadcast delivery groups for VXLAN (BUM traffic: Broadcast, Unknown Unicast, Multicast).
  
  It advertises that a VTEP is part of a given VNI's multicast group.

Quick comparison:

| | Type 2 Route | Type 3 Route |
|:-|:-|:-|
| Purpose | MAC/IP advertisement | Multicast group membership |
| Contains | MAC, IP, VNI, VTEP IP | VNI, VTEP IP |
| Triggers | When a device learns a MAC or IP | When a VTEP joins a VNI |

---

## Learning Resources

- [BGP RFC 4271](https://tools.ietf.org/html/rfc4271): Official specification of BGP.
- [BGP RFC 4271](https://tools.ietf.org/html/rfc7348): Official specification of BGP.
- [BGP RFC 4271](https://tools.ietf.org/html/rfc7432): Official specification of BGP.
- [GNS3](https://docs.gns3.com/docs/): gns3 documentation.
