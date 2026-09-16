# Group Policy Operation and Verification

## Scope

Group Policy is used to configure users and computers in `corp.internal`. The authoritative list of documented GPOs, links, major settings, concerns, and evidence is maintained in the [Group Policy Inventory](gpo-inventory.md).

This document records how the existing GPO exercises were applied and checked. It does not represent a current GPO backup or live resultant set of policy.

## Documented target structure

- User GPOs are recorded as linked to `Company Users`.
- Computer GPOs are recorded as linked to `Workstations`.
- Password and lockout settings are recorded in `Default Domain Policy` with domain-wide scope.
- `Corp-CL01` and `CORP\jsmith` were the main computer and user test targets.
- `CORP\sahmed` was used for Finance drive-mapping and access tests.

Current links, inheritance, filtering, and enabled state remain **To verify**.

## Documented policy refresh and reporting

The exercises used these commands where appropriate:

```cmd
gpupdate /force
gpresult /r
```

Some user settings required sign-out and sign-in before their effect appeared. Computer settings sometimes required a restart. These actions are recorded results from the existing exercises, not universal instructions for every policy.

Additional recorded checks included:

```cmd
secedit /export /cfg C:\security-policy.txt
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions
net user jsmith /domain
whoami /groups
```

PowerShell was used to inspect local Administrators membership:

```powershell
Get-LocalGroupMember -Group "Administrators"
```

## Documented test outcomes

The repository records successful tests for:

- IT, Public, and Finance drive mappings and their documented access behavior
- Company wallpaper application after a new user session
- A 600-second machine inactivity policy value in exported security policy
- Control Panel and PC settings restrictions
- Password-policy configuration and account lockout after five failed attempts
- Removable-storage access denial
- Addition of `CORP\GG_IT` to workstation local Administrators
- Windows Update `AUOptions` value `0x3`

The workstation locked at approximately five minutes during the inactivity exercise even though the exported policy recorded 600 seconds. The original record attributes the observed timing to another display, power, or lock setting; that cause remains **To verify**.

## Known security concern

`GPO - Local Administrators` currently assigns `CORP\GG_IT` to the local `Administrators` group on affected workstations. The repository documents `CORP\jsmith` receiving local administrator privileges through this path.

This broad assignment requires later practical review. No GPO, group, or membership is changed by this documentation.

## Troubleshooting preserved from testing

- Mapped drives initially failed to appear while `Corp-FS01` was powered off; they appeared after the server was started and Group Policy was refreshed.
- The company wallpaper required sign-out and sign-in after policy refresh.
- New group membership may require a new logon session before it appears in the user's security token.

## To verify

- Current GPO existence, settings, enabled state, versions, links, and link order
- Security filtering, delegation, WMI filters, inheritance, and enforcement
- Exact current wallpaper path and drive-mapping preferences
- Current resultant set of policy for `Corp-CL01` and documented users
- Cause of the five-minute observed lock behavior
- Whether the local-administrator assignment remains unchanged

## Related documentation

- [Group Policy Inventory](gpo-inventory.md)
- [OU, User, and Group Inventory](users-and-groups.md)
- [Group-Based File Permissions](agdlp-and-permissions.md)
- [Corp-FS01 File Server](../03-Virtual-Infrastructure/file-server.md)
- [Account Recovery](../06-Helpdesk/account-recovery.md)
- [Known Issues](../09-Documentation/known-issues.md)
