# Group Policy Operation and Verification

## Scope

Group Policy is used to configure users and computers in `corp.internal`. The authoritative list of documented GPOs, links, major settings, concerns, and evidence is maintained in the [Group Policy Inventory](gpo-inventory.md).

This document records how the existing GPO exercises were applied and checked. It includes the supplied live verification results from 2026-09-16 below; it is not a complete GPO backup.

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

## Live verification - 2026-09-16

Live verification on 2026-09-16 used `gpresult` on `Corp-CL01` and for Jhon Smith (`CORP\jsmith`).

| Scope | Confirmed applied GPOs |
|---|---|
| Computer (`Corp-CL01`) | `GPO - Workstation Security`; `GPO - Removable Storage Restrictions`; `GPO - Local Administrators`; `GPO - Windows Update Policy`; `Default Domain Policy` |
| User (Jhon) | `GPO - Drive Mappings`; `GPO - Company Desktop`; `GPO - User Restrictions` |

- Workstation Security inactivity limit: 600 seconds (10 minutes). `Corp-CL01` registry value `InactivityTimeoutSecs = 0x258` confirmed the applied value.
- Removable Storage Restrictions: `All Removable Storage classes: Deny all access` enabled.
- Windows Update: Configure Automatic Updates mode 3, Auto download and notify for install.
- Company Desktop wallpaper: `\\Corp-FS01\Public\company-wallpaper.jpg`; the file successfully opened from `Corp-CL01`.
- User Restrictions: Control Panel/PC Settings blocked; practically tested successfully on `Corp-CL01`.
- Local Administrators: `GG_IT` intentionally receives workstation local Administrators membership through `GPO - Local Administrators`. Jhon is confirmed in `Domain Users` and `GG_IT`, so he receives local administrator rights on `Corp-CL01`.

| Drive | Configured path | Verified targeting/result |
|---|---|---|
| `I:` | `\\Corp-FS01\IT` | Corrected during verification to item-level targeting for `CORP\GG_IT`; mapped for Jhon after `gpupdate` |
| `P:` | `\\Corp-FS01\Public` | Mapped for Jhon after `gpupdate`; targeting details beyond this result remain to verify |
| `F:` | `\\Corp-FS01\Finance` | Already targets `CORP\GG_Finance`; correctly absent for Jhon |

These are the supplied live-check results. This documentation update changes no GPO or lab configuration.

## Known security concern

`GPO - Local Administrators` currently assigns `CORP\GG_IT` to the local `Administrators` group on affected workstations. The repository documents `CORP\jsmith` receiving local administrator privileges through this path.

This assignment is intentional for IT users; its breadth remains a later least-privilege review item. No GPO, group, or membership is changed by this documentation.

## Troubleshooting preserved from testing

- Mapped drives initially failed to appear while `Corp-FS01` was powered off; they appeared after the server was started and Group Policy was refreshed.
- The company wallpaper required sign-out and sign-in after policy refresh.
- New group membership may require a new logon session before it appears in the user's security token.

## To verify

- GPO settings beyond those verified, enabled state, versions, links, and link order
- Security filtering, delegation, WMI filters, inheritance, and enforcement
- Drive-mapping preference details beyond confirmed paths and I:/F: targeting
- Resultant set of policy for other users/computers and detailed settings beyond the verified results
- Cause of the five-minute observed lock behavior

## Related documentation

- [Group Policy Inventory](gpo-inventory.md)
- [OU, User, and Group Inventory](users-and-groups.md)
- [Group-Based File Permissions](agdlp-and-permissions.md)
- [Corp-FS01 File Server](../03-Virtual-Infrastructure/file-server.md)
- [Account Recovery](../06-Helpdesk/account-recovery.md)
- [Known Issues](../09-Documentation/known-issues.md)
