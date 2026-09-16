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

## Recorded implementation

Live verification on 2026-09-16 confirmed all `DL_*` security groups were corrected from Global to Domain Local using Universal as the intermediate scope (Global -> Universal -> Domain Local). The following nesting was verified; each resource group contains the listed member:

| Resource group | Verified member |
|---|---|
| `DL_Finance_RW` | `GG_Finance` |
| `DL_HelpDesk_RW` | `GG_HelpDesk` |
| `DL_HR_RW` | `GG_HR` |
| `DL_IT_RW` | `GG_IT` |
| `DL_Public_RO` | `Domain Users` |
| `DL_Sales_RW` | `GG_Sales` |

Finance NTFS grants `DL_Finance_RW` Modify, and IT NTFS grants `DL_IT_RW` Modify. These checked paths match the intended AGDLP model; complete ACLs and other resource permissions remain **To verify**.

## Documented access tests

The existing records describe:

- `CORP\jsmith`, a documented `GG_IT` member, receiving the IT and Public mapped drives.
- Successful create/delete testing on the IT drive.
- Create access denied on the Public drive.
- `CORP\sahmed` receiving the Finance drive during the onboarding exercise.
- Successful create/delete testing on the Finance drive and access denied to the IT drive for the Finance user.

These historical access tests are distinct from the live scope and nesting verification on 2026-09-16. During the live checks, Jhon received `I:` and `P:` after `gpupdate`, with `F:` correctly absent.

## Follow-up permission review

The group-scope correction and nesting verification were completed during the live work on 2026-09-16. Remaining work is to review complete ACLs, inheritance, and resource permissions beyond the Finance and IT Modify entries. This documentation update changes no groups or permissions.

## To verify

- Complete NTFS and share ACL entries and inheritance beyond verified Finance/IT Modify entries and IT `Everyone` Full share permission
- Current file-access behavior beyond the verified Jhon drive-mapping results
- Whether any permissions are assigned directly to users

## Related documentation

- [OU, User, and Group Inventory](users-and-groups.md)
- [Corp-FS01 File Server](../03-Virtual-Infrastructure/file-server.md)
- [Finance onboarding](../05-Client-Management/onboarding.md)
- [Known issues](../09-Documentation/known-issues.md)
