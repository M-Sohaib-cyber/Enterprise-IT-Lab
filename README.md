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
- Troubleshooting and verification supported by repository screenshots

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
| Virtualization | Oracle VirtualBox on Windows 11 |
| Firewall/router | `Corp-FW01` running pfSense |
| Server network | `10.10.20.0/24` |
| Client network | `10.10.30.0/24` |
| Domain controller/DNS | `Corp-DC01` at `10.10.20.10` |
| Active Directory | `corp.internal` / `CORP` implemented |
| File server | `Corp-FS01` at static `10.10.20.20/24`; Windows Server 2022 Standard Evaluation build 20348; file sharing and mapped drives implemented |
| Client | `Corp-CL01`; Windows 11, domain joined, observed at `10.10.30.100` |
| Group Policy | Several policies implemented and documented |

This table records only work supported by existing documentation or evidence. Details that remain uncertain are marked **To verify** in the [device inventory](01-Enterprise-Planning/device-inventory.md) and [IP addressing reference](02-Network-Design/ip-addressing.md).

## Build From Zero

Follow this dependency order. The foundation steps below provide prerequisites, VM resource guidance, and VirtualBox setup. Later linked pages retain their existing configuration and verification records; some still require additional implementation instructions before this is a complete standalone rebuild guide. Resolve the network gateway checkpoint in step 2 before relying on the documented pfSense gateway addresses.

1. **Prerequisites and planning:** Read the [prerequisites and host guidance](00-Project-Overview/environment.md#prerequisites-for-a-fresh-build), [VM baseline](01-Enterprise-Planning/device-inventory.md#fresh-build-vm-baseline), and [IP addressing reference](02-Network-Design/ip-addressing.md).
2. **Create VirtualBox networks:** Follow [Create the VirtualBox networks](02-Network-Design/network-plan.md#create-the-virtualbox-networks), then review the [gateway verification checkpoint](02-Network-Design/network-plan.md#nat-network-gateway-verification-checkpoint).
3. **Create and configure Corp-FW01:** Use the [VM creation procedure](01-Enterprise-Planning/device-inventory.md#create-the-vms) and [adapter assignments](02-Network-Design/network-plan.md#configure-vm-network-adapters), then the [pfSense deployment record](03-Virtual-Infrastructure/pfsense.md) for installation and interface configuration. Configure the required routing, client DHCP, and initial client-to-DC connectivity before domain joining; detailed hardening follows in step 10.
4. **Build Corp-DC01 and deploy AD/DNS:** Follow the [DC build record](03-Virtual-Infrastructure/windows-server-build-guide.md), [AD configuration](04-Active-Directory/active-directory-installation.md), and [DNS record](04-Active-Directory/dns.md).
5. **Build Corp-FS01:** Use the [VM baseline](01-Enterprise-Planning/device-inventory.md#fresh-build-vm-baseline) and [file-server record](03-Virtual-Infrastructure/file-server.md) for its server identity, domain membership, and File Server role. Prepare the server before creating shares in step 8.
6. **Create the AD structure, users, and groups:** Use the [OU/user/group inventory](04-Active-Directory/users-and-groups.md) and [AGDLP model](04-Active-Directory/agdlp-and-permissions.md). Establish group scopes and nesting before assigning resource permissions.
7. **Build Corp-CL01 and join the domain:** Follow the [Windows 11 client record](05-Client-Management/windows11-client.md) and [DHCP verification reference](04-Active-Directory/dhcp.md); place the computer in `Workstations` before testing computer GPOs.
8. **Configure shares and permissions:** Use the [file-server storage and permissions record](03-Virtual-Infrastructure/file-server.md#recorded-permissions) and [group-based permissions](04-Active-Directory/agdlp-and-permissions.md).
9. **Configure GPOs and drive mappings:** Use the [GPO inventory](04-Active-Directory/gpo-inventory.md) and [policy operation/verification](04-Active-Directory/group-policy.md). After access works, practise [onboarding](05-Client-Management/onboarding.md), [offboarding](05-Client-Management/offboarding.md), and [account recovery](06-Helpdesk/account-recovery.md); distinguish temporary exercise states from the final user inventory.
10. **Apply pfSense and security controls:** Use the [ordered firewall rules](08-Security/firewall-rules.md) and [security baseline](08-Security/security-hardening.md), then repeat connectivity and access tests.
11. **Configure backup and recovery:** Use the [file-server backup/recovery record](03-Virtual-Infrastructure/file-server.md#backup-and-recovery---implemented-2026-10-06-automatic-execution-verified-2026-10-07), including its dedicated disk, schedule, and tested restore workflow.
12. **Run final verification:** Compare results with the [firewall test matrix](08-Security/firewall-rules.md#connectivity-from-corp-cl01), [DNS checks](04-Active-Directory/dns.md), [GPO checks](04-Active-Directory/group-policy.md), and [file-server access and recovery tests](03-Virtual-Infrastructure/file-server.md). Review the [roadmap](00-Project-Overview/Lab-Roadmap.md), [known issues](09-Documentation/known-issues.md), [lessons learned](09-Documentation/lessons-learned.md), and [screenshot evidence index](Screenshots/README.md) for completion boundaries and evidence limitations.

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
- [Screenshot evidence index](Screenshots/README.md)

## Completed versus planned work

The core VirtualBox network, pfSense router, Active Directory domain, DNS, Windows client, file sharing, and documented GPO exercises are implemented. Items listed as **Needs Verification** or **Planned** in the [roadmap](00-Project-Overview/Lab-Roadmap.md) must not be treated as completed.

Live verification on 2026-09-16 confirmed network/server details, DHCP on OPT1, AD group-scope corrections and nesting, and GPO application and drive-mapping results. Subsequent OPT1 hardening restricts general client-to-server traffic while preserving DC/DNS, SMB, and internet access. `GG_IT` workstation local-administrator access remains subject to later least-privilege review, and the WinRM WSMAN SPN warning remains open. See the [known issues](09-Documentation/known-issues.md) for remaining checks.

Final [firewall verification on 2026-09-20](08-Security/firewall-rules.md#final-verification---2026-09-20) confirmed automatic outbound NAT without changes, DC/DNS and SMB access, blocked ICMP to `Corp-FS01`, and internet connectivity. Logging enabled specifically on **Block OPT1 to Server Network** was verified in the raw log; the stale GUI log display remains an open observation. OPT1 server-network segmentation is verified, while the final allow-to-any rule remains broad. IPv6 observations are documented; comprehensive IPv6 security review, broader firewall review, centralized logging, and monitoring remain open.

Latest supplied verification on 2026-10-07 confirmed that the live [OPT1 ruleset matches the documented design](08-Security/firewall-rules.md#final-verification---2026-10-07), with block-rule logging enabled and no pfSense configuration changes required. Windows Server Backup [automatically completed at 10:00 during schedule testing](03-Virtual-Infrastructure/file-server.md#daily-schedule---automatic-execution-verified-2026-10-07), after which the daily 23:00 schedule was restored; the earlier file-level restore test remains verified. These are recorded practical results, not new live tests performed by reading this repository.
