# Active Directory Configuration Record

## Scope

This document records the Active Directory configuration associated with the completed `corp.internal` deployment. The authoritative server build, networking, promotion settings, and verification record are maintained in [Corp-DC01 Build and Configuration](../03-Virtual-Infrastructure/windows-server-build-guide.md).

## Domain

| Item | Confirmed value |
|---|---|
| Domain controller | `Corp-DC01` |
| Server OS | Windows Server 2022 |
| Forest/domain | `corp.internal` |
| NetBIOS name | `CORP` |
| DNS | Installed on `Corp-DC01` |
| Global Catalog | Enabled in the deployment record |
| Forest functional level | `Windows2016Forest`; verified 2026-10-06 |
| Domain functional level | `Windows2016Domain`; verified 2026-10-06 |

Verification on 2026-10-06 confirmed the Windows Server 2016 forest/domain functional levels above, resolving the older conflicting records. No functional-level change was performed.

## Verified OU structure - 2026-10-06

Live verification confirmed these OUs:

```text
corp.internal
|-- Admins
|   `-- IT Admins
|-- Company Users
|-- Disabled Users
|-- Domain Controllers
|-- Groups
|-- Servers
|-- Service Accounts
`-- Workstations
```

`Disabled Users` was added during the documented employee offboarding exercise. `Admins`, its nested `IT Admins`, and `Service Accounts` currently contain no user accounts and are reserved/unused. Exact distinguished names, delegation, protection settings, and any additional objects beyond the verified inventory remain **To verify**.

## Recorded users and groups

The repository documents:

- Jhon Smith (`jsmith`) and Mohammad Sohail (`msohail`): enabled in `Company Users`, both direct members of `GG_IT` (verified 2026-10-06)
- Administrator enabled; Guest and krbtgt disabled (verified 2026-10-06)
- Sarah Ahmed (`sahmed`) created for a Finance onboarding exercise and later disabled, removed from `GG_Finance`, and moved to `Disabled Users`
- Global groups `GG_IT`, `GG_HR`, `GG_Finance`, `GG_Sales`, and `GG_HelpDesk`
- `DL_*` resource groups used in the file-access documentation

Live verification on 2026-09-16 confirmed all `DL_*` security groups were corrected from Global through Universal to Domain Local, with all six resource-group memberships verified. Finance and IT NTFS Modify entries were also confirmed; see [Group-Based File Permissions](agdlp-and-permissions.md). Jhon's `Domain Users` and `GG_IT` membership was confirmed.

Detailed user, group, onboarding, offboarding, and helpdesk records remain in [Users and Groups](users-and-groups.md).

## Recorded computer objects

| Computer | Recorded location/status |
|---|---|
| `CORP-DC01` | Enabled; `Domain Controllers` OU; verified 2026-10-06 |
| `CORP-CL01` | Enabled; `Workstations` OU; verified 2026-10-06 |
| `CORP-FS01` | Enabled; `Servers` OU; verified 2026-10-06 |

## Documented verification

Existing documentation records:

- Successful creation of the `corp.internal` forest/domain
- DNS installed with AD DS
- Successful promotion and restart of `Corp-DC01`
- Successful join and domain login of `Corp-CL01`
- Creation and use of OUs, users, and security groups

These are existing implementation records. Live verification on 2026-09-16 additionally confirmed all five FSMO roles on `Corp-DC01` and successful DNS resolution for `corp.internal` and `Corp-DC01.corp.internal`. `dcdiag` generally passed, with a WinRM WSMAN SPN warning remaining for investigation.

## AD health, topology, trusts, and FSMO verification - 2026-10-06

Standard `dcdiag` completed successfully: all reported tests passed, with no failed tests observed. The historical 2026-09-16 WinRM WSMAN SPN warning is retained as an observation; this result does not establish its cause or a specific remediation.

`repadmin /replsummary` showed no source or destination replication partners. `repadmin /showrepl` identified `Default-First-Site-Name\CORP-DC01`. This is a single-domain-controller lab, so absence of replication partners is expected. Multi-DC replication testing is not applicable to the current topology.

`Get-ADTrust -Filter *` returned no configured trusts; `corp.internal` currently operates without configured AD trusts.

All five FSMO roles were verified on `Corp-DC01.corp.internal`: Schema Master, Domain Naming Master, PDC Emulator, RID Master, and Infrastructure Master.

The default domain password/lockout policy was also verified: minimum length 8, history 5, maximum age 90 days, minimum age 1 day, complexity enabled, lockout threshold 5, duration 30 minutes, and observation/reset window 30 minutes. See [Group Policy Inventory](gpo-inventory.md).

## Controlled improvement: AD subnet registration - 2026-10-06

Initial verification showed site `Default-First-Site-Name` with no AD replication subnets configured. During the supplied live work, subnet objects `10.10.20.0/24` and `10.10.30.0/24` were added to this site. PowerShell verification confirmed both objects exist and are associated with `Default-First-Site-Name`. This records one site with two registered subnets.

## Controlled improvement: AD Recycle Bin - 2026-10-06

Initially, Recycle Bin Feature had an empty `EnabledScopes` value and was disabled. During the supplied live work, AD Recycle Bin was enabled for the `corp.internal` forest; PowerShell verification confirmed `EnabledScopes` became populated.

A temporary `Recovery Test` (`recovery.test`) account was created, deleted, restored to its original `Company Users` OU in a disabled state, verified, and deleted again after successful testing. Final `Get-ADUser recovery.test` returned object not found. This account is not part of the permanent active user inventory. See [Account Recovery](../06-Helpdesk/account-recovery.md) for the practical test; no purge of all historical Deleted Objects is claimed.

These two configuration improvements were completed during the supplied live work. This documentation update changes no live configuration.

## To verify

- Objects and account attributes beyond the verified OU, user, group, and computer inventory
- Group inventory and memberships beyond the verified direct nesting and direct users listed in [Users and Groups](users-and-groups.md)
- Uninspected Sites and Services settings and recovery capabilities beyond the registered subnets and tested Recycle Bin restore; broader backup/recovery remains unverified
- WinRM WSMAN SPN warning

No unverified feature is claimed as implemented.

## Related documentation

- [Corp-DC01 Build and Configuration](../03-Virtual-Infrastructure/windows-server-build-guide.md)
- [Active Directory DNS](dns.md)
- [Users and Groups](users-and-groups.md)
- [Group Policy](group-policy.md)
- [Corp-FS01 File Server](../03-Virtual-Infrastructure/file-server.md)
