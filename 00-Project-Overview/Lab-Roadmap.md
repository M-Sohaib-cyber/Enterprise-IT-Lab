# Lab Roadmap

Status includes the supplied live verification results from 2026-09-16 and existing repository evidence.

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

Live verification on 2026-09-16 also confirmed:

- pfSense WAN `em0`, DHCP `10.0.2.15/24`, gateway `10.0.2.2`; LAN `em1`, `10.10.20.1/24`; OPT1 `em2`, `10.10.30.1/24`.
- pfSense DHCP enabled on OPT1, pool `10.10.30.100-10.10.30.199`.
- `Corp-DC01` static addressing, domain/DC DNS resolution, and ownership of all five FSMO roles; `dcdiag` generally passed with the warning below.
- `Corp-FS01` Windows Server 2022 Standard Evaluation build 20348, static `10.10.20.20/24`, domain/network settings, and Finance, HR, IT, Public, and Sales shares.
- All `DL_*` scopes corrected through Universal to Domain Local; six resource-group memberships and Finance/IT NTFS Modify entries verified.
- Computer/user GPO application for `Corp-CL01` and Jhon, 600-second inactivity limit and `0x258` registry value, removable-storage deny-all setting, and Windows Update mode 3.
- Wallpaper path/file access and practical Control Panel/PC Settings block verified; I: targeting corrected to `CORP\GG_IT`, with I:/P: present and F: absent for Jhon after `gpupdate`.

## Needs Verification

| Item | Reason |
|---|---|
| DHCP configuration | Provider, enabled state, and pool are verified; server-side options, exclusions, reservations, and lease duration remain open. |
| `Corp-FS01` inventory | OS/build, domain, static network settings, and share names are verified; VM specification, exact attachment, patch state, storage, and complete ACLs remain open. |
| VirtualBox network settings | Network names are documented, but the current VirtualBox DHCP and attachment settings need an authoritative capture. |
| AD functional levels | Existing documents conflict between Windows Server 2016 and Windows Server 2025 functional levels. |
| File permissions | Group scopes/nesting and Finance/IT Modify entries are verified; review remaining ACLs, inheritance, and effective access. |
| DC diagnostic warning | Investigate the WinRM WSMAN SPN warning from `dcdiag`. |
| Historical inactivity timing | Applied 600 seconds is verified; explain the earlier approximately five-minute lock/display observation. |
| OPT1 firewall policy | The current allow-any rule is documented but needs later least-privilege review. |
| Local administrator delegation | Intentional `GG_IT` assignment and Jhon's local admin rights are confirmed; broader least-privilege review remains. |

These are verification or remediation items, not claims that the lab is currently broken.

The consolidated status and supporting links are maintained in [Known Issues and Verification Items](../09-Documentation/known-issues.md).

## Planned

| Documentation/work item | Intended outcome |
|---|---|
| PowerShell automation | Add scripts and evidence only when practical automation work is completed. |
| Helpdesk platform and workflows | Document only after a ticketing platform or tested workflow is implemented. |

No completion date is assigned to planned work until it enters an active lab batch.
