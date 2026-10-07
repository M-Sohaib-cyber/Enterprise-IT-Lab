# Security Baseline and Hardening Status

## Scope

This document separates controls evidenced in the current lab from unresolved concerns and future improvements. It is not a claim of production readiness or compliance with a security framework.

## Implemented and evidenced

| Area | Current documented control | Evidence/record |
|---|---|---|
| Network boundary | pfSense routes the separate `Corp-Core` and `Corp-Clients` networks | [Network topology](../02-Network-Design/network-topology.md) and [pfSense record](../03-Virtual-Infrastructure/pfsense.md) |
| Client/server filtering | Ordered OPT1 rules allow DC access and SMB-only access to `Corp-FS01`, block other LAN traffic, then allow other destinations | [Firewall rules](firewall-rules.md) |
| Local firewall logging | Verified 2026-09-20: local/default block logging enabled; packet logging enabled specifically on **Block OPT1 to Server Network**, with fresh ICMP block entries in the raw log | [Firewall verification and logging settings](firewall-rules.md#final-verification---2026-09-20) |
| Identity | Central authentication through `corp.internal` Active Directory | [AD configuration](../04-Active-Directory/active-directory-installation.md) |
| Password policy | Complexity enabled, minimum length 8, history 5, minimum age 1 day, maximum age 90 days | [GPO inventory](../04-Active-Directory/gpo-inventory.md) |
| Account lockout | Five invalid attempts, 30-minute duration, 30-minute counter reset in the recorded policy | [GPO inventory](../04-Active-Directory/gpo-inventory.md) |
| Workstation inactivity | GPO value live verified as 600 seconds (10 minutes), with `InactivityTimeoutSecs = 0x258` | [GPO inventory](../04-Active-Directory/gpo-inventory.md); observed timing conflict remains |
| User restrictions | Control Panel and PC settings access blocked in the documented test | [GPO inventory](../04-Active-Directory/gpo-inventory.md) |
| Removable storage | Deny-all removable-storage policy produced an access-denied test | [GPO inventory](../04-Active-Directory/gpo-inventory.md) |
| File access | Departmental/public share access and denial behavior tested on `Corp-CL01` | [File server](../03-Virtual-Infrastructure/file-server.md) |
| File backup/recovery | Windows Server Backup installed; manual backups and file-level restore verified. Automatic execution succeeded on 2026-10-07 during temporary 10:00 testing; daily 23:00 schedule restored. | [Backup/recovery record and build procedure](../03-Virtual-Infrastructure/file-server.md#backup-and-recovery---implemented-2026-10-06-automatic-execution-verified-2026-10-07) |
| Windows Update | Automatic Updates option 3 recorded and verified through `AUOptions=0x3` | [GPO inventory](../04-Active-Directory/gpo-inventory.md) |
| Account lifecycle | Manual disable, password reset, unlock, and forced password-change exercises documented | [Offboarding](../05-Client-Management/offboarding.md) and [account recovery](../06-Helpdesk/account-recovery.md) |

These records include historical tests and supplied live verification through 2026-10-07. Current settings still require live verification where identified in the linked documents. OPT1 server-network segmentation is verified, but the final allow-to-any rule remains broad; this is not a claim that the entire firewall is fully hardened or least privilege. IPv6 interface observations do not complete a comprehensive IPv6 security review.

## Defender observations - 2026-10-06

Microsoft Defender Tamper Protection was enabled on `Corp-FS01` during the supplied session. Reputation-based protection was observed disabled; no existing evidence confirms it was subsequently enabled. Its enablement remains unverified.

Successful server patching and post-update service checks are documented in the [DC build record](../03-Virtual-Infrastructure/windows-server-build-guide.md#patch-and-post-update-verification---2026-10-06) and [file-server record](../03-Virtual-Infrastructure/file-server.md#patch-and-post-update-verification---2026-10-06). These checks establish the listed installed KBs, without claiming complete patch compliance.

## Known issues

The authoritative issue register is [Known Issues and Verification Items](../09-Documentation/known-issues.md). Current practical concerns are:

- `DL_*` scopes were corrected through Universal to Domain Local and all six memberships verified on 2026-09-16. Latest 2026-10-06 checks confirm all five resource-group NTFS entries and intentional `Everyone: Full` share permissions, with NTFS providing authorization. Jhon tested IT read/write, Public read-only, and Finance/HR/Sales denial; complete ACL/inheritance review remains open.
- `GPO - Local Administrators` intentionally grants workstation local Administrator membership to `CORP\GG_IT`; Jhon's resulting rights on `Corp-CL01` are verified. Broader least-privilege review remains open.
- The applied 600-second inactivity value is now verified; the earlier approximately five-minute lock/display observation remains unexplained.
- Standard `dcdiag` passed all reported tests on 2026-10-06; the earlier WinRM WSMAN SPN warning remains a historical observation for targeted investigation, without a proven cause/remediation.
- The pfSense GUI showed older firewall-log entries during the 2026-09-20 test, although fresh blocks were confirmed in `/var/log/filter.log`. No root cause was proven.

Group corrections were completed during the supplied live work. This documentation update performs no remediation.

## Planned - not implemented

Future practical work may:

- Review complete file ACLs, inheritance, and permissions beyond the five verified resource-group entries, and test access for other users.
- Review the membership and requirement for workstation local Administrator access.
- Verify DHCP exclusions and uninspected DHCP/VirtualBox settings beyond the 2026-10-06 checks; OPT1 options, lease times, absence of reservations, and disabled VirtualBox DHCP on both lab NAT networks are verified. See [DHCP](../04-Active-Directory/dhcp.md).
- Export and review current GPO, DNS, firewall, directory, and permission state.
- Extend recovery testing beyond the verified file restore and automatic scheduled execution; practical volume recovery, offsite protection, and disaster recovery remain untested. See [file server](../03-Virtual-Infrastructure/file-server.md#backup-and-recovery---implemented-2026-10-06-automatic-execution-verified-2026-10-07).
- Define broader recovery, centralized logging, monitoring, and patch-verification requirements. Remote syslog is not configured; verified local firewall logging does not complete centralized logging or broader monitoring.

These are planned verification or improvement activities only. No result is claimed until configuration work and evidence exist.

## Evidence

The [Screenshot Evidence Index](../Screenshots/README.md) describes what each repository image visibly supports and its limitations.
