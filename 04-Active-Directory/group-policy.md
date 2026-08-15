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
