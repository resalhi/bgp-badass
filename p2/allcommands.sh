ip adde show eth0 #(optional)
#router 1:

ip addr add 10.1.1.1/24 dev eth0
ip link add name vxlan10 type vxlan id 10 dev eth0 local 10.1.1.1 remote 10.1.1.2 dstport 4789
ip addr add 20.1.1.1/24 dev vxlan10
ip link set dev vxlan10 up
ip link add br0 type bridge
ip link set dev br0 up
brctl addif br0 eth1
brctl addif br0 vxlan10
////////////////
ip addr add 10.1.1.1/24 dev eth0
ip link set dev eth0 up
ip link add name vxlan10 type vxlan id 10 dev eth0 local 10.1.1.1 remote 10.1.1.2 dstport 4789
ip link set dev vxlan10 up
ip link add name br0 type bridge
ip link set dev br0 up
ip link set dev eth1 up
ip link set dev eth1 master br0
ip link set dev vxlan10 master br0
ip addr add 20.1.1.1/24 dev br0
sysctl -w net.ipv4.ip_forward=1






#router 2:

#all from before but few changes
ip addr add 10.1.1.2/24 dev eth0
ip link add name vxlan10 type vxlan id 10 dev eth0 local 10.1.1.2 remote 10.1.1.1 dstport 4789
ip addr add 20.1.1.2/24 dev vxlan10
ip link set dev vxlan10 up
ip link add br0 type bridge
ip link set dev br0 up
brctl addif br0 eth1
brctl addif br0 vxlan10

///////////////////////////
ip addr add 10.1.1.2/24 dev eth0
ip link set dev eth0 up
ip link add name vxlan10 type vxlan id 10 dev eth0 local 10.1.1.2 remote 10.1.1.1 dstport 4789
ip link set dev vxlan10 up
ip link add name br0 type bridge
ip link set dev br0 up
ip link set dev eth1 up
ip link set dev eth1 master br0
ip link set dev vxlan10 master br0
ip addr add 20.1.1.2/24 dev br0
sysctl -w net.ipv4.ip_forward=1





#host 1:

ip addr add 30.1.1.1/24 dev eth1

#host 2:

ip addr add 30.1.1.2/24 dev eth1

#multicast router 1:

ip link add br0 type bridge
ip link set dev br0 up
ip addr add 10.1.1.1/24 dev eth0
ip link add name vxlan10 type vxlan id 10 dev eth0 group 239.1.1.1 dstport 4789
ip addr add 20.1.1.1/24 dev vxlan10
brctl addif br0 eth1
brctl addif br0 vxlan10
ip link set dev vxlan10 up

#milticast router 2:

ip link add br0 type bridge
ip link set dev br0 up
ip addr add 10.1.1.2/24 dev eth0
ip link add name vxlan10 type vxlan id 10 dev eth0 group 239.1.1.1 dstport 4789
ip addr add 20.1.1.2/24 dev vxlan10
brctl addif br0 eth1
brctl addif br0 vxlan10
ip link set dev vxlan10 up
