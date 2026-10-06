# Known Issues and Verification Items

This is the authoritative summary of unresolved documentation and practical verification items. Detailed evidence remains in the linked documents. An item listed here is not automatically proof that the lab is malfunctioning.

## Practical issues and remediation status

### AD-01: `DL_*` group scopes - remediated during live work

- **Verified 2026-09-16:** All `DL_*` security groups corrected from Global through Universal to Domain Local; all six resource-group memberships verified.
- **Permissions verified:** Latest checks confirm Finance/HR/IT/Sales resource-group Modify and Public `DL_Public_RO` Read & Execute. All five shares intentionally grant `Everyone: Full`; NTFS provides authorization. Jhon tested IT read/write, Public read with write denied, and denial to Finance/HR/Sales; the temporary IT file was removed.
- **Remaining work:** Review complete ACLs, inheritance, and resource permissions beyond these checked entries.
- **Current action:** Records the completed live correction; this documentation update changes no groups or permissions.
- **Details:** [Group-Based File Permissions](../04-Active-Directory/agdlp-and-permissions.md)

### SEC-01: Broad workstation local-administrator assignment

- **Verified 2026-09-16:** `GPO - Local Administrators` intentionally adds `CORP\GG_IT` to workstation local `Administrators`. Jhon Smith (`jsmith`) is in `Domain Users` and `GG_IT`, and receives local administrator rights on `Corp-CL01` as an IT user.
- **Impact:** All applicable `GG_IT` members may receive broad local administrator rights.
- **Required later work:** Review broader deployment scope, other memberships, and least-privilege requirements; the IT-user assignment is intentional.
- **Current action:** Documentation only; no GPO or membership changed.
- **Details:** [Group Policy Inventory](../04-Active-Directory/gpo-inventory.md)

### SEC-02: Permissive OPT1 firewall rule - remediated

- **Current design:** Ordered OPT1 rules allow `Corp-DC01`, allow only TCP 445 to `Corp-FS01`, block the rest of `10.10.20.0/24`, and then allow other destinations.
- **Verified result:** `Corp-CL01` retained DC/DNS and internet access; ping to `Corp-FS01` was blocked while SMB and Jhon's `I:` and `P:` mappings worked after Group Policy refresh.
- **Verified 2026-09-20:** Automatic outbound NAT and client internet connectivity confirmed without a NAT change. Per-rule logging was enabled specifically on **Block OPT1 to Server Network**; the client-to-file-server ping was blocked and fresh ICMP block entries were confirmed in `/var/log/filter.log`.
- **Scope:** The OPT1 server-network segmentation objective is verified. The final allow-to-any rule remains broad for traffic not matched by preceding rules; the entire firewall is not established as fully hardened or least privilege. IPv6 review observed only link-local addresses on LAN/OPT1, with no routed IPv6 addressing; WAN Unique Local IPv6 does not establish public IPv6 connectivity. No IPv6 change was made.
- **Remaining work:** Complete ruleset, individual generated NAT rules, aliases, comprehensive IPv6 security review beyond the recorded observations, and other custom-rule logging checks remain open. Remote syslog is not configured and broader monitoring is incomplete.
- **Current action:** Documentation only; no firewall rule changed.
- **Details:** [Firewall Rules](../08-Security/firewall-rules.md)

### SEC-03: Stale pfSense GUI firewall-log display

- **Observed 2026-09-20:** After enabling packet logging on **Block OPT1 to Server Network**, the GUI continued to display older 2026-09-16 entries and did not show the fresh ping-test entries.
- **Verified result:** `tail -20 /var/log/filter.log` from the pfSense shell showed fresh 2026-09-20 entries: source `10.10.30.100`, destination `10.10.20.20`, protocol ICMP, action block. Packet blocking and logging worked.
- **Recorded settings:** Local logging and default firewall block logging enabled; GUI display 500 entries; log retention count 7; remote syslog not configured.
- **Status:** GUI display observation remains open. No root cause was proven; successful raw-log verification does not resolve the GUI issue.
- **Details:** [Firewall Rules](../08-Security/firewall-rules.md)

### FS-01: File-server backup/recovery - identified gap

- **Verified 2026-10-06:** `C:` is NTFS, 60.32 GB with 49.2 GB free, Healthy/OK. All five shares are under `C:\Shares`; no separate data volume currently exists.
- **Backup findings:** Windows Server Backup `InstallState = Available` means not installed. Built-in `RegIdleBackup` exists but is not a file-server backup solution. `vssadmin list shadows` returned no shadow copies.
- **Status:** No backup solution for `C:\Shares` has currently been verified. Backup coverage and file-data restore testing remain an improvement/gap; recovery is not complete.
- **Details:** [Corp-FS01 File Server](../03-Virtual-Infrastructure/file-server.md)

## Verification conflicts

### NET-01: DHCP provider - conflict resolved

Live verification on 2026-09-16 confirmed pfSense DHCP enabled on OPT1 (`10.10.30.1`), with pool `10.10.30.100-10.10.30.199`. This resolves the older disabled-service record. Verification on 2026-10-06 confirmed pfSense ISC DHCP on OPT1, the supplied gateway/DNS/domain options, 7200/86400-second default/maximum leases, and no OPT1 static mappings. Corp-CL01 successfully released/renewed 10.10.30.100; this observed address is not permanently reserved. VirtualBox DHCP is disabled on NAT Networks Corp-Core (10.10.20.0/24) and Corp-Clients (10.10.30.0/24). Corp-DC01 remains static at 10.10.20.10 with DHCP disabled and the Windows DHCP Server role Available, not Installed. Exclusions and uninspected settings remain to verify. See [DHCP verification](../04-Active-Directory/dhcp.md). Whether any other DHCP service exists on Corp-Core remains open beyond the checked VirtualBox/DC sources; these checks are not an exhaustive DHCP or VirtualBox audit.

Details: [DHCP Evidence and Current Status](../04-Active-Directory/dhcp.md)

### AD-02: Active Directory functional levels - conflict resolved

Older records conflicted between Windows Server 2016 and Windows Server 2025 functional levels. Verification on 2026-10-06 confirmed forest `corp.internal` at `Windows2016Forest` and domain `corp.internal` (NetBIOS `CORP`) at `Windows2016Domain`, resolving this conflict without a functional-level change.

Details: [Corp-DC01 Build and Configuration](../03-Virtual-Infrastructure/windows-server-build-guide.md)

### GPO-01: Inactivity timing

Live verification on 2026-09-16 confirmed the Workstation Security inactivity limit is 600 seconds (10 minutes), with `Corp-CL01` registry value `InactivityTimeoutSecs = 0x258`. The earlier observation of lock/display behavior at approximately five minutes remains unexplained; the setting responsible for that historical behavior is still **To verify**.

Details: [Group Policy Operation and Verification](../04-Active-Directory/group-policy.md)

### AD-03: WinRM WSMAN SPN warning

Live verification on 2026-09-16 found `dcdiag` generally passed, but a WinRM WSMAN SPN warning remains for later investigation. All five FSMO roles were confirmed on `Corp-DC01`. On 2026-10-06, standard `dcdiag` completed successfully with all reported tests passed and no failed tests observed; all FSMO roles were reconfirmed on `Corp-DC01.corp.internal`. The historical warning is retained pending targeted investigation; its cause or specific remediation was not established.

Details: [Corp-DC01 Build and Configuration](../03-Virtual-Infrastructure/windows-server-build-guide.md)

### NET-02: Temporary Corp-DC01 network profile - observed and recovered

During firewall testing, `Corp-DC01` temporarily identified its network as `Private` rather than `DomainAuthenticated`. DNS and Netlogon were running, and `nltest /dsgetdc:corp.internal` succeeded. A normal restart restored `DomainAuthenticated`; client-to-DC ping and DNS resolution then worked normally. The exact cause was not proven, so this is retained as a troubleshooting observation rather than a confirmed root-cause finding.

### GPO-02: IT drive targeting - corrected during live work

On 2026-09-16, `I:` was corrected to use item-level targeting for `CORP\GG_IT`. `F:` already targets `CORP\GG_Finance`. Jhon received `I:` and `P:` after `gpupdate`, with `F:` correctly absent.

Details: [Group Policy Operation and Verification](../04-Active-Directory/group-policy.md)

### DNS-01: Initial local ::1 query timeout

- **Observed 2026-09-20:** On `Corp-DC01`, `nslookup google.com` using the local `::1` resolver displayed an initial timeout before successfully returning external IPv4 and IPv6 records.
- **Comparison:** `nslookup google.com 10.10.20.10` succeeded without the initial timeout. No explicit forwarders are configured or were added; external resolution works with the existing configuration.
- **Status:** No root cause was proven. Core DNS functionality, the tested client forward/reverse lookups, and `dcdiag /test:dns /v` passed; the initial timeout remains an open observation.
- **Remaining scope:** Uninspected records and DNS settings, including forward-zone replication/update settings, aging/scavenging, and logging, remain unverified. Only the server-network reverse zone and DC PTR are recorded as implemented.
- **Details:** [Active Directory DNS](../04-Active-Directory/dns.md)

## AD verification and controlled improvements - 2026-10-06

- OU structure, relevant user enabled states/locations, all listed GG_/DL_ scopes and direct memberships, enabled computer OU locations, and default domain password/lockout values were verified. Empty Admins, IT Admins, and Service Accounts OUs are reserved/unused.
- Replication checks found no source/destination partners in this single-DC lab, as expected; multi-DC replication testing is not applicable. No AD trusts are configured.
- **Controlled improvements completed during supplied live work:** Registered `10.10.20.0/24` and `10.10.30.0/24` to the single site `Default-First-Site-Name`, and enabled AD Recycle Bin for `corp.internal`. PowerShell confirmed both subnet associations and populated `EnabledScopes`.
- The temporary `recovery.test` account was successfully restored to Company Users in a disabled state, then deleted again; final lookup returned object not found. Broader backup/recovery and uninspected AD settings remain open.
- **Details:** [AD configuration](../04-Active-Directory/active-directory-installation.md), [Users and Groups](../04-Active-Directory/users-and-groups.md), and [Account Recovery](../06-Helpdesk/account-recovery.md).

## Status convention

- **Documented:** Supported by repository records or evidence.
- **To verify:** Requires a live configuration check or stronger evidence.
- **Remediated:** Use only after a practical change and verification evidence exist.

AD-01, SEC-02, and GPO-02 record corrections completed during supplied live work. NET-01's provider conflict and the listed 2026-10-06 checks are resolved; exclusions and uninspected configuration checks stay open. This update changes documentation only.
