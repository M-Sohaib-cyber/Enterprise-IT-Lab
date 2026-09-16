# Group Policy Inventory

## Scope

This inventory contains only GPOs supported by existing repository documentation or screenshots. It is not a live Group Policy export. Current version numbers, security filtering, delegation, WMI filters, enforcement, inheritance, and enabled state remain **To verify** unless stated otherwise.

- Domain: `corp.internal`
- Test client: `Corp-CL01`

## Implemented GPOs

| GPO | Recorded link/scope | Major recorded setting | Documented verification | Known concern or uncertainty |
|---|---|---|---|---|
| `GPO - Drive Mappings` | `Company Users` | Maps `I:` to `\\Corp-FS01\IT` and `P:` to `\\Corp-FS01\Public`; Finance `F:` mapping targets `CORP\GG_Finance` | Drives and access behavior tested with `jsmith` and `sahmed` | Current GPO settings and permission-group implementation To verify |
| `GPO - Company Desktop` | `Company Users` | Enables a desktop wallpaper from the `Corp-FS01` Public share | Wallpaper shown applied for `CORP\jsmith` | Exact current wallpaper filename/path To verify |
| `GPO - Workstation Security` | `Workstations` | Machine inactivity limit recorded as 600 seconds | `gpresult` and exported security policy recorded on `Corp-CL01` | Separate display/lock behavior occurred at about five minutes |
| `GPO - User Restrictions` | `Company Users` | Prohibits access to Control Panel and PC settings | Access-blocked test recorded for `CORP\jsmith` | Current filtering and complete settings To verify |
| `Default Domain Policy` | Domain-wide | Password and account-lockout settings listed below | Policy screenshots and five-failure lockout test recorded | Current live values To verify |
| `GPO - Removable Storage Restrictions` | `Workstations` | `All Removable Storage classes: Deny all access` enabled | USB access-denied test recorded on `Corp-CL01` | Current filtering and exceptions To verify |
| `GPO - Local Administrators` | `Workstations` | Restricted Groups adds `CORP\GG_IT` to local `Administrators` | Local membership and `jsmith` access chain recorded | Broad local-administrator assignment is a known security concern |
| `GPO - Windows Update Policy` | `Workstations` | Configure Automatic Updates option 3: auto-download and notify for install | `gpresult` and `AUOptions=0x3` recorded | Current Windows Update policy path/settings To verify |

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

`GPO - Local Administrators` grants workstation local Administrator membership to `CORP\GG_IT`. Existing evidence shows `CORP\jsmith` receiving local administrator privileges through this assignment. The configuration requires later practical review; no GPO or membership is changed by this documentation.

## To verify

- Current existence, enabled state, version, and link location of every listed GPO
- Link order, enforcement, blocked inheritance, loopback, and inheritance results
- Security filtering, delegation, WMI filters, and item-level targeting details
- Complete configured settings rather than the major settings recorded here
- Current `gpresult` output and resultant set of policy for each test account/computer
- Exact wallpaper path and current drive-mapping configuration
- Current Default Domain Policy values

## Related documentation

- [Group Policy operation and verification](group-policy.md)
- [OU, User, and Group Inventory](users-and-groups.md)
- [Corp-FS01 File Server](../03-Virtual-Infrastructure/file-server.md)
- [Known issues](../09-Documentation/known-issues.md)
