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

Current ACL entries and group scopes still require live verification. See [Corp-FS01 File Server](../03-Virtual-Infrastructure/file-server.md).

## Intended AGDLP model versus implementation

The lab intended to use Accounts -> Global groups -> Domain Local groups -> Permissions. The `DL_*` resource groups were later recorded as having been created with Global scope instead of Domain Local scope.

The single-domain access tests worked, but that does not make the implementation a correct AGDLP model. Current group scope, nesting, and ACLs must be verified before remediation.

See [Group-Based File Permissions](../04-Active-Directory/agdlp-and-permissions.md) and [Known Issues](known-issues.md).

## Evidence-aware documentation

Build notes, screenshots, and later exercises can conflict as a lab evolves. Current-state documents should distinguish recorded history from live-verified configuration and use **To verify** rather than resolving conflicts by assumption.
