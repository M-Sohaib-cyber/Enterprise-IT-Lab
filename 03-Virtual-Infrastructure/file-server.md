# Corp-FS01 File Server

## Purpose and status

`Corp-FS01` provides SMB file shares used by domain users. Departmental and public shares, access tests, and Group Policy drive mappings are documented as implemented.

The server's operating system version, IP address, VirtualBox specification, and exact network attachment are **To verify**.

## Installed role

The existing server record documents these installed Windows Server roles/features:

- File and Storage Services
- File Server

No other `Corp-FS01` role is claimed.

## Recorded storage layout

The documented folder root is:

```text
C:\Shares
```

Recorded folders and SMB shares are:

| Folder | Share name | Documented use |
|---|---|---|
| `C:\Shares\IT` | `IT` | IT departmental files |
| `C:\Shares\HR` | `HR` | HR departmental files |
| `C:\Shares\Finance` | `Finance` | Finance departmental files |
| `C:\Shares\Sales` | `Sales` | Sales departmental files |
| `C:\Shares\Public` | `Public` | Shared read-only user resource in documented tests |

Physical/virtual disk layout, capacity, free space, volume name, drive redundancy, quotas, shadow copies, and backup configuration are **To verify**.

## Recorded permissions

The existing file-server record states:

- Share permission: `Everyone` - Full Control
- NTFS permissions used to restrict effective access
- `SYSTEM`, `Administrators`, `Domain Admins`, and `CREATOR OWNER` assigned Full Control on departmental folders
- Department `DL_*` groups intended to receive Modify access
- `DL_Public_RO` intended to receive Read and Execute access on `Public`

The `DL_*` groups are documented elsewhere as potentially having been created with Global scope instead of Domain Local scope. Their current scope and exact ACL entries require practical verification. This document therefore does not claim that AGDLP is correctly implemented.

## Drive mappings

The existing `GPO - Drive Mappings` record documents:

| Drive | UNC path | Documented targeting/access |
|---|---|---|
| `I:` | `\\Corp-FS01\IT` | IT access; Modify in recorded test |
| `P:` | `\\Corp-FS01\Public` | Public access; read-only in recorded test |
| `F:` | `\\Corp-FS01\Finance` | Finance users through item-level targeting |

Detailed GPO configuration remains in [Group Policy](../04-Active-Directory/group-policy.md).

## Documented testing

Repository documentation records the following tests on `Corp-CL01`:

- `CORP\jsmith` received `I:` and `P:` after Group Policy refresh/sign-in.
- A test file could be created and deleted on `I:`.
- Creating a file on `P:` was denied.
- Finance user `CORP\sahmed` received `F:` and could create and delete a file there.
- The Finance user could access `P:` and was denied access to `I:`.

During one test, mapped drives did not appear because `Corp-FS01` was powered off. The existing record says the drives appeared after the server was started and Group Policy was refreshed.

These statements preserve existing test records; they are not new tests performed during this documentation cleanup.

## To verify

- Windows Server edition, version, build, and patch state
- IP address, subnet, gateway, DNS, and VirtualBox network attachment
- VM CPU, memory, and disk configuration
- Current share list and share properties
- Exact NTFS and share ACLs, inheritance, and group scopes
- Storage capacity, free space, quotas, shadow copies, backup, and recovery
- Whether all documented mappings and tests still reflect current state

## Evidence

- [File Server setup](../Screenshots/Servers/01-File%20Server%20setup.png)
- [Department and security settings](../Screenshots/Servers/02-Setting%20department%20and%20security.png)
- [Access denied test](../Screenshots/Servers/03-Access%20Denied.png)
- [File sharing setup](../Screenshots/Servers/04-File%20sharing%20setup.png)
- [Group Policy Management](../Screenshots/Servers/File%20Server/01-Group%20Policy%20Managment.png)
- [Drive mapping GPO](../Screenshots/Servers/File%20Server/02-Drive-Mapping-gpo.png)
- [Mapped drive testing](../Screenshots/Servers/File%20Server/03-mapped-drives-testing.png)

## Related documentation

- [Device inventory](../01-Enterprise-Planning/device-inventory.md)
- [Group Policy](../04-Active-Directory/group-policy.md)
- [Users and groups](../04-Active-Directory/users-and-groups.md)
- [Windows 11 client](../05-Client-Management/windows11-client.md)
