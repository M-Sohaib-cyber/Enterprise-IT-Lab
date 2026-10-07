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
- Windows Server Backup, automatic scheduled execution, and tested file-level recovery
- Practical verification supported by screenshots and dated written records

## Final architecture

```text
Internet / Windows 11 host
  |
VirtualBox NAT
  |
Corp-FW01 (pfSense)
  |-- WAN: DHCP, observed 10.0.2.15/24, gateway 10.0.2.2
  |-- LAN: Corp-Core / 10.10.20.1/24
  |     |-- Corp-DC01: 10.10.20.10 / AD DS and DNS
  |     `-- Corp-FS01: 10.10.20.20 / SMB file shares
  |
  `-- OPT1: Corp-Clients / 10.10.30.1/24
        `-- Corp-CL01: DHCP, observed 10.10.30.100 / Windows 11
```

The domain is `corp.internal` (`CORP`). pfSense routes between the server and client networks and provides DHCP for `Corp-Clients`; domain members use `Corp-DC01` for DNS. The internal VirtualBox NAT Networks have VirtualBox DHCP disabled. See the [network plan and setup procedure](02-Network-Design/network-plan.md), including the unresolved NAT Network gateway detail that must be checked during a fresh build.

## Current implemented state

| Component | Current state |
|---|---|
| Virtualization | Oracle VirtualBox 7.1.12 tested on Windows 11 |
| Firewall/router | `Corp-FW01` running pfSense |
| Server network | `10.10.20.0/24` |
| Client network | `10.10.30.0/24` |
| Domain controller/DNS | `Corp-DC01` at `10.10.20.10` |
| Active Directory | `corp.internal` / `CORP` implemented |
| File server | `Corp-FS01` at static `10.10.20.20/24`; Windows Server 2022 Standard Evaluation build 20348; file sharing and mapped drives implemented |
| Client | `Corp-CL01`; Windows 11, domain joined, observed at `10.10.30.100` |
| Group Policy | Several policies implemented and documented |
| Backup/recovery | Windows Server Backup for `C:\Shares` to a dedicated 20 GB disk; manual backups, automatic execution and file-level restore verified; final daily schedule 23:00 |
| Latest pfSense review | 2026-10-07: live OPT1 ruleset matches the documented order; block-rule logging enabled; OPT1 IPv6 None; no configuration changes required |

This table records only work supported by existing documentation or evidence. Details that remain uncertain are marked **To verify** in the [device inventory](01-Enterprise-Planning/device-inventory.md) and [IP addressing reference](02-Network-Design/ip-addressing.md).

## Build From Zero

Follow this dependency order. Linked guides provide implementation steps alongside the original verification records. Exact settings that were not recorded remain explicitly flagged; see the [reproduction limits](09-Documentation/final-verification.md#reproduction-limits). Resolve the network gateway checkpoint in step 2 before relying on the documented pfSense gateway addresses.

1. **Prerequisites and planning:** Read the [prerequisites and host guidance](00-Project-Overview/environment.md#prerequisites-for-a-fresh-build), [VM baseline](01-Enterprise-Planning/device-inventory.md#fresh-build-vm-baseline), and [IP addressing reference](02-Network-Design/ip-addressing.md).
2. **Create VirtualBox networks:** Follow [Create the VirtualBox networks](02-Network-Design/network-plan.md#create-the-virtualbox-networks), then review the [gateway verification checkpoint](02-Network-Design/network-plan.md#nat-network-gateway-verification-checkpoint).
3. **Create and configure Corp-FW01:** Use the [VM creation procedure](01-Enterprise-Planning/device-inventory.md#create-the-vms), [adapter assignments](02-Network-Design/network-plan.md#configure-vm-network-adapters), and [pfSense build procedure](03-Virtual-Infrastructure/pfsense.md#build-from-zero). Initial WebGUI management uses DC01's installation/static-address steps from stage 4, before promotion. Complete client-to-DC checks after DC01 is ready; detailed hardening follows in step 10.
4. **Build Corp-DC01 and deploy AD/DNS:** Follow the [DC build record](03-Virtual-Infrastructure/windows-server-build-guide.md), [AD configuration](04-Active-Directory/active-directory-installation.md), and [DNS record](04-Active-Directory/dns.md).
5. **Build Corp-FS01:** Use the [VM baseline](01-Enterprise-Planning/device-inventory.md#fresh-build-vm-baseline) and [file-server record](03-Virtual-Infrastructure/file-server.md) for its server identity, domain membership, and File Server role. Prepare the server before creating shares in step 8.
6. **Create the AD structure, users, and groups:** Use the [OU/user/group inventory](04-Active-Directory/users-and-groups.md) and [AGDLP model](04-Active-Directory/agdlp-and-permissions.md). Establish group scopes and nesting before assigning resource permissions.
7. **Build Corp-CL01 and join the domain:** Follow the [Windows 11 client record](05-Client-Management/windows11-client.md) and [DHCP verification reference](04-Active-Directory/dhcp.md); place the computer in `Workstations` before testing computer GPOs.
8. **Configure shares and permissions:** Follow the [share/NTFS implementation procedure](03-Virtual-Infrastructure/file-server.md#implement-shares-and-resource-permissions) and [group-based permissions](04-Active-Directory/agdlp-and-permissions.md).
9. **Configure GPOs and drive mappings:** Follow the [GPO implementation steps](04-Active-Directory/group-policy.md#implement-the-recorded-policies) and [GPO inventory](04-Active-Directory/gpo-inventory.md), including the reader-supplied wallpaper prerequisite. After access works, practise [onboarding](05-Client-Management/onboarding.md), [offboarding](05-Client-Management/offboarding.md), and [account recovery](06-Helpdesk/account-recovery.md); distinguish temporary exercise states from the final user inventory.
10. **Apply pfSense and security controls:** Use the [ordered firewall rules](08-Security/firewall-rules.md) and [security baseline](08-Security/security-hardening.md), then repeat connectivity and access tests.
11. **Configure backup and recovery:** Follow the [backup/recovery build procedure](03-Virtual-Infrastructure/file-server.md#rebuild-the-backup-and-recovery-setup) for the feature, separate disk, time check, daily schedule, automatic execution and safe file restore.
12. **Run final verification:** Follow the [end-to-end acceptance checklist](09-Documentation/final-verification.md). Review the [roadmap](00-Project-Overview/Lab-Roadmap.md), [known issues](09-Documentation/known-issues.md), [lessons learned](09-Documentation/lessons-learned.md), and [screenshot evidence index](Screenshots/README.md) for completion boundaries and evidence limitations.

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
- [Helpdesk and account recovery](06-Helpdesk/account-recovery.md)
- [Security documentation](08-Security/)
- [Lessons learned](09-Documentation/lessons-learned.md)
- [Known issues and verification items](09-Documentation/known-issues.md)
- [Final acceptance checklist](09-Documentation/final-verification.md)
- [Screenshot evidence index](Screenshots/README.md)

## Completed versus planned work

The core network, domain, DNS, client, file services, GPO exercises, backup and file-level recovery are implemented and practically tested. Screenshots support selected historical checks; later results also have dated written records. Use the [evidence index](Screenshots/README.md) and linked service records to distinguish them.

Advanced work remains separate: automation, a helpdesk platform, centralized logging/monitoring, offsite protection and broader disaster recovery are not implemented. Exact configuration exports and some reproduction details are still missing. The [roadmap](00-Project-Overview/Lab-Roadmap.md) and [known issues](09-Documentation/known-issues.md) distinguish those gaps from completed work and preserved troubleshooting observations. OPT1 segmentation is verified without claiming a fully least-privilege firewall; intentional `GG_IT` workstation administrator access remains a review item.

Latest supplied verification on 2026-10-07 confirmed that the live [OPT1 ruleset matches the documented design](08-Security/firewall-rules.md#final-verification---2026-10-07), with block-rule logging enabled and no pfSense configuration changes required. Windows Server Backup [automatically completed at 10:00 during schedule testing](03-Virtual-Infrastructure/file-server.md#daily-schedule---automatic-execution-verified-2026-10-07), after which the daily 23:00 schedule was restored; the earlier file-level restore test remains verified. These are recorded practical results, not new live tests performed by reading this repository.
