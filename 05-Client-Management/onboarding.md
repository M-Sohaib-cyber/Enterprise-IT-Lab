# Finance User Onboarding Exercise

## Scope

This document records the onboarding exercise performed for Sarah Ahmed. It is a historical lab procedure, not an automated workflow or proof that every recommended production onboarding control exists.

## User record

| Item | Recorded value |
|---|---|
| Display name | Sarah Ahmed |
| Username | `sahmed` |
| Domain | `corp.internal` (`CORP`) |
| Initial OU | `Company Users` |
| Department | Finance |
| Department group | `GG_Finance` |
| Test client | `Corp-CL01` |

## Demonstrated steps

The existing exercise records that:

1. The `sahmed` account was created in `Company Users`.
2. A temporary password was assigned with **User must change password at next logon** enabled.
3. Sarah changed the temporary password during the first successful sign-in.
4. The account was added to `GG_Finance`.
5. The Finance drive mapping in `GPO - Drive Mappings` targeted `CORP\GG_Finance`.
6. Sarah signed in to `Corp-CL01` using `CORP\sahmed`.
7. Group Policy was refreshed and a new sign-in session was used before testing access.

No onboarding script, ticket, approval workflow, mailbox, application account, device allocation, or other automation is evidenced and none is claimed.

## Documented access results

| Test | Recorded result |
|---|---|
| Finance drive `F:` appeared | Successful |
| Create and delete a file on `F:` | Successful |
| Public drive `P:` access | Successful |
| IT drive `I:` access | Denied |

These results demonstrate historical access behavior. Separate live verification on 2026-09-16 confirmed all `DL_*` security groups corrected through Universal to Domain Local, including `GG_Finance` nested in `DL_Finance_RW`, and Finance NTFS granting `DL_Finance_RW` Modify. The current `F:` mapping is `\\Corp-FS01\Finance` with item-level targeting for `CORP\GG_Finance`; Sarah's current access was not retested. See [Group-Based File Permissions](../04-Active-Directory/agdlp-and-permissions.md).

## Later state

Sarah Ahmed was subsequently used for the documented [offboarding exercise](offboarding.md). The authoritative inventory therefore records the account's later documented state as disabled in `Disabled Users`, not as an active Finance user.

## Evidence

- [Generic new-user password option](../Screenshots/Active%20Directory/02-New%20user%20password%20setup.png) - this capture is not user-specific.

The repository does not contain a dedicated Sarah Ahmed screenshot for each onboarding, membership, or access-test step. The demonstrated workflow is preserved from the existing written record.

## To verify

- Exact account attributes at the time of onboarding
- Current `GG_Finance` user membership beyond the historical Sarah record
- Complete Finance NTFS/share ACLs and inheritance beyond verified `DL_Finance_RW` Modify
- Finance drive-mapping preference details beyond the confirmed path and `CORP\GG_Finance` target

## Related documentation

- [OU, User, and Group Inventory](../04-Active-Directory/users-and-groups.md)
- [Group Policy Inventory](../04-Active-Directory/gpo-inventory.md)
- [Corp-FS01 File Server](../03-Virtual-Infrastructure/file-server.md)
