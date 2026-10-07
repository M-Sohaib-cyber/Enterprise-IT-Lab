# Lessons Learned

## Security-token refresh

When a user was added to a security group, access initially remained denied because the existing logon session still used the previous security token. Signing out and signing back in refreshed the token.

The documented verification command was:

```cmd
whoami /groups
```

This behavior is relevant when testing new group membership and file access.

## Share and NTFS permissions

The file-server exercise used broad share permissions with NTFS permissions intended to control effective access. Testing both the share and NTFS result is important because effective access depends on their combination.

Live verification on 2026-09-16 confirmed Finance/IT NTFS Modify entries and IT share `Everyone` Full, with NTFS providing the restrictive layer. Latest supplied verification on 2026-10-06 confirmed all five resource-group NTFS entries and intentional `Everyone: Full` on all five shares. Jhon tested IT read/write, Public read with write denied, and Finance/HR/Sales denial, verifying the model end-to-end for this user. Complete ACLs and inheritance remain to verify. See [Corp-FS01 File Server](../03-Virtual-Infrastructure/file-server.md).

## Intended AGDLP model versus implementation

The lab intended to use Accounts -> Global groups -> Domain Local groups -> Permissions. The `DL_*` resource groups were later recorded as having been created with Global scope instead of Domain Local scope.

On 2026-09-16, all `DL_*` security groups were corrected from Global through Universal to Domain Local, all six resource-group memberships were verified, and Finance/IT NTFS Modify entries were confirmed. The original access tests alone did not establish scope/nesting; the live checks now confirm those parts of the intended model. Complete ACL review remains open.

See [Group-Based File Permissions](../04-Active-Directory/agdlp-and-permissions.md) and [Known Issues](known-issues.md).

## Backup completion and recovery evidence

The earlier 2026-10-06 no-backup gap was superseded by Windows Server Backup installation, a dedicated 20 GB backup disk, successful command-line and GUI manual backups, and a real deleted-file restore. Restoring `C:\Shares\Public\recovery-test.txt` to its original location and verifying `Enterprise IT Lab - Backup Recovery Test` demonstrated backup -> deletion -> recovery -> data verification. Restore ACL permissions was enabled; a separate ACL comparison was not reported.

The disk was initially `B:` / `FS01-Backup`, then dedicated through the schedule wizard with its reformat/dedication warning intentionally accepted. Both manual versions remained visible to `wbadmin` afterward. Initial disk details should not be presented as its current drive letter or label.

Schedule creation does not prove automatic execution. On 2026-10-07, the daily schedule was temporarily changed from 23:00 to 10:00 specifically to verify automatic execution. Windows Server Backup automatically completed successfully at 10:00 without a manual trigger, then the intended daily 23:00 schedule was restored. `C:\Shares` and the dedicated backup disk remain the scope and target, and the earlier file-level restore test remains verified.

During the same day's verification, `Corp-FS01` was found using `Pacific Standard Time`, while `w32tm /query /source` confirmed `Corp-DC01.corp.internal` as its time source. The time zone was corrected to `GMT Standard Time` and Windows Time was resynchronised.

`wbadmin get status` showing no operation is normal; unsupported `wbadmin get policy` showing help is not a backup failure. `RegIdleBackup` is not the file-server backup solution. See [Corp-FS01 File Server](../03-Virtual-Infrastructure/file-server.md) for configuration and tested scope.

## Evidence-aware documentation

Build notes, screenshots, and later exercises can conflict as a lab evolves. Current-state documents should distinguish recorded history from live-verified configuration and use **To verify** rather than resolving conflicts by assumption.
