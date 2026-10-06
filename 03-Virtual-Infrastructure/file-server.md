# Corp-FS01 File Server

## Purpose and status

`Corp-FS01` provides SMB file shares used by domain users. Departmental and public shares, access tests, and Group Policy drive mappings are documented as implemented.

Live verification on 2026-09-16 confirmed Windows Server 2022 Standard Evaluation, build 20348, domain `corp.internal`, static IPv4 `10.10.20.20/24`, gateway `10.10.20.1`, and DNS `10.10.20.10`. RAM (3075 MB), CPU (2 vCPU), and `Corp-Core` attachment were verified on 2026-10-06; see the [device inventory](../01-Enterprise-Planning/device-inventory.md#virtualbox-baseline---verified-2026-10-06).

## Installed role

The existing server record documents these installed Windows Server roles/features:

- File and Storage Services
- File Server
- Windows Server Backup (`Windows-Server-Backup`), installed during the supplied backup implementation on 2026-10-06; verified `InstallState = Installed`, with no restart required

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

Department shares are stored under `C:\Shares` on the system volume. There is currently no separate data volume for file-server data; the second disk described below is dedicated to backup. System-disk configuration, volume name, drive redundancy, and quotas remain **To verify**.

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

## Backup and recovery - implemented and verified 2026-10-06

### Earlier gap and subsequent implementation

Earlier checks on 2026-10-06 found Windows Server Backup `InstallState = Available` (not installed), no shadow copies from `vssadmin list shadows`, and no verified backup solution for `C:\Shares`. Built-in scheduled task `RegIdleBackup` existed but was not a file-server backup solution. These observations describe the state before the implementation below.

`Windows-Server-Backup` was subsequently installed successfully using `Install-WindowsFeature`. Verification showed `InstallState = Installed`; no restart was required.

### Dedicated backup disk

- A second VirtualBox virtual disk, `Corp-FS01-Backup.vdi`, was added to `Corp-FS01`: 20 GB virtual size, dynamically allocated VDI, attached using the SATA controller.
- Windows detected it as Disk 1, initially RAW. Disk 1 was initialized as GPT, partitioned, initially assigned `B:`, and formatted NTFS with the initial label `FS01-Backup`. Initial usable volume size was approximately 19.98 GB.
- The disk was later selected as a dedicated Windows Server Backup destination through the Backup Schedule Wizard. The warning that the disk would be reformatted/dedicated and normally no longer visible in File Explorer was accepted intentionally. `B:` and `FS01-Backup` describe its initial setup, not a verified current drive letter or label after dedication.

### Successful manual backups

A manual command-line backup of `C:\Shares` to the backup disk completed successfully using `wbadmin`. Windows created the required VSS shadow copy during the backup, and `wbadmin` reported successful completion. This supersedes the earlier pre-implementation observation of no shadow copies; it does not establish persistent user-accessible shadow copies.

Windows Server Backup **Backup Once** was also tested successfully through the GUI, using a Custom configuration with `C:\Shares` selected and the local backup disk as the destination.

### Deleted-file recovery test

1. Created `C:\Shares\Public\recovery-test.txt` with contents `Enterprise IT Lab - Backup Recovery Test`.
2. Created a new backup after the file existed, then deliberately deleted the file using GUI/File Explorer.
3. Used Windows Server Backup **Recover**, selecting the most recent backup containing the file, recovery type **Files and folders**, and `recovery-test.txt`.
4. Selected **Original location** as the recovery destination and enabled **Restore ACL permissions**.
5. Recovery completed successfully. The restored file was verified to exist and its contents were verified as `Enterprise IT Lab - Backup Recovery Test`.

This verifies an end-to-end backup -> deletion -> recovery -> data verification workflow for the tested file. Restore ACL permissions was enabled; no separate post-restore ACL comparison is claimed.

### Recoverable manual versions

`wbadmin get versions` showed both versions below associated with the backup disk and supporting file/volume recovery:

| Version timestamp (DD/MM/YYYY) | Verified recoverability reported |
|---|---|
| 06/10/2026 04:33 | File/volume recovery |
| 06/10/2026 04:43 | File/volume recovery |

Both manual versions remained visible to `wbadmin` after schedule configuration; disk dedication did not erase these versions in the observed results. Post-patch verification on 2026-10-06 reconfirmed both versions were recognised and recoverable. File recovery was practically tested as described above; volume recovery was reported as supported but was not practically tested.

### Daily schedule - CONFIGURED / PENDING FIRST AUTOMATIC EXECUTION

The Backup Schedule Wizard reported that the schedule was successfully created with:

| Setting | Verified configuration |
|---|---|
| Backup type | Custom |
| Backup items | `C:\Shares` |
| Frequency/time | Once daily at 23:00 |
| Destination | Dedicated 20 GB backup disk |
| Files excluded | None |
| Advanced option shown during configuration | VSS Copy Backup |
| First scheduled backup due | 06/10/2026 at 23:00 |

The first automatic scheduled backup has **not run yet** in the supplied verification. Schedule creation is verified; successful automatic execution at 23:00 remains pending.

### Additional verification and scope

`wbadmin get status` reported no backup or recovery operation currently running, which is normal between operations. `wbadmin get policy` was attempted, but this version did not support that command and displayed supported-command help instead; this is not a backup failure.

The earlier no-backup gap is superseded by successful local manual backups and the tested file restore. First scheduled-run verification remains open. These findings do not establish offsite/cloud backup, replication, encryption, retention guarantees, or disaster recovery.

## Patch and post-update verification - 2026-10-06

`Corp-FS01` was previously at a March 2022 patch baseline and updated successfully on 2026-10-06. It now shows `KB5122881`, `KB5122882`, and `KB5126050`. Finance, HR, IT, Public, and Sales SMB shares remained present at the expected `C:\Shares` paths listed above. Existing Windows Server Backup versions remained recognised and recoverable; first automatic scheduled execution remains pending.

The update proceeded considerably more smoothly than on `Corp-DC01`. Guest Additions, successful bidirectional clipboard testing, and the new powered-off snapshot are recorded in the [environment](../00-Project-Overview/environment.md#virtual-storage-and-snapshots---verified-2026-10-06). Defender observations are maintained in [security hardening](../08-Security/security-hardening.md#defender-observations---2026-10-06).

## To verify

- Windows Server activation and patch state beyond the installed KBs verified above
- System-disk capacity/allocation and uninspected VM settings beyond the verified CPU, memory, attachment, backup disk, and VDI/snapshot baseline
- Share properties beyond the confirmed names, paths, and `Everyone: Full` permissions
- Complete NTFS and share ACLs and inheritance beyond the verified entries above
- Quotas and drive redundancy
- First automatic scheduled backup execution; recovery beyond the tested file, including practical volume recovery
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
