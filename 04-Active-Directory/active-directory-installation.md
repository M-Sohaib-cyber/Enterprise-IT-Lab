# Active Directory Installation

## Document Information

| Item | Value |
|------|-------|
| Document | Active Directory Installation |
| Lab | Enterprise IT Lab |
| Version | 1.0 |
| Author | Mohammad Sohaib |
| Status | Completed |

---

# Objective

Deploy Active Directory Domain Services (AD DS), create a new Active Directory forest, configure DNS, and prepare the domain for enterprise administration.

---

# Server Information

| Setting | Value |
|---------|-------|
| Server Name | Corp-DC01 |
| Operating System | Windows Server 2025 Evaluation |
| Role | Domain Controller |
| Domain | corp.internal |
| NetBIOS Name | CORP |

---

# Prerequisites

Completed before installing Active Directory:

- Windows Server installed.
- Static IPv4 address configured.
- Server renamed to **Corp-DC01**.
- Latest Windows updates installed (if applicable).

---

# Installed Roles

The following Windows Server roles were installed:

- Active Directory Domain Services (AD DS)
- DNS Server

---

# Domain Configuration

| Setting | Value |
|---------|-------|
| Forest | corp.internal |
| Domain | corp.internal |
| Forest Functional Level | Windows Server 2025 |
| Domain Functional Level | Windows Server 2025 |
| Global Catalog | Enabled |
| DNS | Installed Automatically |

---

# Domain Promotion

The server was promoted to the first Domain Controller in a new forest.

During promotion:

- New forest created.
- Domain Name: **corp.internal**
- DNS installed.
- Global Catalog enabled.
- Directory Services Restore Mode (DSRM) password configured.

The server restarted successfully after promotion.

---

# Active Directory Structure

The following Organizational Units (OUs) were created:

```text
corp.internal
│
├── Admins
│   └── IT Admins
│
├── Company Users
│
├── Groups
│
├── Servers
│
├── Service Accounts
│
└── Workstations
```

---

# Default Containers

The following default containers remain in the domain:

- Builtin
- Computers
- Domain Controllers
- ForeignSecurityPrincipals
- Managed Service Accounts
- Users

---

# User Accounts

Created:

| Display Name | Username |
|--------------|----------|
| John Smith | jsmith |

The user account was created inside:

```text
Company Users
```

---

# Security Groups

Created Global Security Groups:

- GG_IT
- GG_HR
- GG_Finance
- GG_Sales
- GG_HelpDesk

---

# Group Membership

John Smith

Member Of:

- Domain Users
- GG_IT

Role-Based Access Control (RBAC) is used throughout the environment by assigning permissions to security groups rather than directly to user accounts.

---

# Computer Accounts

## Corp-DC01

Role:

- Domain Controller

## Corp-CL01

Operating System:

Windows 11 Enterprise

Joined Domain:

corp.internal

Moved to:

```text
Workstations OU
```

---

# Domain Join Verification

Verified successfully:

- Client joined domain.
- Domain login successful.
- Computer account created automatically.
- Computer moved into the Workstations OU.
- Authentication using CORP\Administrator successful.

---

# Best Practices Implemented

- Organizational Units created before expanding the environment.
- Department-based Security Groups created.
- Role-Based Access Control (RBAC) adopted.
- Workstations separated from servers.
- Administrative accounts separated from standard user accounts.

---

# Future Expansion

The following components will be added later:

- Group Policy Objects (GPO)
- File Server
- Roaming Profiles (optional)
- Folder Redirection
- Windows Server Update Services (WSUS)
- Active Directory Certificate Services (AD CS)
- DFS Namespace
- PowerShell automation

---

# Verification Checklist

| Task | Status |
|------|--------|
| Active Directory Installed | ✅ |
| DNS Installed | ✅ |
| Domain Created | ✅ |
| Domain Controller Operational | ✅ |
| OUs Created | ✅ |
| Security Groups Created | ✅ |
| User Account Created | ✅ |
| Windows Client Joined Domain | ✅ |
| Computer Account Verified | ✅ |
| Domain Authentication Successful | ✅ |

---

# Lessons Learned

- Active Directory should be designed before large-scale user deployment.
- Organizational Units simplify administration and Group Policy deployment.
- Security Groups should be used to assign permissions instead of individual user accounts.
- Separating workstations, servers, users, and administrative accounts creates a scalable enterprise structure.

