---
title: Network Engineer
roadmap: network-engineer
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, networking]
---

# Network Engineer

> roadmap.sh: https://roadmap.sh/network-engineer

Track for the **Network Engineer** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %.

## Nodes

### Fundamentals
- [ ] Introduction
- [ ] What are Networks
- [ ] How does the Internet work
- [ ] The Internet
- [ ] Methodologies
- [ ] Common Network Issues
- [ ] Troubleshooting

### Network Types & Topologies
- [ ] LAN
- [ ] WAN
- [ ] MAN
- [ ] PAN
- [ ] WLAN
- [ ] SAN
- [ ] Client-Server Network
- [ ] Peer-to-Peer Network
- [ ] Virtual Networks
- [ ] Network Devices
- [ ] Transmission Media Types

### OSI & TCP/IP Models
- [ ] OSI Model
- [ ] TCP/IP Model
- [ ] Physical Layer
- [ ] Data Link Layer
- [ ] Network Layer
- [ ] Transport Layer
- [ ] Session Layer
- [ ] Presentation Layer
- [ ] Application Layer
- [ ] Frame
- [ ] Package
- [ ] Socket
- [ ] Port

### IP Addressing & Subnetting
- [ ] IP Address
- [ ] IP Addressing
- [ ] IPv4 vs IPv6
- [ ] MAC Address
- [ ] IP vs MAC vs ARP
- [ ] ARP
- [ ] Public vs Private Addresses
- [ ] CIDR
- [ ] Subnetting
- [ ] Subnet Masks
- [ ] VLSM
- [ ] Supernetting
- [ ] NAT vs PAT
- [ ] Default Gateway
- [ ] Host
- [ ] Client
- [ ] Server

### Network Hardware
- [ ] Hub
- [ ] Switches
- [ ] Routers
- [ ] Modems
- [ ] Access Points
- [ ] Access Points & Controllers
- [ ] MAC Address Tables

### Switching
- [ ] Switching
- [ ] VLANs
- [ ] STP (Spanning Tree Protocol)
- [ ] Link Aggregation
- [ ] VXLAN

### Routing
- [ ] Routing
- [ ] Static vs Dynamic Routing
- [ ] RIP
- [ ] OSPF
- [ ] EIGRP
- [ ] BGP
- [ ] VRFs
- [ ] MPLS
- [ ] ACLs

### Protocols & Services
- [ ] Protocol
- [ ] DNS
- [ ] DHCP
- [ ] HTTP / HTTPS
- [ ] FTP / SFTP
- [ ] TFTP
- [ ] SMTP / IMAP
- [ ] SSH
- [ ] SNMP
- [ ] NTP
- [ ] SNTP
- [ ] TCP
- [ ] APIs for Networking

### Wireless & Mobile
- [ ] Wireless Networking
- [ ] WiFi Standards
- [ ] Wireless Security
- [ ] WPA vs WPS
- [ ] Bluetooth Basics
- [ ] Mobile Networks
- [ ] Hotspot and Tethering

### Performance & QoS
- [ ] Bandwidth
- [ ] Throughput
- [ ] Latency
- [ ] QoS (Quality of Service)
- [ ] Traffic Management
- [ ] Traffic Shaping
- [ ] Packet Prioritization

### High Availability & Load Balancing
- [ ] High Availability
- [ ] Failover
- [ ] Load Balancing
- [ ] Load Balancer
- [ ] Round Robin
- [ ] Least Connections
- [ ] HSRP
- [ ] VRRP
- [ ] GLBP

### Network Security
- [ ] Network Access
- [ ] Network Attacks
- [ ] Firewalls
- [ ] Packet Filtering
- [ ] Stateful Inspection
- [ ] Circuit-Level Gateway
- [ ] IDS / IPS
- [ ] DoS / DDoS
- [ ] Security Groups
- [ ] Zero Trust Architecture
- [ ] Encryption Basics
- [ ] SSL / TLS

### VPN & Tunneling
- [ ] VPN
- [ ] VPNs
- [ ] Tunneling & VPNs
- [ ] IPsec vs SSL VPN
- [ ] Site-to-Site vs Remote Access
- [ ] GRE/IPsec Tunnels
- [ ] MPLS VPN
- [ ] Cloud VPN

### Cloud & SD-WAN
- [ ] Cloud
- [ ] Cloud Networking Basics
- [ ] Cloud Network Types
- [ ] Cloud Routing
- [ ] SD-WAN
- [ ] AWS
- [ ] Azure
- [ ] GCP
- [ ] Google
- [ ] Cloudflare
- [ ] OpenDNS
- [ ] Quad9
- [ ] Cloud Certifications

### Automation & IaC
- [ ] Network Automation
- [ ] Infrastructure as Code
- [ ] Ansible
- [ ] Terraform
- [ ] Linux for Networking
- [ ] Shell & Scripting

### Tools & Simulators
- [ ] Network Simulators
- [ ] Cisco Packet Tracer
- [ ] GNS3
- [ ] EVE-NG
- [ ] Wireshark
- [ ] Packet Analysis
- [ ] Nmap
- [ ] Ping
- [ ] Traceroute / Tracert
- [ ] Netstat
- [ ] Nslookup
- [ ] ipconfig / ifconfig
- [ ] Speedtest
- [ ] Proxy

### Observability & Monitoring
- [ ] Observability
- [ ] NetFlow / sFlow
- [ ] Prometheus
- [ ] Grafana
- [ ] Datadog
- [ ] Dynatrace

### Certifications
- [ ] CCNA
- [ ] CCNP
- [ ] CompTIA Network+
- [ ] CompTIA Security+

### Web & Next Steps
- [ ] Web Application
- [ ] Next Generation

## Notes
<!-- Index your notes/ files here, newest first. -->
- _none yet — add with: a new file in `notes/`_

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build and segment a home/lab network with VLANs, an ACL-based firewall, and a DHCP/DNS server (e.g. pfSense + managed switch), then capture and analyze the traffic in Wireshark.
- Model a multi-site enterprise topology in GNS3 or Cisco Packet Tracer: configure OSPF/BGP routing, a site-to-site IPsec VPN, and HSRP failover, then document the convergence behavior.
- Automate device configuration and drift detection across a fleet of routers/switches with Ansible (or Netmiko/Python), and expose interface/latency metrics via SNMP/NetFlow into Prometheus + Grafana.
