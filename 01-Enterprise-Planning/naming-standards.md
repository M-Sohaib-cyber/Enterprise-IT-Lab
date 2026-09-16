# Naming Record

This document records naming patterns visible in the implemented lab. It does not reserve or claim devices, users, groups, or services that have not been created.

## Computers and firewall

| Name | Recorded role |
|---|---|
| `Corp-FW01` | pfSense firewall/router |
| `Corp-DC01` | Domain controller and DNS server |
| `Corp-FS01` | File server |
| `Corp-CL01` | Windows 11 client |

The implemented names use a `Corp-` prefix, role abbreviation, and two-digit instance number. Older `SRV-*`, `FW01`, and `PC-*` values were obsolete planning examples.

## Users

Documented usernames use an initial-plus-surname pattern:

- John Smith: `jsmith`
- Sarah Ahmed: `sahmed`

No broader naming rule is claimed from two examples.

## Groups

- Department groups use `GG_`, for example `GG_IT` and `GG_Finance`.
- Resource groups use a `DL_` prefix and access suffix, for example `DL_IT_RW` and `DL_Public_RO`.

The `DL_` prefix describes the intended naming pattern only. The groups were reportedly created with Global rather than Domain Local scope; see [Group-Based File Permissions](../04-Active-Directory/agdlp-and-permissions.md).

## Shares

Documented share names are `IT`, `HR`, `Finance`, `Sales`, and `Public`. See [Corp-FS01 File Server](../03-Virtual-Infrastructure/file-server.md).

The authoritative current device and directory-object lists are the [device inventory](device-inventory.md) and [OU, User, and Group Inventory](../04-Active-Directory/users-and-groups.md).
