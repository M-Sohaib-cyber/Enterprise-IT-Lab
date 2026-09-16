# Corp-FS01 File Server

## Purpose and status

`Corp-FS01` provides SMB file shares used by domain users. Departmental and public shares, access tests, and Group Policy drive mappings are documented as implemented.

Live verification on 2026-09-16 confirmed Windows Server 2022 Standard Evaluation, build 20348, domain `corp.internal`, static IPv4 `10.10.20.20/24`, gateway `10.10.20.1`, and DNS `10.10.20.10`. VirtualBox specification and exact network attachment remain **To verify**.

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

The share names Finance, HR, IT, Public, and Sales were confirmed live on 2026-09-16. Recorded folder paths and uses are:

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

Live verification on 2026-09-16 confirmed Finance NTFS grants `DL_Finance_RW` Modify and IT NTFS grants `DL_IT_RW` Modify. IT share-level permissions currently include `Everyone` Full Control; NTFS provides the restrictive permission layer. The earlier broad share-permission record above is not a live confirmation of every share ACL.

All `DL_*` security groups were corrected from Global through Universal to Domain Local, and all six resource-group memberships were verified; see [Users and Groups](../04-Active-Directory/users-and-groups.md). Complete ACLs and inheritance remain to verify.

## Drive mappings

The existing `GPO - Drive Mappings` record documents:

| Drive | UNC path | Documented targeting/access |
|---|---|---|
| `I:` | `\\Corp-FS01\IT` | Item-level targeting `CORP\GG_IT`, corrected during live verification; Modify in recorded test |
| `P:` | `\\Corp-FS01\Public` | Public access; read-only in recorded test |
| `F:` | `\\Corp-FS01\Finance` | Existing item-level targeting `CORP\GG_Finance` |

Detailed GPO configuration remains in [Group Policy](../04-Active-Directory/group-policy.md).

## Documented testing

Repository documentation records the following tests on `Corp-CL01`:

- `CORP\jsmith` received `I:` and `P:` after Group Policy refresh/sign-in.
- A test file could be created and deleted on `I:`.
- Creating a file on `P:` was denied.
- Finance user `CORP\sahmed` received `F:` and could create and delete a file there.
- The Finance user could access `P:` and was denied access to `I:`.

During one test, mapped drives did not appear because `Corp-FS01` was powered off. The existing record says the drives appeared after the server was started and Group Policy was refreshed.

The access tests above are historical. On 2026-09-16, Jhon Smith (`jsmith`) successfully received `I:` and `P:` after `gpupdate`; `F:` was correctly absent. The wallpaper file `\\Corp-FS01\Public\company-wallpaper.jpg` was successfully opened from `Corp-CL01`.

## To verify

- Windows Server patch and activation state
- Exact VirtualBox network attachment
- VM CPU, memory, and disk configuration
- Share properties beyond the confirmed share names and IT share permission
- Complete NTFS and share ACLs and inheritance beyond the verified Finance/IT entries
- Storage capacity, free space, quotas, shadow copies, backup, and recovery
- Current Finance-user mapping and file-access tests; current IT create/delete and Public read-only behavior

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
