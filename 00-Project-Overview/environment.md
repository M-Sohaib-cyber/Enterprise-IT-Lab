# Lab Environment

## Overview

The Enterprise IT Lab is a local virtual environment hosted on Windows 11 using Oracle VirtualBox. pfSense provides routing between virtual networks, and Windows Server and Windows 11 virtual machines provide the current enterprise services and client workload.

## Host and virtualization

| Item | Confirmed information |
|---|---|
| Host operating system | Windows 11 |
| Virtualization platform | Oracle VirtualBox |
| Host model | HP Pavilion x360 Convertible 14-dw0xxx; verified 2026-10-06 |
| CPU | Intel Core i5-1035G1; 4 cores / 8 logical processors; verified 2026-10-06 |
| Installed RAM | 16 GB, 2 x 8 GB; verified 2026-10-06 |
| Host storage and Windows edition | To verify |
| VirtualBox version | Oracle VirtualBox 7.1.12; verified tested host version |

VM allocations and attachments verified on 2026-10-06 are maintained in the [device inventory](../01-Enterprise-Planning/device-inventory.md).

## Prerequisites for a fresh build

Prepare the following before creating the VMs. Software versions and licensing depend on the reader's environment; the table separates the documented lab from choices that have not been verified.

| Prerequisite | Documented lab baseline | Reader preparation |
|---|---|---|
| Host | Windows 11 on the hardware listed above | Use a host capable of running the four x86-64 guests; other host platforms are reader choices and have not been tested in this repository. |
| VirtualBox | Oracle VirtualBox 7.1.12; verified tested version | Use 7.1.12 to match the tested baseline. Other VirtualBox versions have not been specifically tested for this lab; compatibility with the host and recorded guest settings, including Windows 11 TPM/EFI, requires verification. Record the version used; menu labels can vary. |
| Hardware virtualization | The documented host successfully runs the lab | Confirm Intel VT-x or AMD-V is available and enabled in host firmware and usable by VirtualBox. Firmware access and interaction with other host virtualization software are environment dependent. |
| pfSense media | pfSense CE 2.8.1 is the recorded installation version; current live version To verify | Obtain suitable pfSense CE installation media. A different release is a reader choice and may change installation screens or defaults. |
| Windows Server media | Windows Server 2022; DC uses Standard Evaluation with Desktop Experience, FS01 uses Standard Evaluation | Obtain suitable Windows Server 2022 installation media and valid evaluation/licensing arrangements. The same media can be used to build the two separate server VMs. |
| Windows client media | Windows 11 Enterprise Evaluation | Obtain suitable Windows 11 media with domain-join capability; a different edition/build is a reader choice requiring compatibility checks. |
| Installation access | Media and host storage are reader supplied | Have local permission to install VirtualBox, create VMs, and access firmware if needed. Keep the installation media available and provide host internet access for downloads and later updates. |

Passwords, ISO locations, the VM storage folder, host network details, and license/evaluation terms are reader choices. Use your own credentials; repository screenshots and records are not installation media or reusable VM images.

### Host RAM, CPU, and storage planning

The tested host has 16 GB RAM and a 4-core / 8-thread Intel Core i5-1035G1. For this particular lab, **16 GB host RAM is the recommended practical starting minimum**, based on that tested baseline, rather than an official vendor minimum or a guarantee for every host workload. More RAM gives additional room for the host, updates, and simultaneous testing.

The four documented guest allocations total 13,315 MB, approximately 13 GiB, before host and VirtualBox overhead. Running every VM simultaneously on a 16 GB host is resource-constrained. Close unnecessary host applications and build or update guests in stages. Keep pfSense and the DC available when testing domain/network services; file-access and GPO tests involving FS01 and CL01 can require all four guests running. The tested CPU is a reference, not a minimum CPU specification; assigning 2 vCPU per VM does not establish a requirement for eight physical host cores.

The [fresh-build disk baseline](../01-Enterprise-Planning/device-inventory.md#fresh-build-vm-baseline) totals approximately 260 GB of guest virtual disk capacity, including the separate FS01 backup VDI. Plan host storage for that capacity plus installation media, snapshot growth, and free space needed by the host. Dynamically allocated VDIs can initially occupy less space, but their growth still needs storage capacity. Exact starting free-space requirements and snapshot overhead depend on use; no measured host free-space minimum is established by the repository.

### Foundation setup order

1. Confirm host virtualization and capacity, install VirtualBox, and prepare the media above.
2. Follow the [VirtualBox network creation procedure](../02-Network-Design/network-plan.md#create-the-virtualbox-networks) and review its gateway verification checkpoint.
3. Create fresh VMs using the [VM baseline and creation steps](../01-Enterprise-Planning/device-inventory.md#fresh-build-vm-baseline), then set their [network adapters](../02-Network-Design/network-plan.md#configure-vm-network-adapters).
4. Continue with the [README build path](../README.md#build-from-zero) for pfSense, server, directory, client, and verification stages.

## Current lab components

| Component | Platform/OS | Function |
|---|---|---|
| `Corp-FW01` | pfSense CE on a FreeBSD-based VM | Firewall, gateway, NAT, and routing between lab networks |
| `Corp-DC01` | Windows Server 2022 | Active Directory Domain Services and DNS |
| `Corp-FS01` | Windows Server 2022 Standard Evaluation, build 20348 | SMB file sharing for departmental and public resources |
| `Corp-CL01` | Windows 11 Enterprise Evaluation | Domain-joined user workstation and GPO test client |

Authoritative device and address details are maintained in the [device inventory](../01-Enterprise-Planning/device-inventory.md) and [IP addressing reference](../02-Network-Design/ip-addressing.md).

## Logical environment

- Active Directory DNS domain: `corp.internal`
- NetBIOS domain: `CORP`
- Server network: `Corp-Core` - `10.10.20.0/24`
- Client network: `Corp-Clients` - `10.10.30.0/24`
- Internet connectivity: pfSense WAN through VirtualBox NAT

Verification on 2026-10-06 confirmed both lab NAT Networks and their IPv4 prefixes above, with VirtualBox DHCP disabled on each. Corp-CL01 Adapter 1 uses NAT Network Corp-Clients; pfSense OPT1 supplies its tested DHCP configuration. All four VM network attachments are now verified in the device inventory; uninspected settings remain to verify. See [DHCP verification](../04-Active-Directory/dhcp.md).

## Virtual storage and snapshots - verified 2026-10-06

VM storage uses VDI disks with snapshots/differencing disks. Virtual disk encryption is disabled. Existing historical snapshots were intentionally retained; some older names/descriptions contain stale or incorrect metadata and do not represent current live configuration.

Guest Additions were installed on `Corp-DC01` and `Corp-FS01`, and bidirectional clipboard was tested successfully on both. New powered-off snapshots were created:

- `DC01 - Patched and Guest Additions - 2026-10-06`
- `FS01 - Patched and Guest Additions - 2026-10-06`

Post-patch checks are recorded in the [DC build record](../03-Virtual-Infrastructure/windows-server-build-guide.md#patch-and-post-update-verification---2026-10-06) and [file-server record](../03-Virtual-Infrastructure/file-server.md#patch-and-post-update-verification---2026-10-06).

## Implemented services

- pfSense routing and firewalling
- Active Directory Domain Services
- Active Directory-integrated DNS
- Windows domain membership and authentication
- SMB file sharing and mapped drives
- Multiple user and computer Group Policy configurations

The lab does not currently claim implementation of technologies that appear only as future ideas elsewhere in the repository.
