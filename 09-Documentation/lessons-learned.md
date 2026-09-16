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

Live verification on 2026-09-16 confirmed Finance/IT NTFS Modify entries and IT share `Everyone` Full, with NTFS providing the restrictive layer. Complete ACLs and inheritance remain to verify. See [Corp-FS01 File Server](../03-Virtual-Infrastructure/file-server.md).

## Intended AGDLP model versus implementation

The lab intended to use Accounts -> Global groups -> Domain Local groups -> Permissions. The `DL_*` resource groups were later recorded as having been created with Global scope instead of Domain Local scope.

On 2026-09-16, all `DL_*` security groups were corrected from Global through Universal to Domain Local, all six resource-group memberships were verified, and Finance/IT NTFS Modify entries were confirmed. The original access tests alone did not establish scope/nesting; the live checks now confirm those parts of the intended model. Complete ACL review remains open.

See [Group-Based File Permissions](../04-Active-Directory/agdlp-and-permissions.md) and [Known Issues](known-issues.md).

## Evidence-aware documentation

Build notes, screenshots, and later exercises can conflict as a lab evolves. Current-state documents should distinguish recorded history from live-verified configuration and use **To verify** rather than resolving conflicts by assumption.
