# Group Policy

## Overview

Group Policy is used to centrally manage and configure users and computers in the `corp.internal` domain.

Group Policy Objects (GPOs) are linked to Organizational Units (OUs) to apply settings to specific users or computers.

---


# Automatic Network Drive Mapping

Network drives were deployed automatically using Group Policy Preferences.

### GPO Details

**GPO Name:** `GPO - Drive Mappings`

The GPO is linked to the `Company Users` Organizational Unit.

### Drive Mappings

| Drive | Location | Access |
|---|---|---|
| `I:` | `\\Corp-FS01\IT` | Modify |
| `P:` | `\\Corp-FS01\Public` | Read-only |

The drive mappings were configured under:

```text
User Configuration
└── Preferences
    └── Windows Settings
        └── Drive Maps
```

Both mappings use the **Update** action.

### Testing

Logged in as `CORP\jsmith`, the following tests were completed:

- `I:` automatically appeared in File Explorer.
- `P:` automatically appeared in File Explorer.
- A test file could be created and deleted in `I:` successfully.
- Creating a file in `P:` was denied, confirming read-only access.

### Verification Screenshot

![Mapped Drives on Corp-CL01](../Screenshots/Servers/File%20Server/03-mapped-drives-testing.png)

### Finance Drive Mapping

A department-specific Finance drive was added to the existing `GPO - Drive Mappings`.

| Setting | Value |
|---|---|
| Action | `Create` |
| Location | `\\Corp-FS01\Finance` |
| Drive Letter | `F:` |
| Label | `Finance` |

#### Item-Level Targeting

Item-level targeting was configured to ensure that only Finance users receive the Finance drive mapping.

**Target security group:**

```text
CORP\GG_Finance
```

The targeting configuration works as follows:

```text
User
  ↓
Member of GG_Finance
  ↓
Item-level targeting matches
  ↓
F: Finance drive is mapped
```

#### Testing

The mapping was tested using the Finance user:

```text
CORP\sahmed
```

After running:

```cmd
gpupdate /force
```

and signing back in, the following results were confirmed:

- `F: Finance` appeared automatically in File Explorer.
- The user successfully opened the Finance drive.
- The user created a file in the Finance drive.
- The user deleted the file successfully.
- Non-Finance users do not receive the Finance drive through Item-level targeting.

This confirmed that the Finance drive mapping and Item-level targeting were working correctly.

### Troubleshooting

During testing, the mapped drives did not initially appear because `Corp-FS01` was powered off.

After starting `Corp-FS01` and refreshing Group Policy, the `I:` and `P:` drives appeared successfully.

This confirmed that the Group Policy configuration was correct and the issue was caused by the file server being unavailable.

# GPO - Company Desktop

## Purpose

This GPO configures a standard company desktop wallpaper for users in the `Company Users` Organizational Unit.

## GPO Configuration

**GPO Name:** `GPO - Company Desktop`

**Linked to:** `Company Users`

### Policy Path

```text
User Configuration
└── Policies
    └── Administrative Templates
        └── Desktop
            └── Desktop
                └── Desktop Wallpaper
```

### Configuration

| Setting | Value |
|---|---|
| Policy | Desktop Wallpaper |
| State | Enabled |
| Wallpaper Path | `\\Corp-FS01\Public\company-wallpaper.jpg` |
| Wallpaper Style | Fill |

> Replace `company-wallpaper.jpg` above with the exact filename if your actual wallpaper has a different name or extension.

## Testing

The policy was tested on `Corp-CL01` using the `CORP\jsmith` account.

Group Policy was refreshed using:

```cmd
gpupdate /force
```

The wallpaper did not apply immediately, but applied successfully after signing out and signing back in.

This confirmed that the `GPO - Company Desktop` policy was successfully applied to the user.

### Verification Screenshot

![Company Wallpaper Applied](../Screenshots/Active%20Directory/Group-Policy/01-company-wallpaper-applied.png)


## GPO - Workstation Security

### Purpose

Configured a workstation security policy to automatically lock inactive computers.

### GPO Details

**GPO Name:** `GPO - Workstation Security`  
**Linked OU:** `Workstations`  
**Target Computer:** `Corp-CL01`

### Configuration

The policy was configured using the following path:

```text
Computer Configuration
└── Policies
    └── Windows Settings
        └── Security Settings
            └── Local Policies
                └── Security Options
```

Configured policy:

```text
Interactive logon: Machine inactivity limit
```

The policy setting was enabled and configured to:

```text
600 seconds (10 minutes)
```

### Applying the Policy

On `Corp-CL01`, Group Policy was refreshed using:

```cmd
gpupdate /force
```

The Group Policy update completed successfully.

### Verification

The policy was verified from an elevated Command Prompt using:

```cmd
gpresult /r
```

Under:

```text
COMPUTER SETTINGS
→ Applied Group Policy Objects
```

The following policies were applied:

```text
GPO - Workstation Security
Default Domain Policy
```

This confirmed that `GPO - Workstation Security` was successfully applied to `Corp-CL01`.

### Security Policy Verification

The local security policy was exported using:

```cmd
secedit /export /cfg C:\security-policy.txt
```

The exported policy contained:

```text
InactivityTimeoutSecs=4,600
```

This confirms that the machine inactivity policy value was applied with a timeout value of `600` seconds.

### Testing

During testing, the workstation required authentication after inactivity.

The display/lock behaviour occurred at approximately 5 minutes, which appears to be caused by a separate existing Windows display, power, or lock setting. Therefore, the 10-minute timeout was verified through the applied Group Policy results and exported security policy configuration rather than timing the lock behaviour alone.

### Verification Screenshot

![Workstation Security GPO Applied on Corp-CL01](../Screenshots/Active%20Directory/04-Workstation-Security-GPO.png)


## GPO - User Restrictions

### Purpose

Configured a user restriction policy to prevent standard domain users from accessing the Control Panel and Windows Settings.

### GPO Details

**GPO Name:** `GPO - User Restrictions`  
**Linked OU:** `Company Users`  
**Test User:** `CORP\jsmith`

### Configuration

The policy was configured using the following path:

```text
User Configuration
└── Policies
    └── Administrative Templates
        └── Control Panel
```

Configured policy:

```text
Prohibit access to Control Panel and PC settings
```

The policy was set to:

```text
Enabled
```

### Applying the Policy

On `Corp-CL01`, Group Policy was refreshed using:

```cmd
gpupdate /force
```

The user then signed out and signed back in to ensure the updated user policy was applied.

### Testing

After signing in as `CORP\jsmith`, attempts were made to access:

- Control Panel
- Windows Settings

Access was successfully blocked by Windows with a message indicating that the operation was restricted by the administrator.

This confirmed that `GPO - User Restrictions` was successfully applied to users in the `Company Users` OU.

### Verification Screenshot

![Control Panel Access Blocked](../Screenshots/Active%20Directory/05-User-Restrictions-GPO.png)


## Password and Account Lockout Policy

### Purpose

Configured domain password and account lockout policies through the Default Domain Policy to improve account security and protect against repeated failed sign-in attempts.

### GPO Details

**GPO Name:** `Default Domain Policy`  
**Scope:** Domain-wide  
**Test User:** `CORP\jsmith`

---

### Password Policy Configuration

The password policy was configured using:

```text
Computer Configuration
└── Policies
    └── Windows Settings
        └── Security Settings
            └── Account Policies
                └── Password Policy
```

The following settings were configured:

- Minimum password length: `8 characters`
- Password must meet complexity requirements: `Enabled`
- Enforce password history: `5 passwords remembered`
- Minimum password age: `1 day`
- Maximum password age: `90 days`

These settings apply password security requirements to domain accounts.

### Password Policy Verification

![Password Policy Configuration](../Screenshots/Active%20Directory/06-Password-Policy.png)

---

### Account Lockout Policy Configuration

The account lockout policy was configured using:

```text
Computer Configuration
└── Policies
    └── Windows Settings
        └── Security Settings
            └── Account Policies
                └── Account Lockout Policy
```

The following settings were configured:

- Account lockout threshold: `5 invalid logon attempts`
- Account lockout duration: `30 minutes`
- Reset account lockout counter after: `30 minutes`

### Testing

On `Corp-CL01`, the updated Group Policy was applied using:

```cmd
gpupdate /force
```

The policy application was verified using:

```cmd
gpresult /r
```

`Default Domain Policy` appeared under the applied computer Group Policy Objects.

The account lockout policy was then tested using `CORP\jsmith`. After five failed sign-in attempts, the account was locked and Windows displayed a message confirming that the account could not be logged on to because it was currently locked out.

### Account Lockout Policy Verification

![Account Lockout Policy Configuration](../Screenshots/Active%20Directory/07-Account-Lockout-Policy.png)

### Account Lockout Test Verification

![Account Locked](../Screenshots/Active%20Directory/08-Account-Locked.png)

---

### Result

The domain password policy and account lockout policy were successfully configured and tested.

The test confirmed that after `5` invalid sign-in attempts, the domain account was locked. The account was then unlocked through **Active Directory Users and Computers** on `Corp-DC01`.


## GPO - Removable Storage Restrictions

### Purpose

Configured a computer-based Group Policy to restrict access to removable storage devices. This helps protect endpoints by preventing users from accessing USB storage devices.

### GPO Details

**GPO Name:** `GPO - Removable Storage Restrictions`  
**Linked OU:** `Workstations`  
**Target Computer:** `CORP-CL01`

### Configuration

The policy was configured using the following path:

```text
Computer Configuration
└── Policies
    └── Administrative Templates
        └── System
            └── Removable Storage Access
```

Configured policy:

```text
All Removable Storage classes: Deny all access
```

The policy was set to:

```text
Enabled
```

### Applying the Policy

On `Corp-CL01`, Group Policy was refreshed using:

```cmd
gpupdate /force
```

The workstation was then restarted to ensure the computer policy was fully applied.

### Testing

A USB flash drive was connected to `Corp-CL01` through VirtualBox.

The device appeared in File Explorer as:

```text
Removable Disk (E:)
```

When access to the drive was attempted, Windows displayed:

```text
E:\ is not accessible.
Access is denied.
```

This confirmed that the `GPO - Removable Storage Restrictions` policy was successfully applied to `CORP-CL01`.

### Verification Screenshot

![Removable Storage Access Denied](../Screenshots/Active%20Directory/09-Removable-Storage-Access-Denied.png)


## Local Administrator Management

A Group Policy Object named `GPO - Local Administrators` was configured and linked to the `Workstations` OU.

The policy adds the Active Directory security group `CORP\GG_IT` to the local `Administrators` group on domain workstations.

### Configuration

The final working configuration used **Restricted Groups** in Group Policy:

```text
Computer Configuration
└── Policies
    └── Windows Settings
        └── Security Settings
            └── Restricted Groups
                └── CORP\GG_IT
                    Member Of → Administrators
```

The `CORP\GG_IT` security group was configured so that it becomes a member of the local `Administrators` group on workstations affected by the GPO.

This allows authorised IT users who are members of `GG_IT` to receive local administrator privileges without manually adding individual users to each workstation.

### Verification

The policy was applied on `Corp-CL01` using:

```powershell
gpupdate /target:computer /force
```

The local Administrators group was then checked using:

```powershell
Get-LocalGroupMember -Group "Administrators"
```

The result confirmed that `CORP\GG_IT` was successfully added to the local Administrators group:

```text
CORP\Domain Admins
CORP\GG_IT
CORP-CL01\Administrator
CORP-CL01\LocalAdmin
```

### Verification Screenshot

![GG_IT added to Local Administrators](../Screenshots/Active%20Directory/14-GG_IT-Local-Administrators.png)

### Result

The `GPO - Local Administrators` policy was successfully applied to `Corp-CL01`.

The Active Directory security group `CORP\GG_IT` was added to the workstation's local `Administrators` group through Group Policy. This provides a centralised method for managing local administrator access on domain workstations.


## End-to-End Local Administrator Verification

The local administrator policy was tested using the domain user `CORP\jsmith`.

John Smith is a member of the Active Directory security group `GG_IT`. The `GG_IT` group is configured through the `GPO - Local Administrators` policy to become a member of the local `Administrators` group on domain workstations.

### Verify Domain Group Membership

The user's domain group membership was verified using:

```cmd
net user jsmith /domain
```

The output confirmed that John Smith is a member of:

```text
Global Group memberships
*Domain Users
*GG_IT
```

### Verify Local Administrator Membership

The user's current security token was checked on `Corp-CL01` using:

```cmd
whoami /groups | findstr /i "Administrators"
```

The result confirmed that John is a member of the local Administrators group:

```text
CORP-CL01\Administrators (built-in)
Mandatory group, Enabled by default, Enabled group
```

This verified the complete access chain:

```text
John Smith
    ↓
CORP\GG_IT
    ↓
GPO - Local Administrators
    ↓
CORP-CL01\Administrators
    ↓
Local Administrator Privileges
```

### Verification Screenshot

![John Smith verified as Local Administrator](../Screenshots/Active%20Directory/15-John-Smith-Local-Administrator.png)

### Result

John Smith, as a member of `CORP\GG_IT`, was successfully verified as a member of the local `Administrators` group on `Corp-CL01`.

This confirms that local administrator access is being centrally managed through Active Directory group membership and Group Policy.

