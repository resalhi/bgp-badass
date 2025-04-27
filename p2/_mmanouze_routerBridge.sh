#!/bin/sh

# ====================================================================
# routerBridge.sh
# Creates a Linux bridge interface for VXLAN connectivity
# ====================================================================

# Create a bridge interface named br0
# A bridge is a virtual Layer 2 network device that connects multiple 
# network segments, similar to a network switch
ip link add br0 type bridge

# Activate the bridge interface
# The bridge won't forward any traffic until it's brought up
# This is equivalent to turning on a physical switch
ip link set dev br0 up

# ====================================================================
# NEXT STEPS (not in this script):
# 1. Add the VXLAN interface to this bridge (ip link set vxlan10 master br0)
# 2. Add the physical interface to this bridge (ip link set eth1 master br0)
# 3. The bridge will then forward traffic between the VXLAN tunnel and the local network
# ====================================================================