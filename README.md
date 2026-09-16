# Enterprise IT Lab

This repository documents a portfolio lab built to practise junior and graduate-level IT infrastructure, networking, Windows administration, and security operations. The environment runs in Oracle VirtualBox on a Windows 11 host and uses pfSense, Windows Server 2022, Active Directory, and a domain-joined Windows 11 client.

## What the lab demonstrates

- A pfSense firewall/router connecting separate server and client networks
- A `corp.internal` Active Directory domain (`CORP`)
- Central DNS on the domain controller
- A Windows 11 client joined to the domain
- Active Directory users, groups, OUs, and administrative workflows
- SMB file shares and Group Policy drive mappings
- Group Policy for desktop, workstation, account, storage, administrator, and update settings
- Troubleshooting and verification supported by repository screenshots

## Current implemented state

| Component | Current state |
|---|---|
| Virtualization | Oracle VirtualBox on Windows 11 |
| Firewall/router | `Corp-FW01` running pfSense |
| Server network | `10.10.20.0/24` |
| Client network | `10.10.30.0/24` |
| Domain controller/DNS | `Corp-DC01` at `10.10.20.10` |
| Active Directory | `corp.internal` / `CORP` implemented |
| File server | `Corp-FS01`; file sharing and mapped drives implemented |
| Client | `Corp-CL01`; Windows 11, domain joined, observed at `10.10.30.100` |
| Group Policy | Several policies implemented and documented |

This table records only work supported by existing documentation or evidence. Details that remain uncertain are marked **To verify** in the [device inventory](01-Enterprise-Planning/device-inventory.md) and [IP addressing reference](02-Network-Design/ip-addressing.md).

## Documentation

- [Project goals](00-Project-Overview/Project-Goals.md)
- [Lab roadmap](00-Project-Overview/Lab-Roadmap.md)
- [Environment](00-Project-Overview/environment.md)
- [Device inventory](01-Enterprise-Planning/device-inventory.md)
- [Network plan](02-Network-Design/network-plan.md)
- [IP addressing, DHCP, and DNS](02-Network-Design/ip-addressing.md)
- [Virtual infrastructure](03-Virtual-Infrastructure/)
- [Active Directory and Group Policy](04-Active-Directory/)
- [Windows client management](05-Client-Management/)
- [Security documentation](08-Security/)
- [Lessons learned](09-Documentation/lessons-learned.md)
- [Known issues and verification items](09-Documentation/known-issues.md)
- [Screenshots and verification evidence](Screenshots/)

## Completed versus planned work

The core VirtualBox network, pfSense router, Active Directory domain, DNS, Windows client, file sharing, and documented GPO exercises are implemented. Items listed as **Needs Verification** or **Planned** in the [roadmap](00-Project-Overview/Lab-Roadmap.md) must not be treated as completed.

Three practical items are intentionally not changed by this documentation cleanup: verification/remediation of the `DL_*` group scopes, review of the permissive OPT1 firewall rule, and review of `GG_IT` local-administrator assignment.
