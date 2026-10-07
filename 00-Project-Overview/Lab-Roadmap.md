# Lab Roadmap

Status includes the supplied live verification results from 2026-09-16, 2026-09-20, 2026-10-06, and 2026-10-07 and existing repository evidence.

## Completed

| Area | Evidence-supported outcome |
|---|---|
| Virtualization | Lab components run in Oracle VirtualBox on a Windows 11 host. |
| Server patching and Guest Additions | Verified 2026-10-06: both servers updated successfully with post-update checks; Guest Additions and bidirectional clipboard tested; powered-off snapshots created with older snapshots retained. See [environment](environment.md#virtual-storage-and-snapshots---verified-2026-10-06) and linked server records. |
| Network separation | `Corp-Core` (`10.10.20.0/24`) and `Corp-Clients` (`10.10.30.0/24`) are documented. |
| Firewall/router | `Corp-FW01` runs pfSense with WAN, LAN, and OPT1 interfaces. |
| Windows Server | `Corp-DC01` is documented as a Windows Server 2022 domain controller. |
| Active Directory | `corp.internal` / `CORP`; functional levels `Windows2016Forest` / `Windows2016Domain` verified 2026-10-06. Relevant OU/user/group/computer inventory, single-DC topology, no trusts, and all FSMO roles verified; standard `dcdiag` passed all reported tests. |
| DNS | Verified 2026-09-20: core DNS works through `Corp-DC01` at `10.10.20.10`; running AD-integrated forward zones, inspected host records, external resolution without explicit forwarders, tested client forward/reverse lookups, and successful `dcdiag /test:dns /v`. Server-network reverse zone and DC PTR implemented; see [DNS](../04-Active-Directory/dns.md). |
| Windows client | `Corp-CL01` is joined to the domain and domain authentication was tested. |
| File services | `Corp-FS01`, departmental SMB shares, access testing, and mapped drives are documented. |
| File backup/recovery | Manual backups/file restore verified 2026-10-06; automatic execution verified 2026-10-07 during temporary 10:00 testing, then daily 23:00 restored. See the authoritative [backup record and build procedure](../03-Virtual-Infrastructure/file-server.md#backup-and-recovery---implemented-2026-10-06-automatic-execution-verified-2026-10-07). |
| Identity administration | OU, user, group, onboarding, offboarding, lockout, unlock, and password-reset exercises documented. On 2026-10-06, two subnet objects were registered to the single AD site and Recycle Bin enabled; a temporary-account restore succeeded and the test account was deleted afterward. See [AD configuration](../04-Active-Directory/active-directory-installation.md). |
| Group Policy | Drive mappings, company desktop, workstation security, user restrictions, password/lockout, removable storage, local administrators, and Windows Update policies are documented. |
| PowerShell administration | PowerShell-based Active Directory user and group administration tested using a temporary account, including user creation, group membership management, account disable/enable, password reset, verification, and cleanup. See [PowerShell Active Directory Administration](../07-Administration-Automation/powershell-active-directory.md). |

Detailed dated network/server/group checks remain in the linked component records rather than being repeated here. The authoritative [GPO application record](../04-Active-Directory/group-policy.md#live-verification---2026-09-16) preserves the client/user policy and mapping results. [Firewall Rules](../08-Security/firewall-rules.md) preserves the 2026-09-20 connectivity/logging tests and 2026-10-07 final review, with their limits.

The rebuild route is in [README](../README.md#build-from-zero); finish with the [final acceptance checklist](../09-Documentation/final-verification.md). Passing functional checks does not fill unrecorded configuration fields.

## Needs Verification

| Item | Reason |
|---|---|
| DHCP configuration | Verified 2026-10-06: OPT1 ISC DHCP options, 7200/86400-second default/maximum leases, no reservations, and successful client release/renew. Exclusions, uninspected settings, and other possible DHCP services on Corp-Core remain open. See [DHCP](../04-Active-Directory/dhcp.md). |
| `Corp-FS01` inventory | OS/build, domain, static network settings, and share names are verified; C: NTFS capacity/free space and Healthy/OK status, share paths under C:\Shares, and absence of a separate data volume are verified 2026-10-06; the second SATA-attached 20 GB backup VDI is verified. RAM, CPU, `Corp-Core` attachment, installed KBs, and post-patch share/backup checks are now verified; uninspected VM settings, activation, and complete ACLs remain open. |
| VirtualBox network settings | Verified 2026-10-06: both lab NAT Network prefixes, VirtualBox DHCP disabled on both, and Corp-CL01 Adapter 1 attachment/MAC/cable state. All four VM attachments, RAM, and CPU allocations are now verified in the [inventory](../01-Enterprise-Planning/device-inventory.md#virtualbox-baseline---verified-2026-10-06); uninspected settings remain open. |
| File permissions | All five resource-group NTFS entries and intentional Everyone: Full share permissions are verified; Jhon tested IT read/write, Public read-only, and Finance/HR/Sales denial. Review complete ACLs, inheritance, and access for other users. |
| DNS review | Initial local `::1` query timeout remains unexplained despite eventual success; DNS settings/records beyond the tested scope remain open. See [DNS](../04-Active-Directory/dns.md). |
| DC diagnostic warning | Standard `dcdiag` passed all reported tests on 2026-10-06; retain the historical WinRM WSMAN SPN warning for targeted investigation because no cause or specific remediation was established. |
| Historical inactivity timing | Applied 600 seconds is verified; explain the earlier approximately five-minute lock/display observation. |
| Firewall policy | Verified 2026-10-07: live OPT1 ruleset matches the documented hardened ruleset; Block OPT1 to Server Network logging is enabled. Aliases are not configured and are intentionally unused for this small lab. OPT1 IPv6 Configuration Type is None; the lab is intentionally IPv4-focused. Existing IPv4 NAT/internet connectivity had already been verified; no pfSense configuration changes were required during this review. The final allow-to-any remains broad; WAN/LAN rulesets, OPT1 fields beyond the documented design, individual generated NAT rules, and comprehensive IPv6 security review remain open. |
| Firewall GUI logs | Fresh blocks were verified in `/var/log/filter.log`, but the GUI showed older entries; no root cause was proven. |
| Local administrator delegation | Intentional `GG_IT` assignment and Jhon's local admin rights are confirmed; broader least-privilege review remains. |

These are verification or remediation items, not claims that the lab is currently broken.

The consolidated status and supporting links are maintained in [Known Issues and Verification Items](../09-Documentation/known-issues.md).

## Planned

| Documentation/work item | Intended outcome |
|---|---|
| PowerShell automation | Add scripts and evidence only when practical automation work is completed. |
| Helpdesk platform and workflows | Document only after a ticketing platform or tested workflow is implemented. |
| Centralized logging and monitoring | Remote syslog is not configured; local firewall logging verification does not complete centralized logging or broader monitoring. |

No completion date is assigned to planned work until it enters an active lab batch.
