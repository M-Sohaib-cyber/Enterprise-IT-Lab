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

