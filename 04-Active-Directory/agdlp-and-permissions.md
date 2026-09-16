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

Examples documented in the original design include `GG_IT` to `DL_IT_RW` and `GG_Finance` to `DL_Finance_RW`. This remains the intended model, not a verified statement of current group scope or nesting.

## Recorded implementation

The repository records that:

- Departmental `GG_*` groups were created as Global Security groups.
- Resource groups with `DL_*` names were created.
- The `DL_*` groups were accidentally created as Global Security groups rather than Domain Local Security groups.
- The `DL_*` groups were recorded as being assigned directly to NTFS permissions in the single-domain lab.
- Departmental and public share access was tested from `Corp-CL01`.

Because the resource-group scopes are wrong for the intended model, the lab does **not** currently demonstrate a fully or correctly implemented AGDLP structure.

Existing documents conflict over whether `GG_*` groups were nested into `DL_*` groups. Current group nesting and ACL entries are therefore **To verify**.

## Documented access tests

The existing records describe:

- `CORP\jsmith`, a documented `GG_IT` member, receiving the IT and Public mapped drives.
- Successful create/delete testing on the IT drive.
- Create access denied on the Public drive.
- `CORP\sahmed` receiving the Finance drive during the onboarding exercise.
- Successful create/delete testing on the Finance drive and access denied to the IT drive for the Finance user.

These results demonstrate tested access behavior. They do not prove that the intended AGDLP nesting and group scopes were implemented correctly.

## Practical issue requiring later remediation

Live work is required to verify group scope, nesting, and NTFS ACLs and then decide how to correct the `DL_*` groups. No group, membership, or file permission is changed by this documentation.

## To verify

- Current category and scope of every `DL_*` group
- Current `GG_*` to `DL_*` nesting
- Exact current NTFS and share ACL entries
- Whether documented access behavior still matches the current server
- Whether any permissions are assigned directly to users

## Related documentation

- [OU, User, and Group Inventory](users-and-groups.md)
- [Corp-FS01 File Server](../03-Virtual-Infrastructure/file-server.md)
- [Finance onboarding](../05-Client-Management/onboarding.md)
- [Known issues](../09-Documentation/known-issues.md)
