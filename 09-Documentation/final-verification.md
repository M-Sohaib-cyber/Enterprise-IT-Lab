# Final Lab Acceptance Checklist

## Purpose and use

Use this checklist after following the [README build path](../README.md#build-from-zero). These are checks to perform on your rebuild, not claims that new live tests or screenshots have been produced. Run read commands in the named guest, not on the VirtualBox host; use elevated shells where indicated. Use your own passwords and record actual outcomes, dates, lease addresses and any differences.

Keep pfSense/DC01 running for domain/network checks and FS01/CL01 running for file/GPO tests. Use a fresh, normal CL01 session as `CORP\jsmith` (Jhon Smith) for user access tests; use authorized administration for guest configuration checks. Sarah's final disabled account cannot perform the historical enabled Finance-user tests.

## Foundation and networking

| Check | Machine/account and command or UI | Expected result |
|---|---|---|
| VM resources/disks | Host: VirtualBox **Settings > System / Storage** | RAM/vCPU match the [baseline](../01-Enterprise-Planning/device-inventory.md#fresh-build-vm-baseline); FS01 has its system disk and separate 20 GB backup VDI; snapshot differencing disks are not fresh build disks |
| VM attachments | Host: each VM's **Settings > Network**, cable connected | FW01 Adapter 1 NAT, 2 `Corp-Core`, 3 `Corp-Clients`; DC01/FS01 `Corp-Core`; CL01 `Corp-Clients` |
| Lab NAT Networks | Host: **Network Manager > NAT Networks**; documented VBoxManage command | Both enabled: `Corp-Core` `10.10.20.0/24`, gateway `10.10.20.1`; `Corp-Clients` `10.10.30.0/24`, gateway `10.10.30.1`; VirtualBox DHCP and IPv6 disabled on both. Compare with the [verified tested baseline](../02-Network-Design/network-plan.md#nat-network-gateway-verification-checkpoint) |
| pfSense interfaces | FW01: console assignments; WebGUI **Interfaces / Status > Interfaces** | WAN DHCP on NAT; LAN `10.10.20.1/24`; enabled OPT1 `10.10.30.1/24`, IPv6 Configuration Type None. Original `em0/em1/em2` names/WAN lease are observations, not universal hardware/lease requirements |
| Client DHCP | CL01: `ipconfig /all`; pfSense **Status > DHCP Leases** | DHCP address in `10.10.30.100-199`, `/24`, gateway/DHCP `10.10.30.1`, DNS `10.10.20.10`, suffix `corp.internal`; matching guest MAC. Historical `10.10.30.100` is not reserved |
| DHCP service/options | pfSense: **Services > DHCP Server > OPT1**; DC01: `Get-WindowsFeature DHCP` | OPT1 enabled, recorded DNS/gateway/domain, lease 7200/86400 seconds, no static mappings; Windows DHCP role not installed. See [full DHCP record](../04-Active-Directory/dhcp.md) |

## Domain, directory and DNS

| Check | Machine/account and command or UI | Expected result |
|---|---|---|
| Server addressing | DC01/FS01: `hostname`; `ipconfig /all` | Static DC01 `10.10.20.10/24`, FS01 `10.10.20.20/24`; gateway `10.10.20.1`, preferred DNS `10.10.20.10` |
| Domain/DC health | DC01 administrator: `Get-Service NTDS,DNS,Netlogon`; `dcdiag`; `dcdiag /test:dns /v` | Services running; core AD/DNS tests pass. Investigate fresh failures; preserve historical warnings separately rather than assuming a cause |
| Domain identity | DC01: `Get-ADDomain`; `Get-ADForest` | `corp.internal`, NetBIOS `CORP`, `Windows2016Domain` / `Windows2016Forest` |
| Member computers | FS01/CL01: `Get-CimInstance Win32_ComputerSystem`; `nltest /dsgetdc:corp.internal` | Correct name, Domain `corp.internal`, PartOfDomain True; DC discovery identifies DC01 |
| OU/users/computers | DC01: ADUC; `Get-ADOrganizationalUnit -Filter *`; `Get-ADComputer -Filter * -Properties DistinguishedName` | [Verified tree](../04-Active-Directory/active-directory-installation.md#verified-ou-structure---2026-10-06); DC01 in Domain Controllers, FS01 Servers, CL01 Workstations. Jhon/Mohammad enabled in Company Users; Sarah disabled in Disabled Users |
| Group scopes/nesting | DC01: group Properties/Members; [group-check commands](../04-Active-Directory/users-and-groups.md#configuration-checkpoints) | Five GG groups Global Security; six DL groups Domain Local Security; exact direct nesting/members match the inventory; accounts -> GG -> DL -> NTFS |
| AD subnets/Recycle Bin | DC01: `Get-ADReplicationSubnet -Filter * -Properties Site`; `Get-ADOptionalFeature -Filter 'Name -eq "Recycle Bin Feature"'` | Both lab subnets in Default-First-Site-Name; populated EnabledScopes. One DC/no replication partners expected |
| Forward resolution | DC01 and CL01: `nslookup corp.internal 10.10.20.10`; repeat for `Corp-DC01.corp.internal`, `Corp-FS01.corp.internal`, `Corp-CL01.corp.internal` | Domain/DC -> `10.10.20.10`; FS -> `10.10.20.20`; CL -> its actual current lease |
| Reverse/service discovery | CL01: `nslookup 10.10.20.10 10.10.20.10`; `nslookup -type=SRV _ldap._tcp.dc._msdcs.corp.internal 10.10.20.10` | DC PTR -> Corp-DC01.corp.internal; SRV identifies DC01. DNS Manager shows recorded `20.10.10.in-addr.arpa` zone/properties; no unverified additional PTRs required |

## Policies and file access

| Check | Machine/account and command or UI | Expected result |
|---|---|---|
| Policy application | CL01/Jhon: `gpupdate /force`, `gpresult /r`; elevated shell: `gpresult /r /scope computer` | Recorded user/computer policies apply; compare with the [authoritative GPO results](../04-Active-Directory/group-policy.md#live-verification---2026-09-16). Sign out/in or restart when required |
| Domain password/lockout | DC01: `Get-ADDefaultDomainPasswordPolicy` | Length 8, history 5, ages 1/90 days, complexity enabled, threshold 5, lockout/reset 30 minutes; do not deliberately lock an administrative account |
| Workstation controls | CL01: [policy-specific UI/registry checks](../04-Active-Directory/group-policy.md#implement-the-recorded-policies) | InactivityTimeoutSecs `0x258` (600 seconds); AUOptions `0x3`; Control Panel/PC settings blocked; removable access denied when test media is available; local Administrators contains CORP\GG_IT |
| Wallpaper | CL01/Jhon: open `\\Corp-FS01\Public\company-wallpaper.jpg`, refresh policy and sign out/in | Reader-provided file readable and applied, or documented accessible substitute; original asset/style not supplied |
| Share definitions/ACLs | FS01 administrator: `Get-SmbShare -Name Finance,HR,IT,Public,Sales`; repeat `Get-SmbShareAccess` / `Get-Acl` per share | Five `C:\Shares` paths; Everyone Full at share level; recorded DL Modify/read rights at NTFS. Review inherited broad access; complete original ACL equivalence remains a flagged gap |
| Drive mappings | CL01/Jhon: File Explorer and `net use` | I: `\\Corp-FS01\IT` and P: `\\Corp-FS01\Public` appear; F: absent. I:/F: targets GG_IT/GG_Finance; mapping visibility is not an ACL test |
| Authorized/read-only access | CL01/Jhon: [safe UNC tests](../03-Virtual-Infrastructure/file-server.md#positive-and-negative-access-checkpoints) | IT read/create/delete succeeds; Public read succeeds and create is denied; remove temporary IT file |
| Unauthorized access | CL01/Jhon: open Finance, HR and Sales UNC shares | Access denied on all three. Do not treat an absent mapped drive as proof of denial |

## Firewall and internet

| Check | Machine/account and command or UI | Expected result |
|---|---|---|
| Final rule order/logging | pfSense: **Firewall > Rules > OPT1**, not the historical broad-rule screenshot | DC exception, FS TCP 445 exception, server-network block with logging, then allow other destinations; no bootstrap allow before the block. Aliases intentionally unused; verify unrecorded DC-rule fields before exact-match claims |
| DC/DNS and SMB | CL01: `ping 10.10.20.10`; DNS checks above; `Test-NetConnection 10.10.20.20 -Port 445` | DC reachable, DNS works, TcpTestSucceeded True; actual allowed/denied share tests also pass |
| Segmentation/logging | CL01: `ping 10.10.20.20`; pfSense raw log: `tail -20 /var/log/filter.log` | FS01 ping blocked/failed intentionally; fresh matching ICMP block entry from actual client lease. Stale GUI display does not establish raw logging failure |
| NAT/internet | pfSense **Firewall > NAT > Outbound**; CL01 `ping 8.8.8.8`; `nslookup google.com 10.10.20.10` | Automatic outbound NAT; recorded external ping and DNS tests succeed. Internet reachability alone does not prove server segmentation |

See the [firewall record](../08-Security/firewall-rules.md) for the 2026-09-20 practical tests and the 2026-10-07 ruleset review. The later review did not claim a new internet test or any configuration change.

## Backup and recovery

| Check | Machine/account and command or UI | Expected result |
|---|---|---|
| Feature/disk/time | FS01 administrator: `Get-WindowsFeature Windows-Server-Backup`; VirtualBox Storage; `tzutil /g`; `w32tm /query /source` | Feature Installed; separate 20 GB backup VDI; GMT Standard Time; Corp-DC01.corp.internal source and successful resync/status check |
| Scope/schedule | FS01: Windows Server Backup **Local Backup > Backup Schedule** | Custom `C:\Shares`, no exclusions, VSS Copy Backup, dedicated disk, once daily 23:00; initial B: letter not assumed after dedication |
| Manual backup/version | FS01: **Backup Once** using scheduled options; elevated `wbadmin get versions` | Successful manual run and new listed file-recoverable version; attached target accessible. Catalog listing alone is not restore proof |
| Automatic execution | FS01: WSB details and generated backup-task history after an unattended trigger | Automatic initiation and successful completion correlated with new version, without manual trigger. Final daily 23:00 retained; a manual run is not enough |
| File restore | FS01 administrator: [disposable-file test](../03-Virtual-Infrastructure/file-server.md#5-perform-a-safe-file-level-restore-test) | File in a successful backup, only test file deleted, restored to original location with Restore ACL permissions enabled, contents verified; separate ACL comparison if performed; temporary file cleaned up |

The reference automatic run succeeded at temporary 10:00 on 2026-10-07, then 23:00 was restored. The historical file restore/content test remains verified; no separate post-restore ACL comparison or practical volume/disaster recovery is claimed.

## Reproduction limits

Core functional acceptance and an exact configuration match are different claims. Record unsupported fields as **Not established**, not PASS by assumption. Remaining exact-match gaps are:

- Complete NTFS ACLs, inheritance/application flags, administrative entries/owners and uninspected share properties; see [share implementation limits](../03-Virtual-Infrastructure/file-server.md#implement-shares-and-resource-permissions).
- Restricted Groups identity/both membership lists; complete drive-map actions/options/targeting; wallpaper style; GPO filtering/delegation/link metadata and Default Domain Controllers Policy fields; see [GPO instructions](../04-Active-Directory/group-policy.md#implement-the-recorded-policies).
- Exact firewall DC exception protocol/ports, complete WAN/LAN rulesets/generated NAT details, and uninspected DNS/DHCP properties; see [firewall](../08-Security/firewall-rules.md#to-verify), [DNS](../04-Active-Directory/dns.md#to-verify), and [DHCP](../04-Active-Directory/dhcp.md#remaining-verification-scope).
- Original installation/media/credential choices, some live VM disk/firmware settings and exact patch state, original wallpaper asset, and backup target identifiers/retention. Reader choices are identified in the build guides; they are not recovered historical values.

Use the [known-issues register](known-issues.md) for unresolved troubleshooting and the [roadmap](../00-Project-Overview/Lab-Roadmap.md) for future work. Broader hardening, multi-DC replication, monitoring, offsite backup and disaster recovery are outside completed core-lab acceptance.
