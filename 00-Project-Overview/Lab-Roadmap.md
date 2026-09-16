# Lab Roadmap

Status is based on documentation and evidence currently stored in this repository.

## Completed

| Area | Evidence-supported outcome |
|---|---|
| Virtualization | Lab components run in Oracle VirtualBox on a Windows 11 host. |
| Network separation | `Corp-Core` (`10.10.20.0/24`) and `Corp-Clients` (`10.10.30.0/24`) are documented. |
| Firewall/router | `Corp-FW01` runs pfSense with WAN, LAN, and OPT1 interfaces. |
| Windows Server | `Corp-DC01` is documented as a Windows Server 2022 domain controller. |
| Active Directory | The `corp.internal` forest/domain and `CORP` NetBIOS name are implemented. |
| DNS | `Corp-DC01` provides domain DNS at `10.10.20.10`. |
| Windows client | `Corp-CL01` is joined to the domain and domain authentication was tested. |
| File services | `Corp-FS01`, departmental SMB shares, access testing, and mapped drives are documented. |
| Identity administration | OU, user, group, onboarding, offboarding, lockout, unlock, and password-reset exercises are documented. |
| Group Policy | Drive mappings, company desktop, workstation security, user restrictions, password/lockout, removable storage, local administrators, and Windows Update policies are documented. |

## Needs Verification

| Item | Reason |
|---|---|
| DHCP configuration | `Corp-CL01` reports DHCP server `10.10.30.1`, but the pfSense deployment document says OPT1 DHCP was disabled. Confirm the current provider, scope, and options. |
| `Corp-FS01` inventory | Its role and shares are documented, but its operating system, IP address, and VM specification are not confirmed. |
| VirtualBox network settings | Network names are documented, but the current VirtualBox DHCP and attachment settings need an authoritative capture. |
| AD functional levels | Existing documents conflict between Windows Server 2016 and Windows Server 2025 functional levels. |
| AGDLP group scopes | The repository records that `DL_*` groups may have been created as Global rather than Domain Local groups. |
| OPT1 firewall policy | The current allow-any rule is documented but needs later least-privilege review. |
| Local administrator delegation | The assignment of `GG_IT` to workstation local Administrators needs later security review. |

These are verification or remediation items, not claims that the lab is currently broken.

## Planned

| Documentation/work item | Intended outcome |
|---|---|
| Evidence index | Map screenshots to systems, configuration claims, and tests. |
| AD/GPO inventory | Create concise authoritative inventories for OUs, users, groups, and GPO links. |
| Security baseline | Distinguish controls already implemented from recommendations and future remediation. |
| PowerShell automation | Add scripts and evidence only when practical automation work is completed. |
| Helpdesk platform and workflows | Document only after a ticketing platform or tested workflow is implemented. |

No completion date is assigned to planned work until it enters an active lab batch.
