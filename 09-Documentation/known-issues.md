# Known Issues and Verification Items

This is the authoritative summary of unresolved documentation and practical verification items. Detailed evidence remains in the linked documents. An item listed here is not automatically proof that the lab is malfunctioning.

## Practical issues and remediation status

### AD-01: `DL_*` group scopes - remediated during live work

- **Verified 2026-09-16:** All `DL_*` security groups corrected from Global through Universal to Domain Local; all six resource-group memberships verified.
- **Permissions verified:** Finance `DL_Finance_RW` Modify and IT `DL_IT_RW` Modify. IT share includes `Everyone` Full; NTFS provides the restrictive permission layer.
- **Remaining work:** Review complete ACLs, inheritance, and resource permissions beyond these checked entries.
- **Current action:** Records the completed live correction; this documentation update changes no groups or permissions.
- **Details:** [Group-Based File Permissions](../04-Active-Directory/agdlp-and-permissions.md)

### SEC-01: Broad workstation local-administrator assignment

- **Verified 2026-09-16:** `GPO - Local Administrators` intentionally adds `CORP\GG_IT` to workstation local `Administrators`. Jhon Smith (`jsmith`) is in `Domain Users` and `GG_IT`, and receives local administrator rights on `Corp-CL01` as an IT user.
- **Impact:** All applicable `GG_IT` members may receive broad local administrator rights.
- **Required later work:** Review broader deployment scope, other memberships, and least-privilege requirements; the IT-user assignment is intentional.
- **Current action:** Documentation only; no GPO or membership changed.
- **Details:** [Group Policy Inventory](../04-Active-Directory/gpo-inventory.md)

### SEC-02: Permissive OPT1 firewall rule

- **Verified 2026-09-16:** OPT1 currently allows IPv4 traffic from OPT1 subnets to any; earlier records document restored client connectivity.
- **Impact:** The rule is not a least-privilege policy.
- **Required later work:** Verify required traffic and review the complete ruleset before designing narrower rules.
- **Current action:** Documentation only; no firewall rule changed.
- **Details:** [Firewall Rules](../08-Security/firewall-rules.md)

## Verification conflicts

### NET-01: DHCP provider - conflict resolved

Live verification on 2026-09-16 confirmed pfSense DHCP enabled on OPT1 (`10.10.30.1`), with pool `10.10.30.100-10.10.30.199`. This resolves the older disabled-service record. Server-side options, exclusions, reservations, lease duration, and VirtualBox DHCP settings remain **To verify**.

Details: [DHCP Evidence and Current Status](../04-Active-Directory/dhcp.md)

### AD-02: Active Directory functional levels

Older records conflict between Windows Server 2016 and Windows Server 2025 functional levels. The current forest and domain functional levels remain **To verify** on `Corp-DC01`.

Details: [Corp-DC01 Build and Configuration](../03-Virtual-Infrastructure/windows-server-build-guide.md)

### GPO-01: Inactivity timing

Live verification on 2026-09-16 confirmed the Workstation Security inactivity limit is 600 seconds (10 minutes), with `Corp-CL01` registry value `InactivityTimeoutSecs = 0x258`. The earlier observation of lock/display behavior at approximately five minutes remains unexplained; the setting responsible for that historical behavior is still **To verify**.

Details: [Group Policy Operation and Verification](../04-Active-Directory/group-policy.md)

### AD-03: WinRM WSMAN SPN warning

Live verification on 2026-09-16 found `dcdiag` generally passed, but a WinRM WSMAN SPN warning remains for later investigation. All five FSMO roles were confirmed on `Corp-DC01`; the warning is not marked resolved.

Details: [Corp-DC01 Build and Configuration](../03-Virtual-Infrastructure/windows-server-build-guide.md)

### GPO-02: IT drive targeting - corrected during live work

On 2026-09-16, `I:` was corrected to use item-level targeting for `CORP\GG_IT`. `F:` already targets `CORP\GG_Finance`. Jhon received `I:` and `P:` after `gpupdate`, with `F:` correctly absent.

Details: [Group Policy Operation and Verification](../04-Active-Directory/group-policy.md)

## Status convention

- **Documented:** Supported by repository records or evidence.
- **To verify:** Requires a live configuration check or stronger evidence.
- **Remediated:** Use only after a practical change and verification evidence exist.

AD-01 and GPO-02 record corrections completed during the supplied live verification work. NET-01's provider conflict is resolved; its remaining configuration checks stay open. This update changes documentation only.
