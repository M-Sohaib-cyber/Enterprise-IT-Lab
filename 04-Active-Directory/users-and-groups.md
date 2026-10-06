# Active Directory OU, User, and Group Inventory

## Scope

This is the authoritative inventory of Active Directory objects named in current repository documentation or evidence. It is not a live directory export. Values that cannot be established from the repository are marked **To verify**.

- Domain: `corp.internal`
- NetBIOS name: `CORP`
- Domain controller: `Corp-DC01`

## Organizational units

All OUs listed below were verified on 2026-10-06, including `IT Admins` nested beneath `Admins`.

| OU | Parent | Documented use | Current status |
|---|---|---|---|
| `Admins` | Domain root | Administrative accounts | Verified 2026-10-06; no user accounts, reserved/unused |
| `IT Admins` | `Admins` | IT administrative accounts | Verified 2026-10-06; no user accounts, reserved/unused |
| `Company Users` | Domain root | Standard domain users and user-linked GPOs | Used by documented users and GPOs |
| `Disabled Users` | Domain root | Disabled accounts retained after offboarding | Created and used during Sarah Ahmed offboarding |
| `Groups` | Domain root | Security groups | Exists in deployment record; exact contents To verify |
| `Servers` | Domain root | Server computer objects | Contains enabled `CORP-FS01`, verified 2026-10-06; other contents To verify |
| `Service Accounts` | Domain root | Service accounts | Verified 2026-10-06; no user accounts, reserved/unused |
| `Workstations` | Domain root | Client computer objects and computer-linked GPOs | Contains enabled `CORP-CL01`; verified 2026-10-06 |
| `Domain Controllers` | Domain root | Domain-controller computer objects | Contains enabled `CORP-DC01`; verified 2026-10-06 |

Exact distinguished names, protection-from-deletion settings, delegation, and any additional OUs remain **To verify**.

## Documented users

| Display name | Username | Recorded OU/status | Confirmed membership or use |
|---|---|---|---|
| Jhon Smith | `jsmith` | `Company Users`; enabled, verified 2026-10-06 | `Domain Users`, `GG_IT`; used for GPO, file-access, lockout, and recovery tests |
| Mohammad Sohail | `msohail` | `Company Users`; enabled, verified 2026-10-06 | Direct member of `GG_IT` |
| Sarah Ahmed | `sahmed` | `Disabled Users`; disabled, verified 2026-10-06 | `Domain Users` after removal from `GG_Finance`; used for Finance onboarding/offboarding tests |

Live verification on 2026-09-16 confirmed Jhon Smith (`jsmith`) is a member of `Domain Users` and `GG_IT`. `GPO - Local Administrators` intentionally adds `GG_IT` to workstation local Administrators, so Jhon receives local administrator rights on `Corp-CL01` as an IT user. Verification on 2026-10-06 confirmed the enabled states and OU locations above, with Administrator enabled and Guest and krbtgt disabled. Sarah is the existing disabled lab account demonstrating the offboarding/disabled-user lifecycle. Locked state, memberships beyond those confirmed, other account attributes, and password state remain to verify. Password values are not documented.

## Verified global groups - 2026-10-06

All five listed `GG_*` groups were verified as Global Security groups. Empty direct-user memberships are recorded as observed; no additional users are inferred.

| Group | Recorded category/scope | Documented purpose | Confirmed membership |
|---|---|---|---|
| `GG_IT` | Global Security | IT department/access group | Direct users: Jhon Smith (`jsmith`) and Mohammad Sohail (`msohail`); verified 2026-10-06 |
| `GG_HR` | Global Security | Human Resources department | No direct users; verified 2026-10-06 |
| `GG_Finance` | Global Security | Finance department and Finance drive targeting | No direct users, verified 2026-10-06; `sahmed` was added during onboarding and removed during offboarding |
| `GG_Sales` | Global Security | Sales department | No direct users; verified 2026-10-06 |
| `GG_HelpDesk` | Global Security | Helpdesk team | No direct users; verified 2026-10-06 |

## Documented `DL_*` resource groups

Live verification on 2026-09-16 confirmed all `DL_*` security groups were corrected from Global to Domain Local using Universal as the intermediate scope (Global -> Universal -> Domain Local). Verification on 2026-10-06 reconfirmed all six listed `DL_*` groups as DomainLocal Security groups and the following direct nesting; each resource group contains the listed member:

| Resource group | Intended resource use | Verified scope | Verified member |
|---|---|---|---|
| `DL_Finance_RW` | Modify access to Finance share | Domain Local Security | `GG_Finance` |
| `DL_HelpDesk_RW` | Helpdesk resource access; use To verify | Domain Local Security | `GG_HelpDesk` |
| `DL_HR_RW` | Modify access to HR share | Domain Local Security | `GG_HR` |
| `DL_IT_RW` | Modify access to IT share | Domain Local Security | `GG_IT` |
| `DL_Public_RO` | Read access to Public share | Domain Local Security | `Domain Users` |
| `DL_Sales_RW` | Modify access to Sales share | Domain Local Security | `GG_Sales` |

Latest supplied verification on 2026-10-06 confirmed Finance `DL_Finance_RW`, HR `DL_HR_RW`, IT `DL_IT_RW`, and Sales `DL_Sales_RW` with Modify, and Public `DL_Public_RO` with Read & Execute. All five shares intentionally grant `Everyone: Full`; NTFS is the authorization layer. `SYSTEM`, `BUILTIN\Administrators`, and `Domain Admins` retain appropriate administrative permissions. Complete ACLs and inheritance beyond these entries remain **To verify**.

`DL_HelpDesk_RW` resource use and complete ACLs/inheritance beyond the verified entries remain **To verify**. See [Group-Based File Permissions](agdlp-and-permissions.md).

## Documented computer objects

| Computer | Recorded location/status |
|---|---|
| `CORP-DC01` | Enabled; `Domain Controllers` OU; verified 2026-10-06 |
| `CORP-CL01` | Enabled; `Workstations` OU; verified 2026-10-06 |
| `CORP-FS01` | Enabled; `Servers` OU; verified 2026-10-06 |

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
