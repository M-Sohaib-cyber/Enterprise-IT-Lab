# Screenshot Evidence Index

This index describes what the existing screenshots visibly demonstrate. A screenshot supports only the claim stated here; it is not a complete configuration export or proof that a setting remains current.

## Active Directory and Group Policy

| Screenshot | What is visible | Claim supported | Related documentation |
|---|---|---|---|
| [01-Groups.png](Active%20Directory/01-Groups.png) | ADUC `Groups` OU with named `GG_*` and `DL_*` groups; `DL_Sales_RW` members includes `GG_Sales` | Group objects existed and one nesting example was displayed; group scope is not visible | [Directory inventory](../04-Active-Directory/users-and-groups.md) |
| [02-New user password setup.png](Active%20Directory/02-New%20user%20password%20setup.png) | New-user wizard in `corp.internal/Company Users` with must-change-password selected | The account-creation option and target OU were demonstrated; user identity is not visible | [Onboarding](../05-Client-Management/onboarding.md) |
| [03-Adding user to group.png](Active%20Directory/03-Adding%20user%20to%20group.png) | John Smith group-selection dialog with `GG_IT` entered | `GG_IT` was selected for John Smith; this dialog alone does not prove the saved membership | [Directory inventory](../04-Active-Directory/users-and-groups.md) |
| [04-Workstation-Security-GPO.png](Active%20Directory/04-Workstation-Security-GPO.png) | GPMC security-options view for the workstation policy | Machine-inactivity policy configuration was worked on; application is supported by the written verification record | [GPO inventory](../04-Active-Directory/gpo-inventory.md) |
| [05-User-Restrictions-GPO.png](Active%20Directory/05-User-Restrictions-GPO.png) | User Restrictions GPO editor and an administrator-restriction dialog on the client | Control Panel/PC settings restriction produced a blocked-operation result | [GPO inventory](../04-Active-Directory/gpo-inventory.md) |
| [06-Password-Policy.png](Active%20Directory/06-Password-Policy.png) | Default Domain Policy password settings | Recorded history, ages, length, and complexity values | [GPO inventory](../04-Active-Directory/gpo-inventory.md) |
| [07-Account-Lockout-Policy.png](Active%20Directory/07-Account-Lockout-Policy.png) | Default Domain Policy lockout settings | Recorded threshold, duration, and reset-counter values | [GPO inventory](../04-Active-Directory/gpo-inventory.md) |
| [08-Account-Locked.png](Active%20Directory/08-Account-Locked.png) | John Smith sign-in rejected because the account is locked | Account-lockout behavior was demonstrated | [GPO inventory](../04-Active-Directory/gpo-inventory.md) |
| [09-Removable-Storage-Access-Denied.png](Active%20Directory/09-Removable-Storage-Access-Denied.png) | Removable Disk `E:` present with an access-denied message | Removable-storage access was denied on the client | [GPO inventory](../04-Active-Directory/gpo-inventory.md) |
| [10-Disabled-Account-Login-Denied.png](Active%20Directory/10-Disabled-Account-Login-Denied.png) | Sign-in rejected because the account is disabled | Disabled-account login denial was demonstrated; user identity is not visible | [Offboarding](../05-Client-Management/offboarding.md) |
| [11-Account-Locked-Out.png](Active%20Directory/11-Account-Locked-Out.png) | John Smith locked-out sign-in message | Starting condition for the recovery exercise | [Account recovery](../06-Helpdesk/account-recovery.md) |
| [12-Password-Reset-And-Unlocked.png](Active%20Directory/12-Password-Reset-And-Unlocked.png) | John Smith reset-password dialog, must-change option, and unlocked status | Manual password reset and unlocked state were demonstrated | [Account recovery](../06-Helpdesk/account-recovery.md) |
| [13-Password-Change-Required.png](Active%20Directory/13-Password-Change-Required.png) | John Smith required to change password before sign-in | Forced password change was demonstrated | [Account recovery](../06-Helpdesk/account-recovery.md) |
| [14-GG_IT-Local-Administrators.png](Active%20Directory/14-GG_IT-Local-Administrators.png) | `Get-LocalGroupMember` output containing `CORP\GG_IT` | `GG_IT` appeared in the workstation local Administrators membership | [GPO inventory](../04-Active-Directory/gpo-inventory.md) |
| [15-John-Smith-Local-Administrator.png](Active%20Directory/15-John-Smith-Local-Administrator.png) | `whoami /groups` output containing local Administrators and `CORP\GG_IT` | John Smith's token included the documented admin access chain | [GPO inventory](../04-Active-Directory/gpo-inventory.md) |
| [16-Windows-Update-Policy-Verification.png](Active%20Directory/16-Windows-Update-Policy-Verification.png) | Registry query showing `AUOptions` as `0x3` | Windows Update option 3 was present in policy registry data | [GPO inventory](../04-Active-Directory/gpo-inventory.md) |
| [01-company-wallpaper-applied.png](Active%20Directory/Group-Policy/01-company-wallpaper-applied.png) | Company wallpaper visible on `Corp-CL01` | Wallpaper application was demonstrated; exact source filename is not proven | [GPO inventory](../04-Active-Directory/gpo-inventory.md) |

## Firewall and client networking

| Screenshot | What is visible | Claim supported | Related documentation |
|---|---|---|---|
| [01-pfSense-firewall rules.png](Security/01-pfSense-firewall%20rules.png) | OPT1 rule editor with IPv4, protocol Any, source Any, and description `Allow OPT1 to Any` | Historical permissive rule editor; live verification on 2026-09-16 confirmed the current IPv4 allow rule from OPT1 subnets to any; rule order remains to verify | [Firewall rules](../08-Security/firewall-rules.md) |
| [01-Corp-CL01 ipconfig.png](Verifications/01-Corp-CL01%20ipconfig.png) | `Corp-CL01` `ipconfig /all` output | Domain suffix `corp.internal`, DHCP client `10.10.30.100`, gateway/DHCP server `10.10.30.1`, and DNS `10.10.20.10` | [Windows client](../05-Client-Management/windows11-client.md) |

## Server and file-service evidence

| Screenshot | What is visible | Claim supported | Related documentation |
|---|---|---|---|
| [01-File Server setup.png](Servers/01-File%20Server%20setup.png) | Add Roles wizard for `Corp-FS01.corp.internal` with File Server selected | The File Server role was selected/installed in the recorded workflow | [File server](../03-Virtual-Infrastructure/file-server.md) |
| [02-Setting department and security.png](Servers/02-Setting%20department%20and%20security.png) | Advanced Security Settings for `C:\Shares\HR` | NTFS permissions were configured/reviewed for the HR folder; it does not prove all current ACLs | [File server](../03-Virtual-Infrastructure/file-server.md) |
| [03-Access Denied.png](Servers/03-Access%20Denied.png) | Access denied to `\\Corp-FS01\HR` | A user was denied HR share access | [File server](../03-Virtual-Infrastructure/file-server.md) |
| [04-File sharing setup.png](Servers/04-File%20sharing%20setup.png) | IT share permissions with `Everyone` Full Control | Recorded share-level permission for the IT share | [File server](../03-Virtual-Infrastructure/file-server.md) |
| [05-Windows server feature installation.png](Servers/05-Windows%20server%20feature%20installation.png) | Successful roles/features result on `Corp-DC01`, including AD DS and DNS | AD DS and DNS role installation completed in the recorded build | [DC build](../03-Virtual-Infrastructure/windows-server-build-guide.md) |
| [06-Windows server name change.png](Servers/06-Windows%20server%20name%20change.png) | Local Server page showing the generated pre-domain hostname and DHCP state | Pre-configuration Windows Server state only; it does not prove the final rename | [DC build](../03-Virtual-Infrastructure/windows-server-build-guide.md) |
| [07-Windows server internet protocol.png](Servers/07-Windows%20server%20internet%20protocol.png) | Exact duplicate of the preceding Local Server image | No independent IP evidence; final static addressing relies on the written record | [DC build](../03-Virtual-Infrastructure/windows-server-build-guide.md) |
| [windows server installed.png](Servers/windows%20server%20installed.png) | Windows Server dashboard with Shutdown Event Tracker | Windows Server reached an installed, running desktop state | [DC build](../03-Virtual-Infrastructure/windows-server-build-guide.md) |
| [01-Group Policy Managment.png](Servers/File%20Server/01-Group%20Policy%20Managment.png) | GPMC for `corp.internal` with the OU tree visible | Group Policy Management was opened for the domain; filename spelling is retained to avoid breaking links | [GPO inventory](../04-Active-Directory/gpo-inventory.md) |
| [02-Drive-Mapping-gpo.png](Servers/File%20Server/02-Drive-Mapping-gpo.png) | Drive Maps preference showing `I:` with Update action and `\\Corp-FS01\IT` path | IT drive-mapping configuration is visible | [GPO inventory](../04-Active-Directory/gpo-inventory.md) |
| [03-mapped-drives-testing.png](Servers/File%20Server/03-mapped-drives-testing.png) | `Corp-CL01` File Explorer showing IT `I:` and Public `P:` | The two mapped drives appeared on the client | [File server](../03-Virtual-Infrastructure/file-server.md) |

## Troubleshooting evidence

| Screenshot | What is visible | Claim supported | Related documentation |
|---|---|---|---|
| [01-whoami-groups.png](Troubleshooting/01-whoami-groups.png) | `whoami /groups` output including `CORP\GG_IT` and local Administrators | Group-token troubleshooting and the broad local-admin access path | [Directory inventory](../04-Active-Directory/users-and-groups.md) |

## Evidence limitations

- Screenshots are point-in-time records and do not establish current live state.
- Editor dialogs do not always prove that a change was saved or applied.
- Several screenshots support only part of a written workflow.
- The two Windows Server images numbered 06 and 07 are byte-for-byte duplicates with misleading filenames; they are retained in place to preserve repository history and existing references.
- No screenshot is treated as a substitute for a current configuration export or live verification.
