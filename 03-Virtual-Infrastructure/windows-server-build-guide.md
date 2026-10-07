# Corp-DC01 Build and Configuration

## Purpose

This is the authoritative build and configuration record for `Corp-DC01`, the Windows Server 2022 domain controller and DNS server for `corp.internal` (`CORP`). Detailed OU, user, group, and GPO information belongs in the [Active Directory documentation](../04-Active-Directory/).

## Build from zero

This procedure implements the recorded DC identity and promotion settings. The existing history and live verification below remain the evidence record. Steps and expected checkpoints do not claim a new live test. Use your own passwords; text in angle brackets represents a reader-supplied value, not a literal password.

### 1. Create the VM and install Windows Server

1. Complete the [host prerequisites](../00-Project-Overview/environment.md#prerequisites-for-a-fresh-build), [network creation](../02-Network-Design/network-plan.md#create-the-virtualbox-networks), and [NAT Network gateway checkpoint](../02-Network-Design/network-plan.md#nat-network-gateway-verification-checkpoint).
2. Create `Corp-DC01` using the [Batch 1 VM baseline](../01-Enterprise-Planning/device-inventory.md#fresh-build-vm-baseline): 4096 MB RAM, 2 vCPU, approximately 80 GB VDI, and Adapter 1 attached to **NAT Network / Corp-Core** with cable connected. The recorded build uses EFI disabled and TPM None; other uninspected VM choices retain their existing verification status.
3. Attach Windows Server 2022 installation media, start the VM, and boot from the virtual optical drive. Select the recorded English language/UK keyboard and **Windows Server 2022 Standard Evaluation (Desktop Experience)** when the media offers an edition choice. Product-key or licensing prompts depend on the reader's media; no key is supplied.
4. Accept the applicable license terms, choose **Custom** installation, and select the fresh approximately 80 GB system disk. Allow setup to create its required partitions. Exact original partition sizes were not recorded; do not copy snapshot disks or assume a partition layout from a screenshot.
5. Finish setup, set a reader-chosen `<local-Administrator-password>`, and sign in as the local Administrator. Remove installation media when installation has finished so subsequent boots use the system disk. Microsoft's [Windows Server media-installation guide](https://learn.microsoft.com/en-us/windows-server/get-started/install-windows-server) covers the setup controls.

### 2. Rename and set static IPv4

1. Open **Server Manager > Local Server**, select the computer-name link, choose **Change**, enter `Corp-DC01`, and restart when prompted. Sign in locally again.
2. Run `ncpa.cpl`, identify the enabled adapter connected to `Corp-Core`, open its **Properties**, select **Internet Protocol Version 4 (TCP/IPv4)**, and open **Properties**. Adapter display names are environment dependent; do not assume a particular name such as Ethernet.
3. Select **Use the following IP address** and **Use the following DNS server addresses**; enter the table below and confirm the dialogs.

| Setting | Required/verified value |
|---|---|
| IPv4 address | `10.10.20.10` |
| Subnet mask / prefix | `255.255.255.0` / `/24` |
| Default gateway | `10.10.20.1` |
| Preferred DNS | `10.10.20.10` |
| Alternate DNS | No alternate value established; this procedure leaves it blank |

The preferred DNS points to the server's own intended DNS service, matching the verified final design. Before that role is installed, DNS queries to it may fail; do not treat that as evidence that the static address is wrong or substitute a public resolver for domain DNS. The original alternate-DNS field was not recorded.

Run `hostname` and `ipconfig /all` in Command Prompt and confirm `Corp-DC01`, static IPv4, mask, gateway, and preferred DNS. At this point the computer is not yet a domain controller. If pfSense guest configuration is incomplete, use the browser on DC01 for [initial pfSense WebGUI access](pfsense.md#3-reach-initial-webgui-management), finish that setup, and then return here. This provides management without introducing another VM or changing the lab architecture.

### 3. Install AD DS/DNS and create the forest

1. As local Administrator, open **Server Manager > Manage > Add Roles and Features**. Choose **Role-based or feature-based installation**, select `Corp-DC01`, add **Active Directory Domain Services** and **DNS Server**, accept the associated management tools, and install. Review completion before proceeding; do not add the Windows DHCP Server role, which is verified not installed in this lab.
2. Use Server Manager's notification flag and select **Promote this server to a domain controller**. Choose **Add a new forest** and enter root domain `corp.internal`.
3. On **Domain Controller Options**, select **Windows Server 2016** for both forest and domain functional levels, matching the verified `Windows2016Forest` / `Windows2016Domain`. Keep **DNS Server** and **Global Catalog** selected. This is a writable first DC, not an RODC. Enter your own `<DSRM-password>` and its confirmation.
4. Review **DNS Options**. This guide does not configure an unrecorded parent-zone delegation. If a warning about creating a delegation appears, read it in the context of the new private forest; do not enter a guessed parent DNS server.
5. On **Additional Options**, confirm the NetBIOS name is `CORP`. Review the database, log, and SYSVOL paths: their historical selections were not recorded. Default paths are a fresh-build reader choice, not verified original locations.
6. Review the configuration and prerequisite results, resolve blocking errors, then select **Install**. Allow the promotion restart to complete. Sign in using `CORP\Administrator` and the password set for this new installation; the repository does not supply that password.

Microsoft's [AD DS installation reference](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/deploy/install-active-directory-domain-services--level-100-) describes the role-installation and promotion controls. These steps create the domain only; detailed OU/group, DNS reverse-zone, and GPO work remains in the linked topic guides.

### 4. Post-promotion checkpoints and handoff

After services have started, recheck IPv4 properties and ensure preferred DNS is `10.10.20.10`, including if promotion changed the displayed DNS address. Use an elevated PowerShell window for the checks below; the Command Prompt commands also run from PowerShell.

| Check | Expected result |
|---|---|
| `hostname`; `ipconfig /all` | `Corp-DC01`; static `10.10.20.10/24`, gateway `10.10.20.1`, preferred DNS `10.10.20.10` |
| `Get-WindowsFeature AD-Domain-Services,DNS,DHCP` | AD DS and DNS Installed; DHCP Server not installed |
| `Get-Service NTDS,DNS,Netlogon` | All three services Running |
| `Get-ADDomain \| Select-Object DNSRoot,NetBIOSName,DomainMode` | `corp.internal`, `CORP`, `Windows2016Domain` |
| `Get-ADForest \| Select-Object RootDomain,ForestMode` | `corp.internal`, `Windows2016Forest` |
| `nslookup corp.internal 10.10.20.10`; `nslookup Corp-DC01.corp.internal 10.10.20.10` | Both resolve to `10.10.20.10` |
| `dcdiag`; `dcdiag /test:dns` | Review for successful core AD/DNS tests; investigate failures before joining other machines |

An initial DNS-server name of Unknown in `nslookup` can precede the later reverse-zone/PTR setup; evaluate the returned answer rather than assuming a missing PTR means forward DNS failed. The historical `::1` timeout and WinRM WSMAN SPN warning remain documented below and are not claimed resolved by this procedure. `ping 10.10.20.1` is an optional local gateway diagnostic, not a replacement for AD/DNS checks or proof that every firewall rule permits ICMP.

Proceed to [FS01](file-server.md#build-from-zero) and the [AD configuration guide](../04-Active-Directory/active-directory-installation.md) once DC identity, roles, services, and forward DNS are correct. Follow the [DNS guide](../04-Active-Directory/dns.md) for later reverse-zone/PTR work and the [README build path](../README.md#build-from-zero) for the remaining stages.

Unrecorded details remain reader choices or later verification items: exact ISO/build and partition layout, product keys and passwords, database/log/SYSVOL paths, alternate DNS, current live disk/firmware options, and patch state beyond the existing recorded KBs. No AD object inventory, GPO, backup, or time-service configuration is changed by these instructions.

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

The current OS build number and activation state remain **To verify**. Installed KBs and post-update checks are recorded below.

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

Memory, CPU, and the `Corp-Core` attachment were live verified on 2026-10-06. Other values remain historical build details requiring current verification. See the [environment](../00-Project-Overview/environment.md#virtual-storage-and-snapshots---verified-2026-10-06) for verified VDI, Guest Additions, and snapshot state.

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
| Forest functional level | `Windows2016Forest`; verified 2026-10-06 |
| Domain functional level | `Windows2016Domain`; verified 2026-10-06 |

Verification on 2026-10-06 confirmed the Windows Server 2016 forest/domain functional levels above for `corp.internal` (NetBIOS `CORP`), resolving the older conflicting records.

## DHCP role and static addressing verification - 2026-10-06

On Corp-DC01, `Get-WindowsFeature DHCP` showed the DHCP Server role as **Available**, not **Installed**. The Windows DHCP Server role is not running. IPv4 remained `10.10.20.10` with **DHCP Enabled: No**, confirming static IPv4 configuration on Corp-Core. See [DHCP verification](../04-Active-Directory/dhcp.md).

## DNS configuration

`Corp-DC01` hosts DNS for `corp.internal` and uses `10.10.20.10` as its preferred DNS server. `Corp-CL01` is also observed using `10.10.20.10` for DNS.

Verification on 2026-09-20 confirmed running AD-integrated forward zones `_msdcs.corp.internal` and `corp.internal` and the inspected domain/DC/client/file-server host records. No explicit DNS forwarders are configured or were added; external resolution works. An AD-integrated Primary reverse zone `20.10.10.in-addr.arpa` was created for `10.10.20.0/24`, with replication to all DNS servers on domain controllers in `corp.internal` and secure dynamic updates only. A PTR for `10.10.20.10` -> `Corp-DC01.corp.internal` was created and verified. Other zone properties, aging/scavenging, and logging remain **To verify**. See [Active Directory DNS](../04-Active-Directory/dns.md).

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

During later firewall testing, `Corp-DC01` temporarily classified its network as `Private` rather than `DomainAuthenticated`. DNS and Netlogon services were running, and `nltest /dsgetdc:corp.internal` succeeded. A normal restart restored `DomainAuthenticated`; client-to-DC ping and DNS resolution then worked normally. The exact cause was not established, so this is recorded only as a troubleshooting observation.

## Recorded build issues

The original build guide records these issues and resolutions:

- A VPN interrupted the Windows Server download; the download succeeded after the VPN was disabled.
- A blue screen occurred during initial installation; the VM restarted and completed installation.
- DNS lookup was delayed immediately after promotion while services initialized.
- Windows displayed an unexpected shutdown reason prompt after installation.

## DNS verification - 2026-09-20

On `Corp-DC01`, `nslookup google.com` returned external IPv4 and IPv6 records after an initial timeout using local resolver `::1`; `nslookup google.com 10.10.20.10` succeeded without the initial timeout. No cause was proven. `dcdiag /test:dns /v` reported that `corp.internal` passed test DNS, with `Corp-DC01` PASS for Auth, Basc, Forw, Del, Dyn, and RReg; the root-server tests shown also passed. These checks verify core AD/DNS functionality within the tested scope and do not resolve the earlier WinRM WSMAN SPN warning or establish an exhaustive DNS audit.

## AD verification and controlled improvements - 2026-10-06

Standard `dcdiag` completed successfully; all reported tests passed and no failed tests were observed. All five FSMO roles were reconfirmed on `Corp-DC01.corp.internal`. The single-DC topology has no replication partners, as expected, and no configured AD trusts. The earlier WinRM WSMAN SPN warning remains a historical observation pending targeted investigation.

During the supplied live work, `10.10.20.0/24` and `10.10.30.0/24` were registered to `Default-First-Site-Name`, and AD Recycle Bin was enabled for `corp.internal`. PowerShell verification confirmed both subnet associations and populated Recycle Bin `EnabledScopes`. A temporary-account restore test succeeded and the test account was deleted afterward. See [AD configuration](../04-Active-Directory/active-directory-installation.md) and [Account Recovery](../06-Helpdesk/account-recovery.md). This update records those improvements without changing live configuration.

## Patch and post-update verification - 2026-10-06

`Corp-DC01` was previously at a March 2022 patch baseline and updated successfully on 2026-10-06. It now shows `KB5122881`, `KB5122882`, and `KB5126050`. After updating, `dcdiag /test:dns` passed; DNS, Netlogon, and NTDS services were running. AD/DNS remained operational.

During cumulative-update servicing, the VM became extremely sluggish, with TiWorker active and Defender consuming substantial memory. Resource pressure/update servicing is the observed context; no definitive root cause was established. The update completed and post-update AD/DNS checks passed. See the [issue register](../09-Documentation/known-issues.md#perf-01-dc01-sluggishness-during-update-servicing).

## To verify

- Current Windows Server build and activation; patch state beyond the installed KBs verified above
- Current VM disk capacity/allocation, firmware, and uninspected settings beyond the verified CPU, memory, attachment, and VDI/snapshot baseline
- DNS settings and records beyond the verified scope, including forward-zone replication/update settings, aging/scavenging, logging, and the initial `::1` timeout
- Backup, recovery beyond the tested Recycle Bin restore, time synchronization, and monitoring configuration
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
