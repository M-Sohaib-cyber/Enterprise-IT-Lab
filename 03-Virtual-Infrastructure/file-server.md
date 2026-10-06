# Corp-FS01 File Server

## Purpose and status

`Corp-FS01` provides SMB file shares used by domain users. Departmental and public shares, access tests, and Group Policy drive mappings are documented as implemented.

Live verification on 2026-09-16 confirmed Windows Server 2022 Standard Evaluation, build 20348, domain `corp.internal`, static IPv4 `10.10.20.20/24`, gateway `10.10.20.1`, and DNS `10.10.20.10`. VirtualBox specification and exact network attachment remain **To verify**.

## Installed role

The existing server record documents these installed Windows Server roles/features:

- File and Storage Services
- File Server

No other `Corp-FS01` role is claimed.

## Verified storage layout - 2026-10-06

The documented folder root is:

```text
C:\Shares
```

The share names Finance, HR, IT, Public, and Sales were confirmed live on 2026-09-16. Latest supplied verification confirmed all five SMB share paths:

| Folder | Share name | Documented use |
|---|---|---|
| `C:\Shares\IT` | `IT` | IT departmental files |
| `C:\Shares\HR` | `HR` | HR departmental files |
| `C:\Shares\Finance` | `Finance` | Finance departmental files |
| `C:\Shares\Sales` | `Sales` | Sales departmental files |
| `C:\Shares\Public` | `Public` | Shared read-only user resource in documented tests |

| Volume | File system | Size | Free space | HealthStatus | OperationalStatus |
|---|---|---|---|---|---|
| `C:` | NTFS | 60.32 GB | 49.2 GB | Healthy | OK |

Department shares are stored under `C:\Shares` on the system volume. There is currently no separate data volume for file-server data. Physical/virtual disk configuration, volume name, drive redundancy, and quotas remain **To verify**. Backup and shadow-copy findings are recorded below; healthy storage does not establish recoverability.

## Recorded permissions

The historical file-server record states:

- Share permission: `Everyone` - Full Control
- NTFS permissions used to restrict effective access
- `SYSTEM`, `Administrators`, `Domain Admins`, and `CREATOR OWNER` assigned Full Control on departmental folders
- Department `DL_*` groups intended to receive Modify access
- `DL_Public_RO` intended to receive Read and Execute access on `Public`

Live verification on 2026-09-16 confirmed Finance/IT NTFS Modify entries and IT share-level `Everyone` Full Control. Latest supplied verification on 2026-10-06 confirmed `Everyone: Full` on all five listed shares. This is intentional in the current design: NTFS permissions are the authorization layer.

| Folder/share | Verified NTFS resource group | Permission |
|---|---|---|
| Finance | `DL_Finance_RW` | Modify |
| HR | `DL_HR_RW` | Modify |
| IT | `DL_IT_RW` | Modify |
| Public | `DL_Public_RO` | Read & Execute |
| Sales | `DL_Sales_RW` | Modify |

`SYSTEM`, `BUILTIN\Administrators`, and `Domain Admins` retain appropriate administrative permissions. The latest findings do not establish every ACL entry, exact administrative rights, or inheritance details; the historical `CREATOR OWNER` entry above is not newly verified.

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

After OPT1 firewall hardening, `Corp-CL01` could not ping `Corp-FS01`, while SMB access over TCP 445 and Jhon's `I:` and `P:` mapped drives continued to work after Group Policy refresh. This verifies the required file-share path without demonstrating general client-to-server access.

## Practical access verification - 2026-10-06

Latest supplied testing from `Corp-CL01` as `CORP\jsmith` (Jhon Smith) confirmed:

| Share | Tested result |
|---|---|
| IT | Read/write succeeded |
| Public | Read succeeded; write denied as intended |
| Finance | Access denied as intended |
| HR | Access denied as intended |
| Sales | Access denied as intended |

The temporary IT test file was removed after testing. These results verify the AGDLP/NTFS permission model end-to-end for the tested user; they do not establish access behavior for other users or a current Finance-user test.

## Backup and recovery - identified gap

Latest supplied verification on 2026-10-06 found:

- Windows Server Backup feature `InstallState = Available`: it is not currently installed.
- `RegIdleBackup` exists as a built-in scheduled task; it is not a file-server backup solution.
- `vssadmin list shadows` returned no shadow copies.
- No backup solution for `C:\Shares` has currently been verified.

Backup/recovery remains an identified improvement/gap. Backup coverage and a successful file-data restore have not been verified; backup/recovery is not complete.

## To verify

- Windows Server patch and activation state
- Exact VirtualBox network attachment
- VM CPU, memory, and disk configuration
- Share properties beyond the confirmed names, paths, and `Everyone: Full` permissions
- Complete NTFS and share ACLs and inheritance beyond the verified entries above
- Quotas, drive redundancy, and backup/recovery coverage and restore testing
- Current Finance-user mapping and file-access tests; access behavior for users beyond `CORP\jsmith`

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
