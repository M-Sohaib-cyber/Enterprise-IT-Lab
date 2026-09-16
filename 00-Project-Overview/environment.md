# Lab Environment

## Overview

The Enterprise IT Lab is a local virtual environment hosted on Windows 11 using Oracle VirtualBox. pfSense provides routing between virtual networks, and Windows Server and Windows 11 virtual machines provide the current enterprise services and client workload.

## Host and virtualization

| Item | Confirmed information |
|---|---|
| Host operating system | Windows 11 |
| Virtualization platform | Oracle VirtualBox |
| Host CPU, memory, storage, and edition | To verify |
| VirtualBox version | To verify |

No host hardware specifications are claimed because they are not established by current repository evidence.

## Current lab components

| Component | Platform/OS | Function |
|---|---|---|
| `Corp-FW01` | pfSense CE on a FreeBSD-based VM | Firewall, gateway, NAT, and routing between lab networks |
| `Corp-DC01` | Windows Server 2022 | Active Directory Domain Services and DNS |
| `Corp-FS01` | Windows Server 2022 Standard Evaluation, build 20348 | SMB file sharing for departmental and public resources |
| `Corp-CL01` | Windows 11 Enterprise Evaluation | Domain-joined user workstation and GPO test client |

Authoritative device and address details are maintained in the [device inventory](../01-Enterprise-Planning/device-inventory.md) and [IP addressing reference](../02-Network-Design/ip-addressing.md).

## Logical environment

- Active Directory DNS domain: `corp.internal`
- NetBIOS domain: `CORP`
- Server network: `Corp-Core` - `10.10.20.0/24`
- Client network: `Corp-Clients` - `10.10.30.0/24`
- Internet connectivity: pfSense WAN through VirtualBox NAT

The exact current VirtualBox network attachment and DHCP settings require verification; this document does not infer settings beyond the available records.

## Implemented services

- pfSense routing and firewalling
- Active Directory Domain Services
- Active Directory-integrated DNS
- Windows domain membership and authentication
- SMB file sharing and mapped drives
- Multiple user and computer Group Policy configurations

The lab does not currently claim implementation of technologies that appear only as future ideas elsewhere in the repository.
