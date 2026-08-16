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