# Corp-FS01 File Server

## Purpose and status

`Corp-FS01` provides SMB file shares used by domain users. Departmental and public shares, access tests, and Group Policy drive mappings are documented as implemented.

Live verification on 2026-09-16 confirmed Windows Server 2022 Standard Evaluation, build 20348, domain `corp.internal`, static IPv4 `10.10.20.20/24`, gateway `10.10.20.1`, and DNS `10.10.20.10`. RAM (3075 MB), CPU (2 vCPU), and `Corp-Core` attachment were verified on 2026-10-06; see the [device inventory](../01-Enterprise-Planning/device-inventory.md#virtualbox-baseline---verified-2026-10-06).

## Build from zero

This initial build procedure implements the verified FS01 identity, network, domain membership, and File Server role. It adds instructions alongside the existing evidence; it does not claim a new live test. Complete [pfSense setup](pfsense.md#build-from-zero) and [DC01 promotion/verification](windows-server-build-guide.md#build-from-zero) first. Use reader-chosen passwords and authorized domain credentials; placeholders below are not literal account names or secrets.

### 1. Create the VM and install Windows Server

1. Use the [Batch 1 VM baseline](../01-Enterprise-Planning/device-inventory.md#fresh-build-vm-baseline): `Corp-FS01`, 3075 MB RAM, 2 vCPU, approximately 60 GB system VDI, and the separate 20 GB backup VDI. Exact live system VDI capacity and unrecorded firmware/display choices remain unverified; the approximate system-disk value is a rebuild target.
2. With the VM powered off, enable Adapter 1 as **NAT Network / Corp-Core**, check **Cable Connected**, and attach Windows Server 2022 installation media to the virtual optical drive. Complete the [NAT Network gateway checkpoint](../02-Network-Design/network-plan.md#nat-network-gateway-verification-checkpoint) before using pfSense's `.1` gateway.
3. Boot the media and install **Windows Server 2022 Standard Evaluation**, matching the recorded edition. The GUI procedure here uses **Desktop Experience** as a fresh-build choice; the exact original FS01 setup selection was not recorded. Language, keyboard, license/key prompts, and partition details are reader/media dependent. Use the [DC installation steps](windows-server-build-guide.md#1-create-the-vm-and-install-windows-server) as the setup reference while retaining FS01's own name and disk baseline.
4. Choose a Custom installation on the new system disk, identifying it by its capacity. Do not install Windows on or format the separate 20 GB backup disk at this stage. Complete setup with a reader-chosen `<local-Administrator-password>`, sign in locally, and remove installation media after setup finishes.

### 2. Rename and configure static networking

1. In **Server Manager > Local Server**, select the computer-name link, choose **Change**, enter `Corp-FS01`, and restart. Sign in as the local Administrator again.
2. Run `ncpa.cpl`, open the enabled `Corp-Core` adapter's **Properties > Internet Protocol Version 4 (TCP/IPv4) > Properties**, and select manual IP and DNS settings.
3. Enter the values below, confirm the dialogs, and run `hostname` and `ipconfig /all` in Command Prompt to check them. The adapter's display name is a reader/environment value, not an assumed Ethernet label.

| Setting | Required/verified value |
|---|---|
| IPv4 address | `10.10.20.20` |
| Subnet mask / prefix | `255.255.255.0` / `/24` |
| Default gateway | `10.10.20.1` |
| Preferred DNS | `10.10.20.10` |
| Alternate DNS | No alternate value established; this procedure leaves it blank |

### 3. Verify DC discovery and join the domain

Before joining, run these checks in Command Prompt on FS01 while DC01 is running:

```cmd
nslookup corp.internal 10.10.20.10
nslookup Corp-DC01.corp.internal 10.10.20.10
nslookup -type=SRV _ldap._tcp.dc._msdcs.corp.internal 10.10.20.10
```

The first two names should resolve to `10.10.20.10`; the SRV lookup should identify the DC for the domain. A displayed DNS-server name of Unknown before reverse DNS is configured does not invalidate a correct answer. `ping 10.10.20.10` is a useful same-server-network diagnostic where ICMP is permitted, but it does not verify domain discovery or replace DNS checks. Do not proceed after unresolved DNS/DC discovery errors.

1. Run `sysdm.cpl`, open **Computer Name > Change**, select **Domain**, and enter `corp.internal`.
2. When prompted, use `CORP\<authorized-domain-join-account>` and that reader-supplied account's password. The original FS01 join account was not recorded; no particular join credentials are assumed.
3. Wait for the domain welcome/confirmation, close the dialogs, and restart. Sign in using an authorized domain account, or retain local administration with `.\Administrator` as needed for role installation. Computer domain membership and the signed-in user's identity are separate checks.
4. On DC01, open **Server Manager > Tools > Active Directory Users and Computers**. Locate the new `CORP-FS01` computer object; it may initially be in **Computers**. Once the documented top-level `Servers` OU exists, right-click the computer, choose **Move**, and select `Servers`. If the OU has not yet been created, complete the [AD structure stage](../04-Active-Directory/active-directory-installation.md#verified-ou-structure---2026-10-06) before moving it. Domain join can precede that stage; the final documented placement is `Servers`.

Microsoft's [domain-join reference](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/join-computer-to-domain) explains the join controls. Creating detailed directory objects and policies remains outside this initial server procedure.

### 4. Install the File Server role

Open PowerShell as an administrator on FS01 and run:

```powershell
Install-WindowsFeature -Name FS-FileServer -IncludeManagementTools
Get-WindowsFeature -Name FS-FileServer
```

Check the installation result for `Success = True` and the feature for `InstallState = Installed`. Follow any reported restart requirement before continuing. The File and Storage Services parent/dependency features are handled by the role installation. Microsoft's [Install-WindowsFeature reference](https://learn.microsoft.com/en-us/powershell/module/servermanager/install-windowsfeature?view=windowsserver2022-ps) describes this command; it is a fresh-build method for the recorded role, not a claim that this exact command was used historically.

Windows Server Backup installation/configuration is a later stage; this procedure does not install or configure it, create shares, or change NTFS permissions.

### 5. Build checkpoints and handoff

Run the PowerShell checks locally on FS01 after its restart. Review the computer object on DC01 when the OU stage is complete.

| Check | Expected result |
|---|---|
| `hostname`; `ipconfig /all` | `Corp-FS01`; static `10.10.20.20/24`, gateway `10.10.20.1`, preferred DNS `10.10.20.10` |
| `Get-CimInstance Win32_ComputerSystem \| Select-Object Name,Domain,PartOfDomain` | `Corp-FS01`, `corp.internal`, `True` |
| `nltest /dsgetdc:corp.internal` | DC discovery identifies `Corp-DC01` |
| `Get-WindowsFeature FS-FileServer` | File Server Installed |
| ADUC computer-object location | Enabled `CORP-FS01` in `Servers` after the OU/move stage |

Proceed to [users/groups and AGDLP](../04-Active-Directory/users-and-groups.md) once the initial network/domain/role checks pass. Later stages use the [recorded share paths](#verified-storage-layout---2026-10-06), [permissions record](#recorded-permissions), and [backup/recovery record](#backup-and-recovery---implemented-2026-10-06-automatic-execution-verified-2026-10-07). SMB access testing from CL01 belongs after shares and permissions exist; successful role installation alone does not prove share access. Under the final OPT1 rules, CL01 ping to FS01 is intentionally blocked and is not an FS01 build-failure criterion.

Unknown historical details remain explicit: exact system VDI capacity/allocation, firmware/display and installer choices, local password/product key, alternate DNS, original domain-join account, and Windows partition layout. Later ACL, backup, and patch limitations remain in their existing sections below.

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

## Backup and recovery - implemented 2026-10-06; automatic execution verified 2026-10-07

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

### Daily schedule - automatic execution verified 2026-10-07

The Backup Schedule Wizard confirmed schedule creation. Configuration and latest execution verification are recorded below:

| Setting | Verified configuration |
|---|---|
| Backup type | Custom |
| Backup items | `C:\Shares` |
| Frequency/time | Once daily at 23:00 |
| Destination | Dedicated 20 GB backup disk |
| Files excluded | None |
| Advanced option shown during configuration | VSS Copy Backup |
| Verified automatic backup | 07/10/2026 at 10:00 during temporary schedule testing |

On 2026-10-07, the schedule was temporarily changed from 23:00 to 10:00 specifically to verify automatic scheduled execution. Windows Server Backup automatically completed successfully at 10:00 without a manual trigger. After successful verification, the daily schedule was restored to the intended 23:00 time. The backup scope and target remain unchanged: `C:\Shares` to the dedicated backup disk. The previously completed file-level restore test remains verified.

### Time zone and Windows Time - corrected 2026-10-07

`Corp-FS01` was found configured with the Windows time zone `Pacific Standard Time`. `w32tm /query /source` confirmed its time source was `Corp-DC01.corp.internal`. The time zone was corrected to `GMT Standard Time` and Windows Time was resynchronised.

### Additional verification and scope

`wbadmin get status` reported no backup or recovery operation currently running, which is normal between operations. `wbadmin get policy` was attempted, but this version did not support that command and displayed supported-command help instead; this is not a backup failure.

The earlier no-backup gap is superseded by successful local manual backups, the tested file restore, and automatic scheduled execution verified on 2026-10-07. These findings do not establish offsite/cloud backup, replication, encryption, retention guarantees, or disaster recovery.

## Patch and post-update verification - 2026-10-06

`Corp-FS01` was previously at a March 2022 patch baseline and updated successfully on 2026-10-06. It now shows `KB5122881`, `KB5122882`, and `KB5126050`. Finance, HR, IT, Public, and Sales SMB shares remained present at the expected `C:\Shares` paths listed above. Existing Windows Server Backup versions remained recognised and recoverable; automatic scheduled execution was subsequently verified on 2026-10-07 as described above.

The update proceeded considerably more smoothly than on `Corp-DC01`. Guest Additions, successful bidirectional clipboard testing, and the new powered-off snapshot are recorded in the [environment](../00-Project-Overview/environment.md#virtual-storage-and-snapshots---verified-2026-10-06). Defender observations are maintained in [security hardening](../08-Security/security-hardening.md#defender-observations---2026-10-06).

## To verify

- Windows Server activation and patch state beyond the installed KBs verified above
- System-disk capacity/allocation and uninspected VM settings beyond the verified CPU, memory, attachment, backup disk, and VDI/snapshot baseline
- Share properties beyond the confirmed names, paths, and `Everyone: Full` permissions
- Complete NTFS and share ACLs and inheritance beyond the verified entries above
- Quotas and drive redundancy
- Recovery beyond the tested file, including practical volume recovery
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
