# Active Directory OU, User, and Group Inventory

## Scope

This is the authoritative inventory of Active Directory objects named in current repository documentation or evidence. It is not a live directory export. Values that cannot be established from the repository are marked **To verify**.

- Domain: `corp.internal`
- NetBIOS name: `CORP`
- Domain controller: `Corp-DC01`

## Organizational units

| OU | Parent | Documented use | Current status |
|---|---|---|---|
| `Admins` | Domain root | Administrative accounts | Exists in deployment record; contents To verify |
| `IT Admins` | `Admins` | IT administrative accounts | Exists in deployment record; contents To verify |
| `Company Users` | Domain root | Standard domain users and user-linked GPOs | Used by documented users and GPOs |
| `Disabled Users` | Domain root | Disabled accounts retained after offboarding | Created and used during Sarah Ahmed offboarding |
| `Groups` | Domain root | Security groups | Exists in deployment record; exact contents To verify |
| `Servers` | Domain root | Server computer objects | Exists in deployment record; exact contents To verify |
| `Service Accounts` | Domain root | Service accounts | Exists in deployment record; no service account is confirmed |
| `Workstations` | Domain root | Client computer objects and computer-linked GPOs | Contains documented `Corp-CL01` object |

Exact distinguished names, protection-from-deletion settings, delegation, and any additional OUs remain **To verify**.

## Documented users

| Display name | Username | Recorded OU/status | Confirmed membership or use |
|---|---|---|---|
| Jhon Smith | `jsmith` | `Company Users`; enabled state To verify | `Domain Users`, `GG_IT`; used for GPO, file-access, lockout, and recovery tests |
| Sarah Ahmed | `sahmed` | `Disabled Users`; documented as disabled after offboarding | `Domain Users` after removal from `GG_Finance`; used for Finance onboarding/offboarding tests |

Live verification on 2026-09-16 confirmed Jhon Smith (`jsmith`) is a member of `Domain Users` and `GG_IT`. `GPO - Local Administrators` intentionally adds `GG_IT` to workstation local Administrators, so Jhon receives local administrator rights on `Corp-CL01` as an IT user. Current enabled/locked state, memberships beyond those confirmed, account attributes, and password state require live verification. Password values are not documented.

## Documented global groups

| Group | Recorded category/scope | Documented purpose | Confirmed membership |
|---|---|---|---|
| `GG_IT` | Global Security | IT department/access group | `jsmith` confirmed by existing command output and screenshot |
| `GG_HR` | Global Security | Human Resources department | To verify |
| `GG_Finance` | Global Security | Finance department and Finance drive targeting | `sahmed` was added during onboarding and removed during offboarding |
| `GG_Sales` | Global Security | Sales department | To verify |
| `GG_HelpDesk` | Global Security | Helpdesk team | To verify |

## Documented `DL_*` resource groups

Live verification on 2026-09-16 confirmed all `DL_*` security groups were corrected from Global to Domain Local using Universal as the intermediate scope (Global -> Universal -> Domain Local). The following nesting was verified; each resource group contains the listed member:

| Resource group | Intended resource use | Verified scope | Verified member |
|---|---|---|---|
| `DL_Finance_RW` | Modify access to Finance share | Domain Local Security | `GG_Finance` |
| `DL_HelpDesk_RW` | Helpdesk resource access; use To verify | Domain Local Security | `GG_HelpDesk` |
| `DL_HR_RW` | Modify access to HR share | Domain Local Security | `GG_HR` |
| `DL_IT_RW` | Modify access to IT share | Domain Local Security | `GG_IT` |
| `DL_Public_RO` | Read access to Public share | Domain Local Security | `Domain Users` |
| `DL_Sales_RW` | Modify access to Sales share | Domain Local Security | `GG_Sales` |

Finance NTFS grants `DL_Finance_RW` Modify, and IT NTFS grants `DL_IT_RW` Modify. These checked paths match the intended AGDLP model; complete ACLs and other resource permissions remain **To verify**.

`DL_HelpDesk_RW` resource use and HR, Sales, and Public ACL entries remain **To verify**. See [Group-Based File Permissions](agdlp-and-permissions.md).

## Documented computer objects

| Computer | Recorded location/status |
|---|---|
| `Corp-DC01` | Domain controller for `corp.internal` |
| `Corp-CL01` | Domain joined and moved to `Workstations` |
| `Corp-FS01` | File server exists; computer-object OU To verify |

## Evidence

- [Groups](../Screenshots/Active%20Directory/01-Groups.png)
- [New user password setup](../Screenshots/Active%20Directory/02-New%20user%20password%20setup.png)
- [Adding user to group](../Screenshots/Active%20Directory/03-Adding%20user%20to%20group.png)
- [John Smith group output](../Screenshots/Troubleshooting/01-whoami-groups.png)

## Related procedures

- [Finance onboarding](../05-Client-Management/onboarding.md)
- [Finance offboarding](../05-Client-Management/offboarding.md)
- [Account recovery](../06-Helpdesk/account-recovery.md)
- [Group Policy inventory](gpo-inventory.md)
- [Corp-FS01 file server](../03-Virtual-Infrastructure/file-server.md)
