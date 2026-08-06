# Active Directory Domain Controller Deployment

## Overview

This document describes the deployment and configuration of the primary Active Directory Domain Controller used throughout the Enterprise IT Lab.

The Domain Controller provides centralized authentication, authorization, DNS services, and directory management for the entire enterprise environment.

It serves as the foundation for domain-joined devices, Group Policy, DHCP, file services, certificate services, and future Microsoft infrastructure components.

---

# Objectives

The objectives of this deployment are to:

- Deploy Windows Server 2022
- Configure a static IP address
- Install Active Directory Domain Services (AD DS)
- Install and configure DNS Server
- Create the enterprise domain
- Integrate with the pfSense firewall
- Prepare the environment for enterprise services

---

# Lab Environment

## Virtual Machine Specifications

| Setting | Value |
|----------|-------|
| Hostname | Corp-DC01 |
| Operating System | Windows Server 2022 Standard |
| Role | Domain Controller |
| Virtualization Platform | Oracle VirtualBox |
| CPU | 2 vCPU |
| Memory | 4 GB |
| Storage | 80 GB Dynamic VDI |

---

# Network Configuration

The Domain Controller uses a static IPv4 configuration.

| Setting | Value |
|----------|-------|
| IP Address | 10.10.20.10 |
| Subnet Mask | 255.255.255.0 |
| Default Gateway | 10.10.20.1 |
| Preferred DNS | 10.10.20.10 |
| Alternate DNS | None |

The default gateway points to the pfSense LAN interface while the DNS server points to the Domain Controller itself.

---

# Server Configuration

## Computer Name

```text
Corp-DC01
```

---

## Time Zone

Configured according to the host location.

---

## Windows Updates

Windows should be fully updated before deploying Active Directory.

---

# Installing Active Directory Domain Services

Open

Server Manager

↓

Add Roles and Features

Install:

- Active Directory Domain Services

Required management tools are installed automatically.

---

# Promoting the Server

After AD DS installation:

Select

Promote this server to a Domain Controller

Deployment Type

Add a new forest

Root Domain

corp.internal

Forest Functional Level

Windows Server 2022

Domain Functional Level

Windows Server 2022

DNS Server

Enabled

Global Catalog

Enabled

Read Only Domain Controller

Disabled

Directory Services Restore Mode (DSRM)

Configured with a secure password.

---

# DNS Configuration

The Domain Controller hosts the internal DNS zone.

## Internal Zone

corp.internal

Clients use the Domain Controller as their preferred DNS server.

External DNS queries are forwarded through the network gateway.

---

# Integration with pfSense

The Domain Controller communicates through the pfSense firewall.

| Setting | Value |
|----------|-------|
| Firewall | Corp-FW01 |
| Default Gateway | 10.10.20.1 |
| DNS | Local (10.10.20.10) |

Internet traffic flows through pfSense while Active Directory services remain local.

---

# Installed Roles

Current roles include:

- Active Directory Domain Services
- DNS Server

Future roles planned:

- DHCP Server
- File and Storage Services
- Windows Server Update Services (WSUS)
- Active Directory Certificate Services
- Print and Document Services

---

# Verification

The deployment was verified using the following tests.

## Network Connectivity

```cmd
ping 10.10.20.1
```

Expected Result

Successful replies.

---

## Internet Connectivity

```cmd
ping 8.8.8.8
```

Expected Result

Successful replies.

---

## DNS Resolution

```cmd
nslookup google.com
```

Expected Result

Successful name resolution.

---

## Internet Name Resolution

```cmd
ping google.com
```

Expected Result

Hostname resolves successfully.

---

## Active Directory Verification

```powershell
dcdiag
```

Expected Result

All diagnostic tests pass.

---

```powershell
Get-ADDomain
```

Expected Result

Returns information about the corp.internal domain.

---

# Best Practices

- Use static IP addresses for infrastructure servers.
- Never configure a Domain Controller to use an external DNS server as its preferred DNS.
- Keep Windows Server fully updated.
- Use meaningful server names.
- Document all network configuration changes.
- Create VirtualBox snapshots before major configuration changes.

---

# Troubleshooting

## Domain Promotion Fails

Verify:

- Static IP configuration
- Correct DNS settings
- Windows updates installed

---

## DNS Resolution Issues

Verify:

Preferred DNS

10.10.20.10

Do not use external DNS servers on the Domain Controller.

---

## No Internet Connectivity

Verify:

Default Gateway

10.10.20.1

Verify pfSense WAN connectivity.

---

## Domain Clients Cannot Join

Verify:

- DNS configuration
- Domain Controller availability
- Time synchronization
- Firewall configuration

---

# Lessons Learned

Several important observations were made during deployment.

- Configure a static IP address before installing Active Directory.
- Install DNS together with AD DS.
- The Domain Controller should use itself as its preferred DNS server.
- Internet access is provided through the pfSense firewall.
- Documentation completed immediately after deployment improves long-term maintainability.
- Virtual machine snapshots simplify recovery from configuration errors.

---

# Deployment Checklist

- [x] Windows Server Installed
- [x] Static IP Configured
- [x] Server Renamed
- [x] Active Directory Installed
- [x] DNS Installed
- [x] Domain Created
- [x] pfSense Integrated
- [x] Internet Connectivity Verified
- [x] Documentation Updated
- [x] Snapshot Created

---

# Related Documentation

- ../02-Network-Design/network-topology.md
- ../03-Virtual-Infrastructure/windows-server-build-guide.md
- ../03-Virtual-Infrastructure/pfsense.md

