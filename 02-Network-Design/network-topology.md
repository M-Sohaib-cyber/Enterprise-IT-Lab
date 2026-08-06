# Enterprise Network Topology

## Overview

This document describes the network architecture implemented within the Enterprise IT Lab.

The objective of this design is to simulate a modern enterprise network by separating infrastructure into dedicated network segments protected by a central firewall. The environment uses Microsoft Active Directory for identity management, pfSense as the perimeter firewall, and VirtualBox as the virtualization platform.

This topology provides a scalable foundation for deploying enterprise services such as DHCP, Group Policy, File Services, WSUS, Certificate Services, and monitoring solutions.

---

# Objectives

The network is designed to achieve the following objectives:

- Provide secure Internet connectivity
- Deploy Microsoft Active Directory
- Separate servers from client workstations
- Improve security through network segmentation
- Simulate a real enterprise infrastructure
- Support future enterprise services
- Provide a reproducible lab environment for learning and portfolio development

---

# Enterprise Architecture

The lab currently consists of three primary network segments.

| Network | Purpose |
|----------|---------|
| Internet | External connectivity |
| Corp-Core | Servers and Infrastructure |
| Corp-Clients | Enterprise Workstations |

The pfSense firewall routes traffic between all networks while enforcing security boundaries.

---

# Current Network Topology

Internet

↓

VirtualBox NAT

↓

Corp-FW01 (pfSense)

├── WAN (DHCP)

├── LAN (10.10.20.1/24)

└── OPT1 (10.10.30.1/24)

↓

Corp-Core

↓

Corp-DC01

↓

Active Directory

↓

DNS

---

# IP Addressing Scheme

| Network | Subnet | Gateway |
|----------|------------|------------|
| Internet | VirtualBox NAT | DHCP |
| Corp-Core | 10.10.20.0/24 | 10.10.20.1 |
| Corp-Clients | 10.10.30.0/24 | 10.10.30.1 |

---

# Device Inventory

| Device | Hostname | Role | Address |
|----------|------------|------------|------------|
| Firewall | Corp-FW01 | pfSense | WAN DHCP |
| Firewall | Corp-FW01 | LAN | 10.10.20.1 |
| Firewall | Corp-FW01 | OPT1 | 10.10.30.1 |
| Domain Controller | Corp-DC01 | Active Directory, DNS | 10.10.20.10 |

Future devices

| Device | Planned Role |
|----------|------------|
| Windows 11 Enterprise | Domain Client |
| File Server | SMB Storage |
| WSUS | Patch Management |
| Certificate Authority | PKI |
| Monitoring Server | Infrastructure Monitoring |

---

# Network Segmentation

## Internet

The Internet network provides outbound connectivity through VirtualBox NAT.

No internal services are hosted within this network.

---

## Corp-Core

The Corp-Core network hosts enterprise infrastructure.

Current services include:

- Active Directory
- DNS
- Windows Server Administration

Future services include:

- DHCP
- File Services
- WSUS
- Certificate Services
- Monitoring

---

## Corp-Clients

The Corp-Clients network is dedicated to end-user devices.

Separating users from servers reduces risk and reflects enterprise best practices.

---

# Routing Design

All internal routing is performed by pfSense.

| Source | Destination | Route |
|---------|------------|------------|
| Corp-Core | Internet | pfSense WAN |
| Corp-Clients | Internet | pfSense WAN |
| Corp-Clients | Domain Controller | pfSense Internal Routing |

The firewall acts as the default gateway for all internal networks.

---

# DNS Design

Internal DNS is provided exclusively by Active Directory.

| Service | Server |
|----------|---------|
| Active Directory DNS | Corp-DC01 |
| Client DNS | Corp-DC01 |
| External DNS | Forwarded by DNS Server |

The Domain Controller uses itself as its preferred DNS server.

---

# Security Design

Security is achieved through network segmentation.

Key principles include:

- Dedicated firewall
- Separate server and client networks
- Private addressing
- Controlled routing
- Future firewall policies between VLANs and internal networks
- Least privilege administration

---

# Verification

The deployment has been verified using the following tests.

| Test | Status |
|---------|---------|
| pfSense Installed | ✅ |
| WAN Operational | ✅ |
| LAN Operational | ✅ |
| OPT1 Operational | ✅ |
| Active Directory Operational | ✅ |
| DNS Operational | ✅ |
| Internet Connectivity | ✅ |
| Default Gateway Configured | ✅ |

---

# Lessons Learned

During deployment the following observations were made.

- Modern Netgate Installer downloads pfSense during installation.
- WAN connectivity is required before installation can complete.
- Additional interfaces are assigned after installation.
- Removing the installation ISO prevents rebooting back into the installer.
- Network segmentation simplifies future service deployment.
- Infrastructure documentation is significantly easier when completed immediately after deployment.

---

# Future Expansion

The following services will be added as the lab evolves.

- Windows 11 Enterprise
- DHCP Server
- Group Policy
- File Services
- WSUS
- Certificate Services
- Print Services
- osTicket
- Monitoring
- Backup
- Security Hardening

---

# Deployment Checklist

- [x] VirtualBox Networks Created
- [x] pfSense Installed
- [x] WAN Configured
- [x] LAN Configured
- [x] OPT1 Configured
- [x] Windows Server Installed
- [x] Active Directory Installed
- [x] DNS Installed
- [x] Internet Connectivity Verified
- [x] Documentation Updated

---

# Related Documentation

- ../03-Virtual-Infrastructure/pfsense.md
- ../03-Virtual-Infrastructure/windows-server-build-guide.md
- ../04-Active-Directory/domain-controller.md

