# Group Policy Inventory

## Scope

This inventory includes repository records and supplied live verification results from 2026-09-16. It is not a live Group Policy export. Current version numbers, security filtering, delegation, WMI filters, enforcement, inheritance, and enabled state remain **To verify** unless stated otherwise.

- Domain: `corp.internal`
- Test client: `Corp-CL01`

## Implemented GPOs

| GPO | Recorded link/scope | Major recorded setting | Documented verification | Known concern or uncertainty |
|---|---|---|---|---|
| `GPO - Drive Mappings` | `Company Users` | Maps `I:` to `\\Corp-FS01\IT` targeting `CORP\GG_IT`, `P:` to `\\Corp-FS01\Public`, and `F:` to `\\Corp-FS01\Finance` targeting `CORP\GG_Finance` | Live: I: targeting corrected; Jhon received I:/P: after `gpupdate`, F: absent | Other preference details and complete ACLs To verify |
| `GPO - Company Desktop` | `Company Users` | Wallpaper `\\Corp-FS01\Public\company-wallpaper.jpg` | Live: GPO applies for Jhon; file opened from `Corp-CL01` | Other settings To verify |
| `GPO - Workstation Security` | `Workstations` | Machine inactivity limit verified as 600 seconds (10 minutes) | Live `gpresult`; `InactivityTimeoutSecs = 0x258` on `Corp-CL01` | Separate display/lock behavior occurred at about five minutes |
| `GPO - User Restrictions` | `Company Users` | Prohibits access to Control Panel and PC settings | Live: applies for Jhon; Control Panel/PC Settings block practically tested successfully | Current filtering and complete settings To verify |
| `Default Domain Policy` | Domain-wide | Password and account-lockout settings listed below | Policy screenshots and five-failure lockout test recorded | Current live values To verify |
| `GPO - Removable Storage Restrictions` | `Workstations` | `All Removable Storage classes: Deny all access` enabled | Live: enabled setting and computer GPO application confirmed; historical USB denial test | Current filtering and exceptions To verify |
| `GPO - Local Administrators` | `Workstations` | Restricted Groups adds `CORP\GG_IT` to local `Administrators` | Live: intentional `GG_IT` assignment confirmed; Jhon receives local admin rights | Broad local-administrator assignment is a known security concern |
| `GPO - Windows Update Policy` | `Workstations` | Configure Automatic Updates option 3: auto-download and notify for install | Live: computer GPO applies and mode 3 confirmed; historical `AUOptions=0x3` | Other Windows Update settings To verify |

## Live application results - 2026-09-16

`gpresult` on `Corp-CL01` confirmed these computer GPOs: `GPO - Workstation Security`, `GPO - Removable Storage Restrictions`, `GPO - Local Administrators`, `GPO - Windows Update Policy`, and `Default Domain Policy`.

For Jhon Smith (`jsmith`), `gpresult` confirmed these user GPOs: `GPO - Drive Mappings`, `GPO - Company Desktop`, and `GPO - User Restrictions`. See [Group Policy Operation and Verification](group-policy.md) for the checked settings and mapping results.

## Default Domain Policy settings recorded

| Setting | Recorded value |
|---|---|
| Minimum password length | 8 characters |
| Password complexity | Enabled |
| Password history | 5 passwords |
| Minimum password age | 1 day |
| Maximum password age | 90 days |
| Account lockout threshold | 5 invalid attempts |
| Account lockout duration | 30 minutes |
| Reset lockout counter | 30 minutes |

These are historical documented values, not a current policy export. The lockout behavior was tested with `CORP\jsmith`.

## Evidence by GPO

- `GPO - Drive Mappings`: [drive mapping configuration](../Screenshots/Servers/File%20Server/02-Drive-Mapping-gpo.png), [mapped-drive test](../Screenshots/Servers/File%20Server/03-mapped-drives-testing.png)
- `GPO - Company Desktop`: [wallpaper applied](../Screenshots/Active%20Directory/Group-Policy/01-company-wallpaper-applied.png)
- `GPO - Workstation Security`: [workstation security result](../Screenshots/Active%20Directory/04-Workstation-Security-GPO.png)
- `GPO - User Restrictions`: [Control Panel blocked](../Screenshots/Active%20Directory/05-User-Restrictions-GPO.png)
- `Default Domain Policy`: [password policy](../Screenshots/Active%20Directory/06-Password-Policy.png), [lockout policy](../Screenshots/Active%20Directory/07-Account-Lockout-Policy.png), [account locked](../Screenshots/Active%20Directory/08-Account-Locked.png)
- `GPO - Removable Storage Restrictions`: [removable storage denied](../Screenshots/Active%20Directory/09-Removable-Storage-Access-Denied.png)
- `GPO - Local Administrators`: [`GG_IT` local membership](../Screenshots/Active%20Directory/14-GG_IT-Local-Administrators.png), [`jsmith` local administrator verification](../Screenshots/Active%20Directory/15-John-Smith-Local-Administrator.png)
- `GPO - Windows Update Policy`: [Windows Update verification](../Screenshots/Active%20Directory/16-Windows-Update-Policy-Verification.png)

## Known security concern

`GPO - Local Administrators` grants workstation local Administrator membership to `CORP\GG_IT`. Existing evidence shows `CORP\jsmith` receiving local administrator privileges through this assignment. The assignment is intentional for IT users and remains a later least-privilege review item; no GPO or membership is changed by this documentation.

## To verify

- Enabled state, version, and link location of the listed GPOs beyond confirmed application
- Link order, enforcement, blocked inheritance, loopback, and inheritance results
- Security filtering, delegation, WMI filters, and item-level targeting details beyond verified I:/F: group targets
- Complete configured settings rather than the major settings recorded here
- Resultant set of policy for other accounts/computers and detailed settings beyond the verified results
- Drive-mapping preferences beyond confirmed paths and I:/F: targeting
- Current Default Domain Policy values

## Related documentation

- [Group Policy operation and verification](group-policy.md)
- [OU, User, and Group Inventory](users-and-groups.md)
- [Corp-FS01 File Server](../03-Virtual-Infrastructure/file-server.md)
- [Known issues](../09-Documentation/known-issues.md)
