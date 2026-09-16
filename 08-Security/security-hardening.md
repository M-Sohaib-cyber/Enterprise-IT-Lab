# Security Baseline and Hardening Status

## Scope

This document separates controls evidenced in the current lab from unresolved concerns and future improvements. It is not a claim of production readiness or compliance with a security framework.

## Implemented and evidenced

| Area | Current documented control | Evidence/record |
|---|---|---|
| Network boundary | pfSense routes the separate `Corp-Core` and `Corp-Clients` networks | [Network topology](../02-Network-Design/network-topology.md) and [pfSense record](../03-Virtual-Infrastructure/pfsense.md) |
| Identity | Central authentication through `corp.internal` Active Directory | [AD configuration](../04-Active-Directory/active-directory-installation.md) |
| Password policy | Complexity enabled, minimum length 8, history 5, minimum age 1 day, maximum age 90 days | [GPO inventory](../04-Active-Directory/gpo-inventory.md) |
| Account lockout | Five invalid attempts, 30-minute duration, 30-minute counter reset in the recorded policy | [GPO inventory](../04-Active-Directory/gpo-inventory.md) |
| Workstation inactivity | GPO value recorded as 600 seconds | [GPO inventory](../04-Active-Directory/gpo-inventory.md); observed timing conflict remains |
| User restrictions | Control Panel and PC settings access blocked in the documented test | [GPO inventory](../04-Active-Directory/gpo-inventory.md) |
| Removable storage | Deny-all removable-storage policy produced an access-denied test | [GPO inventory](../04-Active-Directory/gpo-inventory.md) |
| File access | Departmental/public share access and denial behavior tested on `Corp-CL01` | [File server](../03-Virtual-Infrastructure/file-server.md) |
| Windows Update | Automatic Updates option 3 recorded and verified through `AUOptions=0x3` | [GPO inventory](../04-Active-Directory/gpo-inventory.md) |
| Account lifecycle | Manual disable, password reset, unlock, and forced password-change exercises documented | [Offboarding](../05-Client-Management/offboarding.md) and [account recovery](../06-Helpdesk/account-recovery.md) |

These are lab controls and historical test results. Current settings still require live verification where identified in the linked documents.

## Known issues

The authoritative issue register is [Known Issues and Verification Items](../09-Documentation/known-issues.md). Current practical concerns are:

- `DL_*` groups were reportedly created with Global rather than Domain Local scope, so AGDLP is not fully or correctly implemented.
- `GPO - Local Administrators` grants broad workstation local Administrator membership to `CORP\GG_IT`.
- The pfSense OPT1 IPv4 Any-to-Any rule is permissive and not a least-privilege policy.
- The configured 600-second inactivity value does not match the approximately five-minute behavior observed during testing.

None of these issues is remediated by this documentation work.

## Planned - not implemented

Future practical work may:

- Verify and remediate `DL_*` group scopes, nesting, and file ACLs.
- Review the membership and requirement for workstation local Administrator access.
- Verify required network traffic and replace the permissive OPT1 rule with an approved least-privilege ruleset.
- Resolve DHCP ownership and configuration uncertainty.
- Export and review current GPO, DNS, firewall, directory, and permission state.
- Define backup, recovery, logging, monitoring, and patch-verification requirements.

These are planned verification or improvement activities only. No result is claimed until configuration work and evidence exist.

## Evidence

The [Screenshot Evidence Index](../Screenshots/README.md) describes what each repository image visibly supports and its limitations.
