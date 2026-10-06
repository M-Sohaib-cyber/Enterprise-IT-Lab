# Lab Environment

## Overview

The Enterprise IT Lab is a local virtual environment hosted on Windows 11 using Oracle VirtualBox. pfSense provides routing between virtual networks, and Windows Server and Windows 11 virtual machines provide the current enterprise services and client workload.

## Host and virtualization

| Item | Confirmed information |
|---|---|
| Host operating system | Windows 11 |
| Virtualization platform | Oracle VirtualBox |
| Host model | HP Pavilion x360 Convertible 14-dw0xxx; verified 2026-10-06 |
| CPU | Intel Core i5-1035G1; 4 cores / 8 logical processors; verified 2026-10-06 |
| Installed RAM | 16 GB, 2 x 8 GB; verified 2026-10-06 |
| Host storage and Windows edition | To verify |
| VirtualBox version | To verify |

VM allocations and attachments verified on 2026-10-06 are maintained in the [device inventory](../01-Enterprise-Planning/device-inventory.md).

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

Verification on 2026-10-06 confirmed both lab NAT Networks and their IPv4 prefixes above, with VirtualBox DHCP disabled on each. Corp-CL01 Adapter 1 uses NAT Network Corp-Clients; pfSense OPT1 supplies its tested DHCP configuration. All four VM network attachments are now verified in the device inventory; uninspected settings remain to verify. See [DHCP verification](../04-Active-Directory/dhcp.md).

## Virtual storage and snapshots - verified 2026-10-06

VM storage uses VDI disks with snapshots/differencing disks. Virtual disk encryption is disabled. Existing historical snapshots were intentionally retained; some older names/descriptions contain stale or incorrect metadata and do not represent current live configuration.

Guest Additions were installed on `Corp-DC01` and `Corp-FS01`, and bidirectional clipboard was tested successfully on both. New powered-off snapshots were created:

- `DC01 - Patched and Guest Additions - 2026-10-06`
- `FS01 - Patched and Guest Additions - 2026-10-06`

Post-patch checks are recorded in the [DC build record](../03-Virtual-Infrastructure/windows-server-build-guide.md#patch-and-post-update-verification---2026-10-06) and [file-server record](../03-Virtual-Infrastructure/file-server.md#patch-and-post-update-verification---2026-10-06).

## Implemented services

- pfSense routing and firewalling
- Active Directory Domain Services
- Active Directory-integrated DNS
- Windows domain membership and authentication
- SMB file sharing and mapped drives
- Multiple user and computer Group Policy configurations

The lab does not currently claim implementation of technologies that appear only as future ideas elsewhere in the repository.
