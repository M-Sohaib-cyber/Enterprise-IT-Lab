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
| John Smith | `jsmith` | `Company Users`; enabled state To verify | `Domain Users`, `GG_IT`; used for GPO, file-access, lockout, and recovery tests |
| Sarah Ahmed | `sahmed` | `Disabled Users`; documented as disabled after offboarding | `Domain Users` after removal from `GG_Finance`; used for Finance onboarding/offboarding tests |

The current enabled/locked state, complete memberships, account attributes, and password state require live verification. Password values are not documented.

## Documented global groups

| Group | Recorded category/scope | Documented purpose | Confirmed membership |
|---|---|---|---|
| `GG_IT` | Global Security | IT department/access group | `jsmith` confirmed by existing command output and screenshot |
| `GG_HR` | Global Security | Human Resources department | To verify |
| `GG_Finance` | Global Security | Finance department and Finance drive targeting | `sahmed` was added during onboarding and removed during offboarding |
| `GG_Sales` | Global Security | Sales department | To verify |
| `GG_HelpDesk` | Global Security | Helpdesk team | To verify |

## Documented `DL_*` resource groups

| Group | Intended resource use | Recorded current scope |
|---|---|---|
| `DL_IT_RW` | Modify access to IT share | Reported as Global Security; live scope To verify |
| `DL_HR_RW` | Modify access to HR share | Reported as Global Security; live scope To verify |
| `DL_Finance_RW` | Modify access to Finance share | Reported as Global Security; live scope To verify |
| `DL_Sales_RW` | Modify access to Sales share | Reported as Global Security; live scope To verify |
| `DL_HelpDesk_RW` | Helpdesk resource access | Reported as Global Security; resource use To verify |
| `DL_Public_RO` | Read access to Public share | Reported as Global Security; live scope To verify |

Despite the `DL_` prefix, the repository records that these groups were accidentally created as **Global Security** groups rather than **Domain Local Security** groups. Existing records also conflict over whether `GG_*` groups were nested into them or whether the `DL_*` groups were assigned directly to NTFS permissions. The actual scope, nesting, and ACL use must be verified live.

The lab must not be described as having a fully or correctly implemented AGDLP model. See [Group-Based File Permissions](agdlp-and-permissions.md).

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
