# Corp-DC01 Build and Configuration

## Purpose

This is the authoritative build and configuration record for `Corp-DC01`, the Windows Server 2022 domain controller and DNS server for `corp.internal` (`CORP`). Detailed OU, user, group, and GPO information belongs in the [Active Directory documentation](../04-Active-Directory/).

## Server inventory

| Setting | Recorded value |
|---|---|
| Hostname | `Corp-DC01` |
| Operating system | Windows Server 2022 Standard Evaluation (Desktop Experience) |
| Roles | Active Directory Domain Services and DNS Server |
| IPv4 address | `10.10.20.10/24` |
| Default gateway | `10.10.20.1` |
| Preferred DNS | `10.10.20.10` |
| Virtual network | `Corp-Core` |
| Domain | `corp.internal` |
| NetBIOS domain | `CORP` |

The current OS build number, activation state, patch level, and Active Directory functional levels remain **To verify**.

## Virtual machine build record

| Setting | Recorded value |
|---|---|
| Platform | Oracle VirtualBox |
| Memory | 4096 MB |
| CPU | 2 vCPU |
| Virtual disk | 80 GB dynamically allocated VDI |
| Video memory | 128 MB |
| Firmware | EFI disabled |
| TPM | None |
| Recorded network attachment | NAT Network named `Corp-Core` |

These values come from the existing build record. The current live VM settings and VirtualBox network attachment should be verified before treating this table as a configuration export.

## Windows Server installation

The build record documents:

- Windows Server 2022 Standard Evaluation with Desktop Experience
- English language and UK keyboard selection
- Custom installation to the 80 GB virtual disk
- Local Administrator password configured during setup
- Computer renamed to `Corp-DC01`
- Static IPv4 address assigned before domain-controller promotion

The server originally had no default gateway while pfSense was still being deployed. The current documented gateway is `10.10.20.1` on `Corp-FW01`.

## Active Directory promotion

The following promotion settings are supported by the existing records:

| Setting | Value |
|---|---|
| Deployment | New forest |
| Root domain | `corp.internal` |
| NetBIOS name | `CORP` |
| DNS Server | Installed |
| Global Catalog | Enabled |
| Read-only domain controller | No |
| DSRM password | Configured; value not documented |
| Forest functional level | To verify |
| Domain functional level | To verify |

Existing documents conflict between Windows Server 2016 and Windows Server 2025 functional levels. Neither value is presented as current until it is checked on `Corp-DC01`.

## DNS configuration

`Corp-DC01` hosts DNS for `corp.internal` and uses `10.10.20.10` as its preferred DNS server. `Corp-CL01` is also observed using `10.10.20.10` for DNS.

Forwarders, reverse lookup zones, detailed zone properties, aging/scavenging, and logging remain **To verify**. See [Active Directory DNS](../04-Active-Directory/dns.md).

## Documented verification

The existing build and deployment records document successful checks using:

```cmd
hostname
echo %userdomain%
nslookup corp.internal
ipconfig /all
```

The recorded expected/current identity values are:

```text
Hostname: Corp-DC01
Domain/NetBIOS: CORP
DNS domain: corp.internal
DNS/DC address: 10.10.20.10
```

Repository documentation also records successful domain-controller promotion, DNS operation, domain join of `Corp-CL01`, and domain authentication. These statements preserve the existing test record; they are not a new live test performed during documentation cleanup.

Live verification on 2026-09-16 confirmed static `10.10.20.10/24`, gateway `10.10.20.1`, and domain `corp.internal`. DNS resolution for `corp.internal` and `Corp-DC01.corp.internal` succeeded. All five FSMO roles (Schema Master, Domain Naming Master, RID Master, PDC Emulator, and Infrastructure Master) are held by `Corp-DC01`. `dcdiag` generally passed; a WinRM WSMAN SPN warning remains for later investigation.

## Recorded build issues

The original build guide records these issues and resolutions:

- A VPN interrupted the Windows Server download; the download succeeded after the VPN was disabled.
- A blue screen occurred during initial installation; the VM restarted and completed installation.
- DNS lookup was delayed immediately after promotion while services initialized.
- Windows displayed an unexpected shutdown reason prompt after installation.

## To verify

- Current Windows Server build, activation, and patch state
- Forest and domain functional levels
- Current VM CPU, memory, disk, firmware, and network settings
- DNS forwarders, reverse zones, and detailed zone configuration
- Backup, recovery, time synchronization, and monitoring configuration
- WinRM WSMAN SPN warning reported by `dcdiag`

## Evidence

- [Windows Server installed](../Screenshots/Servers/windows%20server%20installed.png)
- [Server feature installation](../Screenshots/Servers/05-Windows%20server%20feature%20installation.png)
- [Pre-configuration Local Server capture](../Screenshots/Servers/06-Windows%20server%20name%20change.png)

The file named `07-Windows server internet protocol.png` is a byte-for-byte duplicate of the pre-configuration capture and does not prove the final IP settings. The final hostname and address are supported by the written build record and live verification on 2026-09-16. See the [Screenshot Evidence Index](../Screenshots/README.md).

## Related documentation

- [Active Directory configuration record](../04-Active-Directory/active-directory-installation.md)
- [Active Directory DNS](../04-Active-Directory/dns.md)
- [Current network topology](../02-Network-Design/network-topology.md)
- [IP addressing, DHCP, and DNS](../02-Network-Design/ip-addressing.md)
- [Corp-FS01 file server](file-server.md)
- [Corp-CL01 Windows 11 client](../05-Client-Management/windows11-client.md)
