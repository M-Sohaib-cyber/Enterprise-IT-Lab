# Windows Server 2022 Build Guide

## 1. Purpose

This document provides a step-by-step guide for building the primary Windows Server 2022 Domain Controller used in the Enterprise IT Lab.

The guide covers the complete build process, from creating the virtual machine to promoting the server as the first Domain Controller within the `corp.internal` Active Directory forest.

At the end of this guide, the server will provide the following services:

- Active Directory Domain Services (AD DS)
- Domain Name System (DNS)

This guide is intended to allow the environment to be rebuilt from scratch without referring to external documentation.

---

## 2. Prerequisites

Before beginning the installation, ensure the following requirements have been completed.

### 2.1 Host Machine

- Windows 11 Host Operating System
- Oracle VirtualBox installed
- Enterprise-Lab-VMs directory created
- Sufficient free disk space (Minimum 100 GB recommended)
- Hardware virtualisation (Intel VT-x / AMD-V) enabled in BIOS

### 2.2 Required Software

| Software | Purpose |
|----------|---------|
| Oracle VirtualBox | Virtualisation Platform |
| Windows Server 2022 Standard Evaluation (ISO) | Domain Controller Operating System |

### 2.3 Required Virtual Networks

The following NAT Network must already exist.

| Network | Address Space | DHCP |
|---------|---------------|------|
| Corp-Core | 10.10.20.0/24 | Disabled |

> **Note**
>
> DHCP is intentionally disabled because the Windows Server will later provide DHCP services for the enterprise network.

---

## 3. Create the Virtual Machine

Open Oracle VirtualBox and select **New**.

### 3.1 Virtual Machine Configuration

| Setting | Value |
|---------|-------|
| Name | Corp-DC01 |
| Type | Microsoft Windows |
| Version | Windows Server 2022 (64-bit) |
| ISO Image | Windows Server 2022 Evaluation |
| VM Folder | Enterprise-Lab-VMs |

> Enable **Skip Unattended Installation** to perform a manual installation.

---

### 3.2 Hardware Configuration

| Setting | Value |
|---------|-------|
| Memory | 4096 MB |
| Processor | 2 vCPU |

---

### 3.3 Storage Configuration

| Setting | Value |
|---------|-------|
| Disk Type | VDI |
| Allocation | Dynamically Allocated |
| Capacity | 80 GB |

---

## 4. Configure VirtualBox

Before starting the virtual machine, review and configure the following settings.

### 4.1 General Settings

| Setting | Value |
|---------|-------|
| Shared Clipboard | Bidirectional |
| Drag and Drop | Disabled |

---

### 4.2 System Settings

| Setting | Value |
|---------|-------|
| Boot Order | Optical, Hard Disk |
| Floppy | Disabled |
| EFI | Disabled |
| TPM | None |

---

### 4.3 Display Settings

| Setting | Value |
|---------|-------|
| Video Memory | 128 MB |

---

### 4.4 Network Configuration

Configure Adapter 1 as follows.

| Setting | Value |
|---------|-------|
| Adapter | Adapter 1 |
| Attached To | NAT Network |
| NAT Network | Corp-Core |
| Cable Connected | Enabled |

> ⚠ Important
>
> The Domain Controller must be connected to the **Corp-Core** network before installation begins.

---

## 5. Install Windows Server

Start the virtual machine.

Boot from the Windows Server 2022 Evaluation ISO.

Complete the Windows installation using the following options.

### 5.1 Installation Settings

| Setting | Value |
|---------|-------|
| Language | English |
| Keyboard | UK |
| Edition | Windows Server 2022 Standard Evaluation (Desktop Experience) |
| Installation Type | Custom |

---

### 5.2 Disk Selection

Select the 80 GB virtual disk.

No manual partitioning is required.

Windows Setup will automatically create the required system partitions.

---

### 5.3 Administrator Account

Create the local Administrator password.

Record the password securely for future administration.

Allow Windows Setup to complete and log into the server.

---

## 6. Initial Server Configuration

After the first login, complete the following configuration tasks.

### 6.1 Rename the Server

Rename the computer to:

```

Corp-DC01

```

Restart the server to apply the new hostname.

---

### 6.2 Configure Network Settings

Assign the following static IPv4 configuration.

| Setting | Value |
|---------|-------|
| IP Address | 10.10.20.10 |
| Subnet Mask | 255.255.255.0 |
| Default Gateway | Leave Blank |
| Preferred DNS | 10.10.20.10 |

> 💡 The default gateway will be configured later after the pfSense firewall has been deployed.

---

### 6.3 Verify Network Configuration

Open Command Prompt and run:

```cmd
ipconfig /all
```

Verify:

- Static IPv4 Address
- DNS Server
- DHCP Disabled

---

## 7. Install Active Directory Domain Services

Open:

Server Manager → Manage → Add Roles and Features

Install the following roles.

- Active Directory Domain Services
- DNS Server

Accept all required features.

Complete the installation.

---

### 7.1 Promote the Server

Select:

Promote this server to a domain controller

Deployment Configuration:

| Setting | Value |
|---------|-------|
| Deployment | Add a New Forest |
| Root Domain | corp.internal |
| NetBIOS | CORP |

---

### 7.2 Domain Controller Options

| Setting | Value |
|---------|-------|
| Forest Functional Level | Windows Server 2016 |
| Domain Functional Level | Windows Server 2016 |
| DNS Server | Enabled |
| Global Catalog | Enabled |
| Read Only Domain Controller | Disabled |

Configure the Directory Services Restore Mode (DSRM) password.

Continue through the remaining wizard using the default settings.

Complete the installation and allow the server to restart automatically.

---

## 8. Verification

After the server has restarted, verify the installation.

### Verify Hostname

```cmd
hostname
```

Expected output

```

Corp-DC01

```

### Verify Domain

```cmd
echo %userdomain%
```

Expected output

```

CORP

```

### Verify DNS

```cmd
nslookup corp.internal
```

Expected result

```

Name: corp.internal
Address: 10.10.20.10

```

### Verify IP Configuration

```cmd
ipconfig /all
```

Confirm:

- Static IP Address
- DHCP Disabled
- DNS configured correctly

---

## 9. Troubleshooting

### Issue 1 - Windows Server Download Failed

**Cause**

VPN connection interrupted the Microsoft download.

**Resolution**

Disable the VPN and restart the download.

---

### Issue 2 - Blue Screen During Initial Installation

**Cause**

Windows Server displayed a Blue Screen of Death (BSOD) during the first boot.

**Resolution**

The virtual machine restarted automatically and completed the installation successfully.

---

### Issue 3 - DNS Lookup Delay

**Cause**

Immediately after promoting the server to a Domain Controller, the DNS service required additional time to initialise.

**Resolution**

Wait for the services to start completely before testing DNS resolution.

---

### Issue 4 - Unexpected Restart Notification

**Cause**

Windows requested a reason for the previous unexpected shutdown after installation.

**Resolution**

Select **Other (Unplanned)** and continue with the server configuration.

---

## 10. Build Summary

| Item | Value |
|------|-------|
| Server Name | Corp-DC01 |
| Operating System | Windows Server 2022 Standard Evaluation |
| Domain | corp.internal |
| NetBIOS | CORP |
| IP Address | 10.10.20.10 |
| RAM | 4 GB |
| CPU | 2 vCPU |
| Disk | 80 GB Dynamic VDI |
| Virtual Network | Corp-Core |
| Roles Installed | Active Directory Domain Services, DNS Server |

---

## 11. Build Outcome

The Windows Server has been successfully deployed as the first Domain Controller within the Enterprise IT Lab.

The server is now providing:

- Active Directory Domain Services (AD DS)
- DNS Services
- Authentication for the `corp.internal` domain

This server forms the foundation for all remaining infrastructure components within the Enterprise IT Lab.

