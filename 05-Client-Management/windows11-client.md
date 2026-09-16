# Corp-CL01 Windows 11 Client

## Purpose and status

`Corp-CL01` is the Windows 11 workstation used to verify client networking, domain authentication, file access, user workflows, and Group Policy in the `corp.internal` domain.

The client is documented as domain joined and operational. This document distinguishes recorded build details from values visible in current evidence.

## Client inventory

| Setting | Recorded value |
|---|---|
| Computer name | `Corp-CL01` |
| Platform | Oracle VirtualBox |
| Operating system | Windows 11 Enterprise Evaluation |
| Domain | `corp.internal` |
| NetBIOS domain | `CORP` |
| Computer OU | `Workstations` |
| Network | `Corp-Clients` |

The Windows edition comes from the existing deployment record. Current Windows edition, version, build, activation, and patch state are **To verify**.

## Recorded VM build

| Setting | Recorded value |
|---|---|
| Memory | 4096 MB |
| CPU | 2 vCPU |
| Video memory | 128 MB |
| Graphics controller | VBoxSVGA |
| TPM | Version 2.0 enabled |
| EFI | Enabled |
| Secure Boot | Enabled |

Disk size, current VM settings, adapter model, and exact VirtualBox network configuration are **To verify**.

## Network configuration

The existing `ipconfig /all` screenshot records:

| Item | Observed value |
|---|---|
| DHCP enabled | Yes |
| IPv4 address | `10.10.30.100` |
| Subnet mask | `255.255.255.0` |
| Default gateway | `10.10.30.1` |
| DHCP server | `10.10.30.1` |
| DNS server | `10.10.20.10` |
| DNS suffix | `corp.internal` |

Evidence: [Corp-CL01 IP configuration](../Screenshots/Verifications/01-Corp-CL01%20ipconfig.png).

`10.10.30.100` is an observed DHCP lease, not a confirmed reservation. The DHCP provider and server-side configuration remain **To verify**; see [DHCP evidence and status](../04-Active-Directory/dhcp.md).

## Domain join

The deployment record documents:

- Original generated name: `DESKTOP-T3EGECN`
- Renamed computer: `Corp-CL01`
- Joined domain: `corp.internal`
- Join credentials recorded as `CORP\Administrator`
- Computer account moved to the `Workstations` OU
- Successful sign-in with domain credentials

Active Directory documentation also records the computer object and successful domain authentication.

## Documented connectivity issue

After receiving a DHCP address, the client initially could not reach pfSense, `Corp-DC01`, or the internet. Existing documentation attributes this to the absence of a pass rule on OPT1.

An OPT1 IPv4 Any-to-Any rule was added and connectivity was recorded as restored. The rule remains a known practical security concern and has not been changed during documentation cleanup. See [Firewall Rules](../08-Security/firewall-rules.md).

## Documented verification and use

Repository records describe successful:

- DHCP address acquisition
- DNS resolution using `10.10.20.10`
- Communication with `Corp-DC01`
- Domain join and domain authentication
- Internet access after the OPT1 rule was added
- User and computer GPO application
- Mapped-drive and file-access testing against `Corp-FS01`

These are preserved historical test results, not new tests performed during this documentation cleanup.

## To verify

- Current Windows edition, version, build, activation, and patch state
- Current VM CPU, memory, disk, firmware, TPM, display, and network settings
- DHCP provider and whether `10.10.30.100` is reserved
- Current local accounts and local group membership
- Current applied GPO inventory

## Related documentation

- [Current network topology](../02-Network-Design/network-topology.md)
- [IP addressing, DHCP, and DNS](../02-Network-Design/ip-addressing.md)
- [DHCP evidence and status](../04-Active-Directory/dhcp.md)
- [Corp-DC01 build](../03-Virtual-Infrastructure/windows-server-build-guide.md)
- [Corp-FS01 file server](../03-Virtual-Infrastructure/file-server.md)
- [Group Policy](../04-Active-Directory/group-policy.md)
