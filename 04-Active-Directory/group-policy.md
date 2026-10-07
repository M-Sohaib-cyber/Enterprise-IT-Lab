# Group Policy Operation and Verification

## Scope

Group Policy is used to configure users and computers in `corp.internal`. The authoritative list of documented GPOs, links, major settings, concerns, and evidence is maintained in the [Group Policy Inventory](gpo-inventory.md).

This document records how the existing GPO exercises were applied and checked. It includes the supplied live verification results from 2026-09-16 below; it is not a complete GPO backup.

## Implement the recorded policies

Start after [OUs/users/groups](users-and-groups.md#implement-users-and-security-groups) and [share access checks](../03-Virtual-Infrastructure/file-server.md#implement-shares-and-resource-permissions). Keep DC01, FS01, and CL01 running for the relevant tests. These are fresh-build instructions for recorded settings, not a complete GPO export or claims of new verification.

### Create and link the custom GPOs

1. On DC01, open **Server Manager > Tools > Group Policy Management** (`gpmc.msc`), expand **Forest: corp.internal > Domains > corp.internal**, and locate the target OU.
2. Right-click that OU, choose **Create a GPO in this domain, and Link it here**, and enter the exact name from the table below. If the GPO exists, inspect it and use **Link an Existing GPO** only if its documented link is absent; do not create duplicate policies.
3. Right-click each GPO and choose **Edit**. Configure only the recorded settings in the following sections. The link locations below are recorded deployment targets; current link order and other metadata have not been fully exported.
4. Inspect **Scope**, **Delegation**, and link properties before testing. Security filtering, read/apply permissions, WMI filters, link order, enforcement, blocked inheritance, loopback, and enabled configuration halves remain **To verify**. A new GPO's defaults are not proof of the original settings. Do not add guessed groups/filters or change delegation to compensate for a failed test; inspect `gpresult` and verify the missing fields against the reference lab.

| Custom GPO | Recorded link | Configuration used | Purpose |
|---|---|---|---|
| `GPO - Workstation Security` | `Workstations` | Computer | Inactivity lock limit |
| `GPO - Local Administrators` | `Workstations` | Computer | IT group in workstation local Administrators |
| `GPO - User Restrictions` | `Company Users` | User | Restrict Control Panel/PC settings |
| `GPO - Drive Mappings` | `Company Users` | User preferences | Department/Public mapped drives |
| `GPO - Company Desktop` | `Company Users` | User | Company wallpaper |
| `GPO - Removable Storage Restrictions` | `Workstations` | Computer | Deny removable-storage access |
| `GPO - Windows Update Policy` | `Workstations` | Computer | Automatic update mode 3 |

Move CL01 to `Workstations` and keep Jhon in `Company Users` before application checks. FS01 remains in `Servers`; workstation GPO links are not instructions to apply those controls to the server or DC.

### Default Domain Policy and Default Domain Controllers Policy

Use the existing **Default Domain Policy**, linked at the domain root, rather than creating a namesake custom GPO. Edit **Computer Configuration > Policies > Windows Settings > Security Settings > Account Policies**:

| Subfolder / policy | Verified value |
|---|---|
| Password Policy / Enforce password history | 5 passwords |
| Password Policy / Maximum password age | 90 days |
| Password Policy / Minimum password age | 1 day |
| Password Policy / Minimum password length | 8 characters |
| Password Policy / Password must meet complexity requirements | Enabled |
| Account Lockout Policy / Account lockout threshold | 5 invalid attempts |
| Account Lockout Policy / Account lockout duration | 30 minutes |
| Account Lockout Policy / Reset account lockout counter after | 30 minutes |

Accept/review any interdependent lockout dialog and confirm all three final values. Other account-policy settings are not recorded; do not infer their values. On DC01, `Get-ADDefaultDomainPasswordPolicy` checks the resulting domain policy; compare its ages, history, complexity, and lockout values with the table. The existing five-failure test is historical; deliberately locking accounts is not required for this checkpoint.

**Default Domain Controllers Policy** is a promotion-created built-in policy to inspect in GPMC at the `Domain Controllers` OU. The repository does not establish its customized settings, current filtering/link metadata, or a tested resultant policy for DC01. Do not create a duplicate, apply workstation settings to it, or populate guessed user-rights/audit values. Preserve the newly promoted environment's policy and mark exact equivalence as **To verify**. This is a documentation gap, not a newly verified custom GPO.

### Workstation Security

Edit `GPO - Workstation Security`: **Computer Configuration > Policies > Windows Settings > Security Settings > Local Policies > Security Options > Interactive logon: Machine inactivity limit**. Define **600 seconds**. Verify application on CL01 using computer `gpresult` and:

```cmd
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v InactivityTimeoutSecs
```

Expected value: `0x258`. The historical workstation locked at about five minutes despite the recorded 600-second value; do not set another timeout or claim its cause was proven. Microsoft's [inactivity-policy reference](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/security-policy-settings/interactive-logon-machine-inactivity-limit) explains the setting's location and behavior.

### Local Administrators: verified intent, missing Restricted Groups fields

Edit `GPO - Local Administrators` at **Computer Configuration > Policies > Windows Settings > Security Settings > Restricted Groups**. The verified outcome is `CORP\GG_IT` membership in the workstation's local `Administrators`, not Domain Admins membership or server-local administration.

The repository does **not** establish the configured restricted-group identity, the complete **Members of this group** list, or the complete **This group is a member of** list. Do not guess whether the original entry restricted `Administrators` or made `CORP\GG_IT` a member of it. Inspect/export these fields from the reference GPO before adding the Restricted Groups entry; creation/linking can proceed, but exact membership configuration remains gated by that check. A screenshot of resultant local membership cannot establish these editor fields.

Once verified, enter the reference group identity and both membership lists exactly, apply, and check CL01 with elevated PowerShell:

```powershell
Get-LocalGroupMember -Group 'Administrators'
```

Expect `CORP\GG_IT`; after a fresh Jhon sign-in, `whoami /groups` should show the documented IT/local-administrator access chain. Microsoft's [Restricted Groups explanation](https://learn.microsoft.com/en-us/troubleshoot/windows-server/group-policy/description-of-group-policy-restricted-groups) distinguishes membership enforcement from membership addition. Incorrectly filling the Members list can remove existing local members; the unknown lists are not interchangeable fields. This intentional IT access remains the documented later least-privilege review item.

### User Restrictions

Edit `GPO - User Restrictions`: **User Configuration > Policies > Administrative Templates > Control Panel > Prohibit access to Control Panel and PC settings**. Set **Enabled**. Refresh user policy on CL01 as Jhon, sign out/in if required, then try opening Control Panel/PC settings; access should be blocked as in the historical test. Confirm the user GPO in `gpresult /r`. The [Microsoft policy reference](https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-admx-controlpanel#nocontrolpanel) identifies this setting; no additional restrictions are prescribed.

### Drive Mappings

Edit `GPO - Drive Mappings`: **User Configuration > Preferences > Windows Settings > Drive Maps**. Right-click **Drive Maps > New > Mapped Drive** for each recorded item (or edit an existing matching item).

| Drive letter | Location | Action established by evidence | Known item-level target |
|---|---|---|---|
| `I:` | `\\Corp-FS01\IT` | Update, visible in the historical configuration screenshot | `CORP\GG_IT` |
| `P:` | `\\Corp-FS01\Public` | To verify | Targeting details To verify |
| `F:` | `\\Corp-FS01\Finance` | To verify | `CORP\GG_Finance` |

For I:, select **Update**, enter the UNC Location, and set **Use** drive letter `I:`. Its action is supported by the [historical editor screenshot](../Screenshots/Servers/File%20Server/02-Drive-Mapping-gpo.png), not a current full preference export. For P:/F:, the required action must be verified before saving an exact-match item; do not infer Update/Replace/Create from I:.

For I: and F:, open **Common > Item-level targeting > Targeting**, add a **Security Group** condition, and resolve the respective verified CORP group. Membership targeting is the recorded intent; the exact user/computer selector, condition operators, additional conditions, and complete targeting tree remain **To verify**. P: appeared for Jhon, but that does not establish that it has no targeting. Verify these missing fields in the reference GPO instead of inferring a rule.

Reconnect, labels, hide/show options, alternate credentials, drive-item order, Common-tab options (including logged-on-user context, apply-once, and removal when no longer applied), and actions for P:/F: are not established. Do not supply stored credentials or guessed flags. Record them through live verification before claiming exact reproduction.

After the confirmed items are applied, Jhon should receive I:/P:, with F: absent; confirm UNC access and `net use` as well as `gpresult`. Finance mapping success for Sarah is historical and requires her enabled onboarding state; her final disabled account cannot perform that test. Item-level targeting is not an authorization boundary: NTFS must still deny unauthorized UNC access.

### Company Desktop and the missing image asset

The original `company-wallpaper.jpg` is **not included in this repository**. Before applying the policy, provide a suitable JPG yourself at `C:\Shares\Public\company-wallpaper.jpg` on FS01 so the target user can read `\\Corp-FS01\Public\company-wallpaper.jpg`. An authorized administrator must place the file because domain users have read-only Public access. Alternatively, supply your own accessible image and update the GPO path accordingly; that path is a documented rebuild variation, not the verified original asset.

Edit `GPO - Company Desktop`: **User Configuration > Policies > Administrative Templates > Desktop > Desktop > Desktop Wallpaper**. Enable the setting and enter `\\Corp-FS01\Public\company-wallpaper.jpg` (or your documented substitute). The original **Wallpaper Style** value and other desktop settings were not recorded: verify the style against the reference GPO, or explicitly record your own presentation choice as a difference. Do not claim an original style/image from the applied-wallpaper screenshot.

From the target user's CL01 session, open the UNC image first to confirm readability, run `gpupdate /force`, then sign out/in and check the wallpaper and user `gpresult`. The historical exercise required a new user session. Microsoft's [Desktop Wallpaper reference](https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-admx-desktop#wallpaper) documents the editor setting.

### Removable Storage Restrictions

Edit `GPO - Removable Storage Restrictions`: **Computer Configuration > Policies > Administrative Templates > System > Removable Storage Access > All Removable Storage classes: Deny all access**. Set **Enabled**. Confirm the computer GPO applies on CL01; if testing behavior, attach reader-provided disposable removable media visible to the guest and confirm access is denied. Device passthrough details and exception settings were not recorded. No formatting or writing to the media is required. See Microsoft's [removable-storage policy reference](https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-admx-removablestorage).

### Windows Update Policy

Edit `GPO - Windows Update Policy`: **Computer Configuration > Policies > Administrative Templates > Windows Components > Windows Update > Configure Automatic Updates**. With newer administrative templates it is under **Windows Update > Manage end user experience**; the historical template version/central-store configuration is unrecorded. Enable the setting and choose **3 - Auto download and notify for install**. Do not invent scheduled-install times, WSUS endpoints, restart deadlines, or other options.

Check computer `gpresult` and run on CL01:

```cmd
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions
```

Expect `0x3`, as recorded. This verifies the policy mode, not completed update installation. Microsoft's [automatic-update instructions](https://learn.microsoft.com/en-us/windows-server/administration/windows-server-update-services/deploy/4-configure-group-policy-settings-for-automatic-updates) describe the setting; this lab does not configure WSUS through this procedure.

### Configuration checkpoints and handoff

On CL01, sign in as Jhon after group changes, run `gpupdate /force`, and use `gpresult /r` for user application. In an elevated shell inspect `gpresult /r /scope computer` for computer application. Sign out/in for user-session settings and restart if computer policy requires it. Compare the applied list with the preserved live-results table below.

Verify the 600-second registry value, local Administrators membership, denied Control Panel/removable access, AUOptions 3, readable/applied wallpaper, I:/P: mappings, absent F:, and both allowed/denied UNC access. A successful `gpupdate` alone does not prove any of these outcomes. If a policy is denied or missing, inspect OU placement, filtering/read/apply permissions, and resultant policy instead of adding guessed settings. Default domain policy should also match `Get-ADDefaultDomainPasswordPolicy` on DC01.

Exact GPO equivalence remains open for the missing Restricted Groups/drive-map fields, wallpaper style, built-in DC policy settings, and GPO metadata/filtering. Once the supported enterprise checks pass, continue with the existing [helpdesk recovery exercises](../06-Helpdesk/account-recovery.md); those records and all historical verification/lessons below remain unchanged.

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
