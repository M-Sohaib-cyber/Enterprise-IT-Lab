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

