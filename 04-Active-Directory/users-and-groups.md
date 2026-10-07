# Active Directory OU, User, and Group Inventory

## Scope

This is the authoritative inventory of Active Directory objects named in current repository documentation or evidence. It is not a live directory export. Values that cannot be established from the repository are marked **To verify**.

- Domain: `corp.internal`
- NetBIOS name: `CORP`
- Domain controller: `Corp-DC01`

## Implement users and security groups

Complete the [OU foundation](active-directory-installation.md#implement-the-directory-foundation) first. Use **Active Directory Users and Computers** on DC01. The tables below are the inventory to reproduce; these instructions do not authorize extra accounts or infer undisclosed attributes.

### Create the documented accounts

1. In `Company Users`, choose **New > User**. Create Jhon Smith with logon name `jsmith`, then Mohammad Sohail with logon name `msohail`; use the `corp.internal` logon suffix and verify the pre-Windows 2000 names match the listed usernames. Preserve the recorded spelling **Jhon**.
2. Supply your own passwords satisfying the domain policy. Passwords, password-expiry flags, and the original first-logon selections for these two users are unrecorded; do not treat wizard defaults as historical facts. Both accounts must be enabled in the final state. If your setup requires a first-logon password change, complete it before client tests.
3. To reproduce the final Sarah record directly, create Sarah Ahmed (`sahmed`) in `Disabled Users`, supply a reader-chosen password if prompted, and ensure **Account is disabled** is selected in the account properties. Do not add her to `GG_Finance` in the final state. Alternatively, reproduce [onboarding](../05-Client-Management/onboarding.md) and then [offboarding](../05-Client-Management/offboarding.md); the latter must be completed to reach the documented final state.
4. Check each user's **Member Of** tab. Retain the normal `Domain Users` membership; add only the verified memberships described below. Do not create replacement Administrator, Guest, or krbtgt accounts, enable Guest/krbtgt, populate the reserved OUs, or recreate the cleaned-up recovery-test account.

Display names/usernames and final OU/enabled states are recorded. Exact given-name/surname fields, UPNs beyond the rebuild convention above, descriptions, department attributes, password settings, and additional memberships remain **To verify**.

### Create groups and implement AGDLP

1. In `Groups`, choose **New > Group** for each of `GG_IT`, `GG_HR`, `GG_Finance`, `GG_Sales`, and `GG_HelpDesk`. Select **Global** scope and **Security** type. The `Groups` OU is the documented group location; a current complete OU-content export is not available.
2. Create `DL_Finance_RW`, `DL_HelpDesk_RW`, `DL_HR_RW`, `DL_IT_RW`, `DL_Public_RO`, and `DL_Sales_RW` with **Domain local** scope and **Security** type. For a fresh build, create the correct scope directly.
3. Open `GG_IT > Properties > Members > Add` and add `jsmith` and `msohail`; use **Check Names** before saving. Leave the other four GG groups with no direct users to match the latest verified inventory.
4. Open each DL group's **Members** tab and add the exact member from the resource-group table below. In particular, add the existing Global group `Domain Users` to `DL_Public_RO`; do not invent a `GG_Public` group. Do not assign an undocumented HelpDesk share or ACL.
5. Reopen group properties to confirm scopes, types, and direct members. The required chain is **Accounts -> Global groups -> Domain Local groups -> NTFS permissions**. `jsmith -> GG_IT -> DL_IT_RW -> IT Modify` is the verified department example; `Domain Users -> DL_Public_RO -> Public Read & Execute` provides public read access.

The historical DL scope error and Global -> Universal -> Domain Local correction remain below as a lesson. They are not steps required for a new build. If repairing an existing wrong-scope group, check conversion eligibility and memberships first; do not recreate groups and lose their permission identities. Microsoft's [security-group reference](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups) explains scope rules.

### Configuration checkpoints

Run these read checks in PowerShell on DC01 and compare their output with the inventory below:

```powershell
Get-ADGroup -Filter 'Name -like "GG_*" -or Name -like "DL_*"' | Select-Object Name,GroupScope,GroupCategory
Get-ADGroupMember GG_IT
Get-ADGroupMember GG_Finance
Get-ADGroupMember GG_HR
Get-ADGroupMember GG_Sales
Get-ADGroupMember GG_HelpDesk
Get-ADGroupMember DL_Finance_RW
Get-ADGroupMember DL_HelpDesk_RW
Get-ADGroupMember DL_HR_RW
Get-ADGroupMember DL_IT_RW
Get-ADGroupMember DL_Public_RO
Get-ADGroupMember DL_Sales_RW
Get-ADUser jsmith -Properties Enabled,MemberOf | Select-Object SamAccountName,Enabled,DistinguishedName,MemberOf
Get-ADUser msohail -Properties Enabled,MemberOf | Select-Object SamAccountName,Enabled,DistinguishedName,MemberOf
Get-ADUser sahmed -Properties Enabled,MemberOf | Select-Object SamAccountName,Enabled,DistinguishedName,MemberOf
```

`MemberOf` does not list a user's primary group; check `Domain Users` through ADUC rather than interpreting its omission as missing membership. Refresh a user's logon session after membership changes before checking `whoami /groups` on CL01. Proceed to [share permissions](../03-Virtual-Infrastructure/file-server.md#implement-shares-and-resource-permissions) once scopes and nesting match.

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
