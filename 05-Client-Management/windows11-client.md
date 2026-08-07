# Windows 11 Enterprise Client Deployment

## Objective

Deploy a Windows 11 Enterprise client virtual machine, configure networking, join it to the Active Directory domain, and verify domain authentication.

---

# Virtual Machine Configuration

| Setting | Value |
|---------|-------|
| VM Name | Corp-CL01 |
| Operating System | Windows 11 Enterprise Evaluation |
| Generation | VirtualBox |
| Memory | 4096 MB |
| CPU | 2 vCPU |
| Video Memory | 128 MB |
| Graphics Controller | VBoxSVGA |
| TPM | Enabled (v2.0) |
| EFI | Enabled |
| Secure Boot | Enabled |

---

# Network Configuration

| Adapter | Network | Purpose |
|----------|----------|----------|
| Adapter 1 | Corp-Clients | Client Network |

Network Configuration:

- DHCP Enabled
- DNS Server: 10.10.20.10
- Gateway: 10.10.30.1

---

# Operating System Installation

Completed:

- Installed Windows 11 Enterprise Evaluation
- Selected English (United Kingdom)
- Selected UK Keyboard Layout
- Created local administrator account
- Disabled optional privacy settings where appropriate

---

# Computer Configuration

Original Computer Name

DESKTOP-T3EGECN

Renamed To

Corp-CL01

Restart Required

Yes

---

# Domain Join

Joined Domain:

corp.internal

Credentials Used

CORP\Administrator

Verification

- Domain join completed successfully.
- Computer restarted successfully.
- Logged on using domain credentials.
- Computer account appeared in Active Directory.

---

# Active Directory

Computer Object

Corp-CL01

Moved To

Workstations OU

Status

Successful

---

# IP Configuration

Obtained via DHCP

IP Address

10.10.30.100

Subnet Mask

255.255.255.0

Default Gateway

10.10.30.1

DNS Server

10.10.20.10

---

# Initial Issue

## Problem

Client received an IP address but could not communicate with pfSense, Domain Controller or the Internet.

## Root Cause

No firewall rules existed on the OPT1 interface in pfSense.

## Resolution

Created an allow rule:

Source:
OPT1 Subnet

Destination:
Any

Protocol:
IPv4 Any

Action:
Pass

Connectivity was immediately restored.

---

# Verification

Verified:

- Client successfully obtained DHCP address.
- DNS resolution functioning.
- Domain authentication successful.
- Internet connectivity restored.
- Communication with Domain Controller successful.

