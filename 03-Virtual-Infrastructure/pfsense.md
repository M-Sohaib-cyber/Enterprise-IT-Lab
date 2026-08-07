# pfSense Firewall Deployment

## Overview

pfSense Community Edition (CE) is deployed as the perimeter firewall for the Enterprise IT Lab. It provides secure routing between the internet and the internal enterprise network while enforcing network segmentation between servers and client devices.

The firewall performs the following functions:

- Internet gateway
- Network Address Translation (NAT)
- Firewall protection
- Internal network routing
- Default gateway for all internal devices
- Foundation for future VPN, IDS/IPS, DHCP Relay, and firewall policies

---

# Objectives

The objectives of this deployment are to:

- Deploy pfSense CE 2.8.1
- Configure internet connectivity
- Create separate Server and Client networks
- Route traffic between internal networks
- Integrate with Microsoft Active Directory
- Build a realistic enterprise network

---

# Lab Environment

## Host Machine

- Oracle VirtualBox
- Windows Host Operating System

## Virtual Machine

| Setting | Value |
|----------|-------|
| Name | Corp-FW01 |
| Operating System | FreeBSD (64-bit) |
| Software | pfSense CE 2.8.1 |
| CPU | 2 vCPU |
| Memory | 2 GB |
| Storage | 20 GB Dynamic VDI |

---

# VirtualBox Network Configuration

Three virtual network adapters are used.

## Adapter 1

Purpose

Internet connectivity

Configuration

Attached To

NAT

---

## Adapter 2

Purpose

Enterprise Server Network

Configuration

Attached To

NAT Network

Network Name

Corp-Core

---

## Adapter 3

Purpose

Enterprise Client Network

Configuration

Attached To

NAT Network

Network Name

Corp-Clients

---

# Network Design

| Interface | Virtual Adapter | Network | Address |
|-----------|-----------------|---------|----------|
| WAN | em0 | VirtualBox NAT | DHCP |
| LAN | em1 | Corp-Core | 10.10.20.1/24 |
| OPT1 | em2 | Corp-Clients | 10.10.30.1/24 |

---

# Installation

## Download

Download the latest Netgate Installer ISO from the official Netgate website.

---

## Create Virtual Machine

Create a new VirtualBox virtual machine using the specifications listed above.

Attach the Netgate Installer ISO before powering on the virtual machine.

---

## Boot Installer

Accept the License Agreement.

Select

Install pfSense

---

# Interface Assignment

## WAN

Assign

em0

Configuration

DHCP

No manual IP configuration is required.

---

## LAN

Assign

em1

Configuration

Static

IP Address

10.10.20.1/24

During installation the installer temporarily requires a DHCP range.

DHCP Range

Start

10.10.20.100

End

10.10.20.199

---

## Install pfSense CE

Select

Install CE

Version

Current Stable Version (2.8.1)

Filesystem

ZFS

Partition Scheme

GPT

Virtual Device

Stripe

Disk

20 GB Virtual Disk

Confirm disk erase.

Allow installation to complete.

---

## Reboot

Before rebooting:

Remove the installation ISO from the virtual optical drive.

Failure to remove the ISO causes the virtual machine to boot back into the installer.

---

# Initial Interface Configuration

After installation completes:

Select

Assign Interfaces

Assign:

WAN

em0

LAN

em1

Optional Interface

em2

Result

WAN → em0

LAN → em1

OPT1 → em2

---

# Configure OPT1

Navigate to

Set Interface IP Address

Configure

OPT1

Settings

IPv4

Static

Address

10.10.30.1

Subnet

24

Gateway

None

IPv6

Disabled

DHCP Server

Disabled

---

# Final Configuration

| Interface | Address |
|-----------|----------|
| WAN | DHCP (10.0.2.x) |
| LAN | 10.10.20.1/24 |
| OPT1 | 10.10.30.1/24 |

---

# Integration with Windows Server

The Active Directory Domain Controller uses the following configuration.

Hostname

Corp-DC01

IP Address

10.10.20.10

Subnet

255.255.255.0

Default Gateway

10.10.20.1

Preferred DNS

10.10.20.10

The Domain Controller continues to use itself as its preferred DNS server.

---

# Verification

## Verify Firewall

Ping

10.10.20.1

Expected Result

Successful replies.

---

## Verify Internet Connectivity

Ping

8.8.8.8

Expected Result

Successful replies.

---

## Verify DNS

Command

nslookup google.com

Expected Result

Successful DNS resolution.

---

## Verify Name Resolution

Command

ping google.com

Expected Result

Hostname resolves successfully.

---

# Final Network Topology

Internet

↓

VirtualBox NAT

↓

Corp-FW01 (pfSense)

├── WAN (DHCP)

├── LAN (10.10.20.1/24)

└── OPT1 (10.10.30.1/24)

↓

Corp-Core Network

↓

Corp-DC01

10.10.20.10

↓

Future Windows Clients

10.10.30.0/24

---

# Troubleshooting

## Cannot Reach Netgate Servers

Cause

WAN interface incorrectly configured.

Resolution

Verify:

WAN = em0

Configuration = DHCP

---

## Boots Back Into Installer

Cause

Installation ISO still attached.

Resolution

Remove the ISO before rebooting.

---

## WAN Assigned as LAN

Cause

Incorrect interface assignment during installation.

Resolution

Reassign interfaces correctly.

WAN → em0

LAN → em1

OPT1 → em2

---

## Internet Not Working

Verify:

- VirtualBox Adapter 1 uses NAT
- WAN receives DHCP address
- Windows Server default gateway is 10.10.20.1

---

# Lessons Learned

During deployment several important observations were made.

- The current Netgate Installer downloads pfSense CE during installation.
- Internet connectivity on the WAN interface is required during installation.
- The installer initially configures only WAN and LAN.
- Additional interfaces such as OPT1 must be added after installation.
- Removing the installation ISO before reboot is essential.
- VirtualBox snapshots should be created immediately after successful deployment.
- Windows Domain Controllers should continue using themselves as their preferred DNS server.

---

# Screenshots

Include screenshots of:

- Virtual Machine configuration
- Network adapters
- Interface assignment
- Installation complete
- Main pfSense console
- Windows Server network configuration
- Successful connectivity tests

---

# References

- Netgate Documentation
- Oracle VirtualBox Documentation
- Microsoft Windows Server Documentation

## Firewall Rules for OPT1

Issue:
- Windows client received an IP address from DHCP.
- Could not ping pfSense.
- Could not reach Domain Controller.
- No Internet connectivity.

Cause:
OPT1 had no firewall rules configured.
pfSense blocks all traffic by default on newly created interfaces.

Solution:
Firewall → Rules → OPT1

Created rule:

Action: Pass
Protocol: IPv4 Any
Source: OPT1 subnets
Destination: Any

Result:
- Client could ping pfSense.
- Client could reach Domain Controller.
- Internet connectivity restored.

