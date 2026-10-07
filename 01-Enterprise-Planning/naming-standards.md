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

- Jhon Smith: `jsmith`
- Mohammad Sohail: `msohail`
- Sarah Ahmed: `sahmed`

No broader naming rule is claimed from these examples. The verified current display name is **Jhon Smith**; some historical screenshots/filenames spell it **John Smith**. Both refer to the documented `jsmith` account; evidence filenames are retained unchanged.

## Groups

- Department groups use `GG_`, for example `GG_IT` and `GG_Finance`.
- Resource groups use a `DL_` prefix and access suffix, for example `DL_IT_RW` and `DL_Public_RO`.

The verified current configuration uses **Global Security** for the listed `GG_*` groups and **Domain Local Security** for all six listed `DL_*` resource groups. The original DL groups were mistakenly created as Global and corrected through Universal to Domain Local on 2026-09-16; scopes and nesting were reconfirmed on 2026-10-06. That mistake is a historical lesson, not the current required scope. See [Users and Groups](../04-Active-Directory/users-and-groups.md) and [Group-Based File Permissions](../04-Active-Directory/agdlp-and-permissions.md).

## Shares

Documented share names are `IT`, `HR`, `Finance`, `Sales`, and `Public`. See [Corp-FS01 File Server](../03-Virtual-Infrastructure/file-server.md).

The authoritative current device and directory-object lists are the [device inventory](device-inventory.md) and [OU, User, and Group Inventory](../04-Active-Directory/users-and-groups.md).
