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
| Forest functional level | To verify |
| Domain functional level | To verify |

Older documentation contained unsupported Windows Server 2025 OS and functional-level values. Existing records also name Windows Server 2016 functional levels. The live levels must be verified before either is stated as current.

## Recorded OU structure

The repository documents this OU structure:

```text
corp.internal
|-- Admins
|   `-- IT Admins
|-- Company Users
|-- Disabled Users
|-- Groups
|-- Servers
|-- Service Accounts
`-- Workstations
```

`Disabled Users` was added during the documented employee offboarding exercise. A current AD export is not present, so exact OU distinguished names and any additional OUs remain **To verify**.

## Recorded users and groups

The repository documents:

- Jhon Smith (`jsmith`) in `Company Users`, with `GG_IT` membership
- Sarah Ahmed (`sahmed`) created for a Finance onboarding exercise and later disabled, removed from `GG_Finance`, and moved to `Disabled Users`
- Global groups `GG_IT`, `GG_HR`, `GG_Finance`, `GG_Sales`, and `GG_HelpDesk`
- `DL_*` resource groups used in the file-access documentation

Live verification on 2026-09-16 confirmed all `DL_*` security groups were corrected from Global through Universal to Domain Local, with all six resource-group memberships verified. Finance and IT NTFS Modify entries were also confirmed; see [Group-Based File Permissions](agdlp-and-permissions.md). Jhon's `Domain Users` and `GG_IT` membership was confirmed.

Detailed user, group, onboarding, offboarding, and helpdesk records remain in [Users and Groups](users-and-groups.md).

## Recorded computer objects

| Computer | Recorded location/status |
|---|---|
| `Corp-DC01` | Domain controller for `corp.internal` |
| `Corp-CL01` | Domain joined and moved to `Workstations` |
| `Corp-FS01` | File server exists; computer-object OU To verify |

## Documented verification

Existing documentation records:

- Successful creation of the `corp.internal` forest/domain
- DNS installed with AD DS
- Successful promotion and restart of `Corp-DC01`
- Successful join and domain login of `Corp-CL01`
- Creation and use of OUs, users, and security groups

These are existing implementation records. Live verification on 2026-09-16 additionally confirmed all five FSMO roles on `Corp-DC01` and successful DNS resolution for `corp.internal` and `Corp-DC01.corp.internal`. `dcdiag` generally passed, with a WinRM WSMAN SPN warning remaining for investigation.

## To verify

- Forest and domain functional levels
- Complete current OU, user, group, and computer inventory
- Group inventory and memberships beyond the confirmed `DL_*` scopes/nesting and Jhon's memberships
- `Corp-FS01` computer-object location
- Sites and Services, replication configuration, trusts, and recovery configuration
- WinRM WSMAN SPN warning

No unverified feature is claimed as implemented.

## Related documentation

- [Corp-DC01 Build and Configuration](../03-Virtual-Infrastructure/windows-server-build-guide.md)
- [Active Directory DNS](dns.md)
- [Users and Groups](users-and-groups.md)
- [Group Policy](group-policy.md)
- [Corp-FS01 File Server](../03-Virtual-Infrastructure/file-server.md)
