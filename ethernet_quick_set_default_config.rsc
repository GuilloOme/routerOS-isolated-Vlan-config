# jan/02/1970 00:03:51 by RouterOS 6.40.3
# software id = CXIZ-FJEB
#
# model = 2011UiAS-2HnD
# serial number = 444B04883507
/interface ethernet
set [ find default-name=ether2 ] name=ether2-master
set [ find default-name=ether3 ] master-port=ether2-master
set [ find default-name=ether4 ] master-port=ether2-master
set [ find default-name=ether5 ] master-port=ether2-master
set [ find default-name=ether6 ] name=ether6-master
set [ find default-name=ether7 ] master-port=ether6-master
set [ find default-name=ether8 ] master-port=ether6-master
set [ find default-name=ether9 ] master-port=ether6-master
set [ find default-name=ether10 ] master-port=ether6-master
/interface bridge
add admin-mac=4C:5E:0C:33:B0:56 auto-mac=no comment=defconf name=bridge
/ip neighbor discovery
set ether1 discover=no
/interface list
add comment=defconf name=WAN
add comment=defconf name=LAN
/ip pool
add name=dhcp ranges=192.168.88.10-192.168.88.254
/ip dhcp-server
add address-pool=dhcp disabled=no interface=bridge name=defconf
/interface bridge port
add bridge=bridge comment=defconf interface=ether2-master
add bridge=bridge comment=defconf interface=ether6-master
add bridge=bridge comment=defconf interface=sfp1
/interface list member
add comment=defconf interface=bridge list=LAN
add comment=defconf interface=ether1 list=WAN
/ip address
add address=192.168.88.1/24 comment=defconf interface=ether2-master network=192.168.88.0
/ip dhcp-client
add dhcp-options=hostname,clientid disabled=no interface=ether1
/ip dhcp-server network
add address=192.168.88.0/24 comment=defconf gateway=192.168.88.1
/ip dns
set allow-remote-requests=yes
/ip dns static
add address=192.168.88.1 name=router.lan
/ip firewall filter
add action=accept chain=input comment="defconf: accept established,related,untracked" connection-state=established,related,untracked
add action=drop chain=input comment="defconf: drop invalid" connection-state=invalid
add action=accept chain=input comment="defconf: accept ICMP" protocol=icmp
add action=drop chain=input comment="defconf: drop all not coming from LAN" in-interface-list=!LAN
add action=accept chain=forward comment="defconf: accept in ipsec policy" ipsec-policy=in,ipsec
add action=accept chain=forward comment="defconf: accept out ipsec policy" ipsec-policy=out,ipsec
add action=fasttrack-connection chain=forward comment="defconf: fasttrack" connection-state=established,related
add action=accept chain=forward comment="defconf: accept established,related, untracked" connection-state=established,related,untracked
add action=drop chain=forward comment="defconf: drop invalid" connection-state=invalid
add action=drop chain=forward comment="defconf:  drop all from WAN not DSTNATed" connection-nat-state=!dstnat connection-state=new \
    in-interface-list=WAN
/ip firewall nat
add action=masquerade chain=srcnat comment="defconf: masquerade" ipsec-policy=out,none out-interface-list=WAN
/tool mac-server
set [ find default=yes ] disabled=yes
add interface=bridge
/tool mac-server mac-winbox
set [ find default=yes ] disabled=yes
add interface=bridge

