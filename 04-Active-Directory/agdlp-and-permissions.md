# Group-Based File Permissions

## Purpose

This document distinguishes the intended AGDLP permission model from the implementation currently recorded in the lab. Share names, paths, tests, and storage details are maintained in [Corp-FS01 File Server](../03-Virtual-Infrastructure/file-server.md).

## Intended model

The intended design was:

```text
Accounts
  -> Global department groups (GG_*)
  -> Domain Local resource groups (DL_*)
  -> NTFS permissions
```

Examples documented in the original design include `GG_IT` to `DL_IT_RW` and `GG_Finance` to `DL_Finance_RW`. Live verification on 2026-09-16 confirmed these group scopes and nesting after correction.

## Implement the verified permission chain

1. Follow [Users and Groups](users-and-groups.md#implement-users-and-security-groups) to create Global Security GG groups and Domain Local Security DL groups, then add the direct members shown below. New DL groups must start as Domain Local; the historical conversion is a correction lesson, not a required build step.
2. Follow the [FS01 folder, share, and NTFS procedure](../03-Virtual-Infrastructure/file-server.md#implement-shares-and-resource-permissions). Share permissions are intentionally `Everyone: Full Control`; the DL-group NTFS rights implement authorization.
3. Review inherited permissions before exposing the shares. The correct DL entry alone cannot establish isolation if another Allow grants broad access. Complete ACLs, administrative application flags, and inheritance choices remain unrecorded; the FS01 procedure flags those exact-match limits rather than supplying guessed settings.
4. Verify scopes and direct nesting on DC01, then use a fresh CL01 logon to check allowed IT access, read-only Public access, and denied Finance/HR/Sales access as Jhon. The positive/negative test steps are in the linked FS01 procedure; historical Finance tests require the earlier enabled Sarah state, not her current disabled state.

Proceed to GPO drive mappings after UNC access succeeds. A drive-map target controls whether a preference is applied; it is not a replacement for NTFS authorization. `DL_HelpDesk_RW` is a verified nested group, but its resource use is not established and no HelpDesk ACL is prescribed.

## Recorded implementation

Live verification on 2026-09-16 confirmed all `DL_*` security groups were corrected from Global to Domain Local using Universal as the intermediate scope (Global -> Universal -> Domain Local). Verification on 2026-10-06 reconfirmed all six listed `DL_*` groups as DomainLocal Security groups and the following direct nesting; each resource group contains the listed member:

| Resource group | Verified member |
|---|---|
| `DL_Finance_RW` | `GG_Finance` |
| `DL_HelpDesk_RW` | `GG_HelpDesk` |
| `DL_HR_RW` | `GG_HR` |
| `DL_IT_RW` | `GG_IT` |
| `DL_Public_RO` | `Domain Users` |
| `DL_Sales_RW` | `GG_Sales` |

Latest supplied verification on 2026-10-06 confirmed Finance `DL_Finance_RW`, HR `DL_HR_RW`, IT `DL_IT_RW`, and Sales `DL_Sales_RW` with Modify, and Public `DL_Public_RO` with Read & Execute. All five shares intentionally grant `Everyone: Full`; NTFS is the authorization layer. `SYSTEM`, `BUILTIN\Administrators`, and `Domain Admins` retain appropriate administrative permissions. Complete ACLs and inheritance beyond these entries remain **To verify**.

All five listed department `GG_*` groups are Global Security groups, verified 2026-10-06. `GG_IT` directly contains Jhon Smith and Mohammad Sohail; `GG_Finance`, `GG_HelpDesk`, `GG_HR`, and `GG_Sales` currently have no direct users. These inventory checks do not verify additional ACLs or new file-access behavior. See [Users and Groups](users-and-groups.md).

## Documented access tests

The existing records describe:

- `CORP\jsmith`, a documented `GG_IT` member, receiving the IT and Public mapped drives.
- Successful create/delete testing on the IT drive.
- Create access denied on the Public drive.
- `CORP\sahmed` receiving the Finance drive during the onboarding exercise.
- Successful create/delete testing on the Finance drive and access denied to the IT drive for the Finance user.

These historical access tests are distinct from the live scope and nesting verification on 2026-09-16. During the live checks, Jhon received `I:` and `P:` after `gpupdate`, with `F:` correctly absent.

Latest supplied testing on 2026-10-06 from `Corp-CL01` as `CORP\jsmith` (Jhon Smith) confirmed IT read/write, Public read with write denied, and access denied to Finance, HR, and Sales, all as intended. The temporary IT test file was removed. This verifies the AGDLP/NTFS model end-to-end for this user; other users were not tested in these latest checks.

## Follow-up permission review

The group-scope correction and nesting verification were completed during the live work on 2026-09-16. Remaining work is to review complete ACLs, inheritance, and access behavior for other users beyond the verified entries and latest Jhon tests. This documentation update changes no groups or permissions.

## To verify

- Complete NTFS and share ACL entries and inheritance beyond the five verified resource-group entries and all five `Everyone: Full` share permissions
- Current file-access behavior for users beyond the latest tested `CORP\jsmith` results
- Whether any permissions are assigned directly to users

## Related documentation

- [OU, User, and Group Inventory](users-and-groups.md)
- [Corp-FS01 File Server](../03-Virtual-Infrastructure/file-server.md)
- [Finance onboarding](../05-Client-Management/onboarding.md)
- [Known issues](../09-Documentation/known-issues.md)
