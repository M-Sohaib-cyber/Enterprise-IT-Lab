# Enterprise Group Design (AGDLP)

## Group Strategy

The lab follows the Microsoft AGDLP model for assigning permissions.

```
A (Accounts)
      ↓
G (Global Groups)
      ↓
DL (Domain Local Groups)
      ↓
P (Permissions)
```

## Global Groups

| Group | Purpose |
|--------|---------|
| GG_IT | IT Department |
| GG_HR | Human Resources |
| GG_Finance | Finance Department |
| GG_Sales | Sales Department |
| GG_HelpDesk | Help Desk Team |

## Domain Local Groups

| Group | Purpose |
|--------|---------|
| DL_IT_RW | Modify access to IT share |
| DL_HR_RW | Modify access to HR share |
| DL_Finance_RW | Modify access to Finance share |
| DL_Sales_RW | Modify access to Sales share |
| DL_HelpDesk_RW | Reserved for Help Desk resources |
| DL_Public_RO | Read-only access to Public share |

## Group Nesting

| Global Group | Domain Local Group |
|---------------|-------------------|
| GG_IT | DL_IT_RW |
| GG_HR | DL_HR_RW |
| GG_Finance | DL_Finance_RW |
| GG_Sales | DL_Sales_RW |
| GG_HelpDesk | DL_HelpDesk_RW |
| Domain Users | DL_Public_RO |

## User Membership

John Smith

```
John Smith
      ↓
GG_IT
      ↓
DL_IT_RW
```

This allows John Smith to access the IT departmental share while denying access to HR, Finance and Sales.

## New Employee Onboarding - Finance Department

### Scenario

A new employee, Sarah Ahmed, joined the Finance department. The task was to create her domain account, assign the correct group memberships and permissions, and verify that she could access the appropriate company resources.

### User Details

| Setting | Value |
|---|---|
| Name | Sarah Ahmed |
| Username | `sahmed` |
| Domain | `corp.internal` |
| Department | Finance |
| User OU | `Company Users` |

### Account Creation

The user account was created in **Active Directory Users and Computers** under the `Company Users` OU.

The account was configured with a temporary password and **User must change password at next logon** enabled.

On the first successful login, the user changed the temporary password to a new password that met the domain password policy requirements.

### Department Group Membership

Sarah was added to the Finance global security group:

```text
GG_Finance
```

The Finance global group was then assigned to the Finance domain local group:

```text
GG_Finance
        ↓
DL_Finance_RW
```

This group structure provides Finance users with read/write access to Finance resources through group-based permissions.

### Finance Drive Mapping

A new Finance drive mapping was added to:

```text
GPO - Drive Mappings
```

The mapping was configured as:

| Setting | Value |
|---|---|
| Action | `Create` |
| Location | `\\Corp-FS01\Finance` |
| Drive Letter | `F:` |
| Label | `Finance` |

Item-level targeting was configured so that only members of the following security group receive the Finance drive:

```text
CORP\GG_Finance
```

The access structure is:

```text
Sarah Ahmed (sahmed)
        ↓
GG_Finance
        ↓
DL_Finance_RW
        ↓
Finance Share
        ↓
F: Finance Drive
```

### Testing

The user logged in successfully to `Corp-CL01` as:

```text
CORP\sahmed
```

After Group Policy was refreshed and the user signed back in, the Finance drive appeared automatically in File Explorer.

The following access was tested:

- `F: Finance` — Access successful
- Create file in `F:` — Successful
- Delete file in `F:` — Successful
- `P: Public` — Access successful
- `I: IT` — Access denied

This confirmed that the user received the correct department access through Active Directory group membership, file permissions, and Group Policy drive mapping.

### Result

The Finance employee onboarding process was successfully completed.

Sarah Ahmed was able to authenticate to the domain and access the appropriate Finance and Public resources while being denied access to the IT department share.

## Employee Offboarding - Finance Department

### Scenario

Sarah Ahmed (`sahmed`) left the Finance department. The account was offboarded by disabling the user account, removing department access, and retaining the account in Active Directory for administrative and audit purposes.

### Offboarding Actions

#### 1. Created Disabled Users OU

A new Organizational Unit was created:

```text
Disabled Users
```

This OU is used to store disabled employee accounts instead of deleting them immediately.

#### 2. Disabled the User Account

The Active Directory account for Sarah Ahmed was disabled.

This prevents the user from successfully authenticating to the domain.

#### 3. Moved the Account

After disabling the account, Sarah Ahmed was moved from:

```text
Company Users
```

to:

```text
Disabled Users
```

#### 4. Removed Finance Group Membership

Sarah Ahmed was removed from:

```text
GG_Finance
```

The user's **Member Of** tab was checked after removal and showed only:

```text
Domain Users
```

Because `GG_Finance` provided Finance department membership and was used for access control, removing Sarah from this group removed her Finance department access.

### Access Verification

The user account was tested after offboarding.

Before the final sign-in test, the Finance drive mapping was no longer available to the user because Sarah was no longer a member of `GG_Finance`.

A fresh sign-in attempt was then made using:

```text
CORP\sahmed
```

The sign-in was rejected with the following message:

> Your account has been disabled. Please see your system administrator.

![Disabled account login denied](../Screenshots/Active%20Directory/10-Disabled-Account-Login-Denied.png)

### Result

The employee offboarding process was successfully completed.

Sarah Ahmed's account was:

- Disabled
- Moved to the `Disabled Users` OU
- Removed from the `GG_Finance` security group
- Removed from Finance drive access
- Unable to sign in to the domain

The account was retained in Active Directory rather than deleted, allowing it to remain available for administrative review or auditing if required.
