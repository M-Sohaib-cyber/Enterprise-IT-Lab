# Windows Server 2022 Domain Controller

## Purpose

This virtual machine acts as the primary Domain Controller for the enterprise lab.

Roles installed:

- Active Directory Domain Services (AD DS)
- DNS Server

Domain:

corp.internal

---

# Virtual Machine Configuration

| Setting | Value |
|---------|-------|
| VM Name | Corp-DC01 |
| Operating System | Windows Server 2022 Standard Evaluation |
| Platform | Oracle VirtualBox |
| RAM | 4 GB |
| CPU | 2 vCPU |
| Disk | 80 GB (Dynamic VDI) |
| Network | Corp-Core NAT Network |

---

# Computer Configuration

| Setting | Value |
|---------|-------|
| Computer Name | Corp-DC01 |
| Domain | corp.internal |
| NetBIOS Name | CORP |
| IP Address | 10.10.20.10 |
| Subnet Mask | 255.255.255.0 |
| Default Gateway | None |
| Preferred DNS | 10.10.20.10 |

---

# Active Directory

Installed Roles:

- Active Directory Domain Services
- DNS Server
- Group Policy Management

Forest Functional Level:

Windows Server 2016

Domain Functional Level:

Windows Server 2016

---

# Validation

Completed checks:

- Windows Server installed
- Static IP configured
- Computer renamed
- Active Directory installed
- DNS installed
- New forest created
- Domain Controller promotion successful
- DNS resolution verified
- Hostname verified

---

# Notes

The server uses itself as its DNS server.

DNS lookup for `corp.internal` resolves correctly to:

10.10.20.10

This server is the foundation of the enterprise lab.