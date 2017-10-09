# oct/08/2017 15:47:54 by RouterOS 6.40.4
# software id = CXIZ-FJEB
#
# model = 2011UiAS-2HnD
# serial number = 444B04883507
/interface ethernet set [ find default-name=ether1 ] name=ether1_WLAN
/interface ethernet set [ find default-name=ether2 ] name=ether2-master_Laptop
/interface ethernet set [ find default-name=ether3 ] master-port=ether2-master_Laptop name=ether3_unify_AP
/interface ethernet set [ find default-name=ether4 ] master-port=ether2-master_Laptop
/interface ethernet set [ find default-name=ether5 ] master-port=ether2-master_Laptop
/interface ethernet set [ find default-name=ether6 ] name=ether6-master_Philips_hue
/interface ethernet set [ find default-name=ether7 ] master-port=ether6-master_Philips_hue
/interface ethernet set [ find default-name=ether8 ] master-port=ether6-master_Philips_hue
/interface ethernet set [ find default-name=ether9 ] master-port=ether6-master_Philips_hue
/interface ethernet set [ find default-name=ether10 ] master-port=ether6-master_Philips_hue
/interface ethernet set [ find default-name=sfp1 ] disabled=yes
/interface bridge add admin-mac=4C:5E:0C:33:B0:56 auto-mac=no comment=defconf name=bridge0_admin
/ip neighbor discovery set ether1_WLAN discover=no
/ip neighbor discovery set ether2-master_Laptop discover=no
/ip neighbor discovery set ether3_unify_AP discover=no
/ip neighbor discovery set ether4 discover=no
/ip neighbor discovery set ether5 discover=no
/ip neighbor discovery set ether6-master_Philips_hue discover=no
/ip neighbor discovery set ether7 discover=no
/ip neighbor discovery set ether8 discover=no
/ip neighbor discovery set ether9 discover=no
/ip neighbor discovery set ether10 discover=no
/ip neighbor discovery set sfp1 discover=no
/ip neighbor discovery set bridge0_admin discover=no
/interface list add comment=defconf name=WAN
/interface list add comment=defconf name=LAN
/ip pool add name=dhcp_pool0 ranges=192.168.88.10-192.168.88.254
/ip dhcp-server add address-pool=dhcp_pool0 disabled=no interface=bridge0_admin name=dhcp0
/interface bridge port add bridge=bridge0_admin comment=defconf interface=ether2-master_Laptop
/interface bridge port add bridge=bridge0_admin comment=defconf interface=ether6-master_Philips_hue
/interface bridge port add bridge=bridge0_admin comment=defconf interface=sfp1
/interface list member add comment=defconf interface=bridge0_admin list=LAN
/interface list member add comment=defconf interface=ether1_WLAN list=WAN
/ip address add address=192.168.88.1/24 interface=ether2-master_Laptop network=192.168.88.0
/ip dhcp-client add dhcp-options=hostname,clientid disabled=no interface=ether1_WLAN
/ip dhcp-server network add address=192.168.88.0/24 comment=admin gateway=192.168.88.1
/ip dns set allow-remote-requests=yes cache-size=4096KiB
/ip dns static add address=192.168.88.1 name=router.lan
/ip firewall address-list add address=192.168.88.2-192.168.88.254 list=admin_address
/ip firewall filter add action=accept chain=input comment="defconf: accept established,related,untracked" connection-state=established,related,untracked
/ip firewall filter add action=accept chain=input comment="Accept Admin address range" src-address-list=admin_address
/ip firewall filter add action=accept chain=input comment="Accept all coming from LAN" in-interface-list=LAN
/ip firewall filter add action=drop chain=input comment="defconf: drop invalid" connection-state=invalid
/ip firewall filter add action=accept chain=input comment="defconf: accept ICMP" in-interface-list=!WAN protocol=icmp
/ip firewall filter add action=drop chain=input comment="Drop anything else"
/ip firewall filter add action=accept chain=forward comment="defconf: accept in ipsec policy" ipsec-policy=in,ipsec
/ip firewall filter add action=accept chain=forward comment="defconf: accept out ipsec policy" ipsec-policy=out,ipsec
/ip firewall filter add action=fasttrack-connection chain=forward comment="defconf: fasttrack" connection-state=established,related disabled=yes
/ip firewall filter add action=accept chain=forward comment="defconf: accept established,related, untracked" connection-state=established,related,untracked
/ip firewall filter add action=drop chain=forward comment="defconf: drop invalid" connection-state=invalid
/ip firewall filter add action=drop chain=forward comment="defconf:  drop all from WAN not DSTNATed" connection-nat-state=!dstnat connection-state=new in-interface-list=WAN
/ip firewall mangle add action=mark-connection chain=forward comment=admin-dw-connection dst-address-list=admin_address in-interface-list=WAN new-connection-mark=admin-dw-connection passthrough=yes
/ip firewall mangle add action=mark-packet chain=prerouting connection-mark=admin-dw-connection new-packet-mark=admin-out-packet passthrough=yes
/ip firewall mangle add action=mark-connection chain=prerouting comment=admin-up-connection in-interface=bridge0_admin new-connection-mark=admin-up-connection passthrough=yes src-address-list=admin_address
/ip firewall mangle add action=mark-packet chain=prerouting connection-mark=admin-up-connection new-packet-mark=admin-out-packet passthrough=yes
/ip firewall nat add action=masquerade chain=srcnat comment="defconf: masquerade" ipsec-policy=out,none out-interface-list=WAN

/queue simple add burst-limit=10M/20M burst-threshold=5M/10M burst-time=5s/5s limit-at=5M/10M max-limit=6M/12M name="admin queue" packet-marks=admin-out-packet queue=pcq-upload-default/pcq-download-default target=192.168.88.0/24


/ip service set telnet disabled=yes
/ip service set ftp disabled=yes
/ip service set www address=192.168.88.0/24
/ip service set ssh address=192.168.88.0/24 port=65432
/ip service set api disabled=yes
/ip service set winbox address=192.168.88.0/24
/ip service set api-ssl disabled=yes
/ip ssh set strong-crypto=yes
/lcd pin set pin-number=2356
/system clock set time-zone-name=America/Toronto
/tool bandwidth-server set enabled=no
/tool mac-server set [ find default=yes ] disabled=yes
/tool mac-server add disabled=yes interface=bridge0_admin
/tool mac-server mac-winbox set [ find default=yes ] disabled=yes
/tool mac-server mac-winbox add disabled=yes interface=bridge0_admin
/tool mac-server ping set enabled=no

#
## vlan 7 config
#
/interface vlan add interface=bridge0_admin name=vlan7 vlan-id=700
/ip neighbor discovery set vlan7 discover=no
/ip pool add name=dhcp_pool7 ranges=10.7.0.10-10.7.0.254
/ip dhcp-server add address-pool=dhcp_pool7 disabled=no interface=vlan7 name=dhcp7
/ip address add address=10.7.0.1/24 interface=vlan7 network=10.7.0.0
/ip dhcp-server network add address=10.7.0.0/24 comment=vlan7 gateway=10.7.0.1

/ip firewall address-list add address=10.7.0.0/24 list=vlan7
/ip firewall filter add action=drop chain=forward comment="Internal vlan7 traffic only" dst-address-list=vlan7 in-interface-list=!WAN src-address-list=!vlan7
/ip firewall nat add action=masquerade chain=srcnat out-interface=ether1_WLAN src-address=10.7.0.0/24

#
## vlan 8 config: 8-2055
#
/interface vlan add interface=bridge0_admin name=vlan8 vlan-id=800
/ip neighbor discovery set vlan8 discover=no
/ip pool add name=dhcp_pool8 ranges=10.8.0.10-10.8.0.254
/ip dhcp-server add address-pool=dhcp_pool8 disabled=no interface=vlan8 name=dhcp8
/ip address add address=10.8.0.1/24 interface=vlan8 network=10.8.0.0
/ip dhcp-server network add address=10.8.0.0/24 comment=vlan8 gateway=10.8.0.1

/ip firewall address-list add address=10.8.0.0/24 list=vlan8
/ip firewall filter add action=drop chain=forward comment="Internal vlan8 traffic only" dst-address-list=vlan8 in-interface-list=!WAN src-address-list=!vlan8
/ip firewall mangle add action=mark-connection chain=forward comment=vlan8-dw-connexion in-interface-list=WAN new-connection-mark=vlan8-dw-connexion passthrough=yes src-address-list=vlan8
/ip firewall mangle add action=mark-packet chain=prerouting connection-mark=vlan8-dw-connexion new-packet-mark=vlan8-out-packet passthrough=yes
/ip firewall mangle add action=mark-connection chain=prerouting comment=vlan8-up-connexion in-interface=vlan8 new-connection-mark=vlan8-up-connexion passthrough=yes src-address-list=vlan8
/ip firewall mangle add action=mark-packet chain=prerouting connection-mark=vlan8-up-connexion new-packet-mark=vlan8-out-packet passthrough=yes
/ip firewall nat add action=masquerade chain=srcnat out-interface=ether1_WLAN src-address=10.8.0.0/24

/queue simple add burst-limit=10M/20M burst-threshold=5M/10M burst-time=5s/5s limit-at=5M/10M max-limit=6M/12M name="vlan8 queue" packet-marks=vlan8-out-packet queue=pcq-upload-default/pcq-download-default target=vlan8

#
## vlan 9 config: invite-2055
#
/interface vlan add interface=bridge0_admin name=vlan9 vlan-id=900
/ip neighbor discovery set vlan9 discover=no
/ip pool add name=dhcp_pool9 ranges=10.9.0.10-10.9.0.254
/ip dhcp-server add address-pool=dhcp_pool9 disabled=no interface=vlan9 name=dhcp9
/ip address add address=10.9.0.1/24 interface=vlan9 network=10.9.0.0
/ip dhcp-server network add address=10.9.0.0/24 comment=vlan9 gateway=10.9.0.1

/ip firewall address-list add address=10.9.0.0/24 list=vlan9
/ip firewall filter add action=drop chain=forward comment="Internal vlan9 traffic only" dst-address-list=vlan9 in-interface-list=!WAN src-address-list=!vlan9
/ip firewall mangle add action=mark-connection chain=forward comment=vlan9-dw-connexion in-interface-list=WAN new-connection-mark=vlan9-dw-connexion passthrough=yes src-address-list=vlan9
/ip firewall mangle add action=mark-packet chain=prerouting connection-mark=vlan9-dw-connexion new-packet-mark=vlan9-out-packet passthrough=yes
/ip firewall mangle add action=mark-connection chain=prerouting comment=vlan9-up-connexion in-interface=vlan9 new-connection-mark=vlan9-up-connexion passthrough=yes src-address-list=vlan9
/ip firewall mangle add action=mark-packet chain=prerouting connection-mark=vlan9-up-connexion new-packet-mark=vlan9-out-packet passthrough=yes
/ip firewall nat add action=masquerade chain=srcnat out-interface=ether1_WLAN src-address=10.9.0.0/24

/queue simple add burst-limit=5M/10M burst-threshold=4M/7M burst-time=3s/3s limit-at=3M/6M max-limit=4M/7M name="vlan9 queue" packet-marks=vlan9-out-packet queue=pcq-upload-default/pcq-download-default target=vlan9
