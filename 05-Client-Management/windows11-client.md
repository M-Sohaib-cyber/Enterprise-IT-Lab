# Corp-CL01 Windows 11 Client

## Purpose and status

`Corp-CL01` is the Windows 11 workstation used to verify client networking, domain authentication, file access, user workflows, and Group Policy in the `corp.internal` domain.

The client is documented as domain joined and operational. This document distinguishes recorded build details from values visible in current evidence.

## Build from zero

This procedure builds the client against the documented network/domain design. It preserves the existing history and verification sections below and does not claim a new live test. Complete [pfSense interfaces, DHCP, and initial connectivity](../03-Virtual-Infrastructure/pfsense.md#build-from-zero) and [DC01 promotion/verification](../03-Virtual-Infrastructure/windows-server-build-guide.md#build-from-zero) first. The later [AD structure stage](../04-Active-Directory/users-and-groups.md) provides the user accounts and `Workstations` OU used for final placement and user testing.

### 1. Create the VM and install Windows 11

1. Create `Corp-CL01` using the [Batch 1 baseline](../01-Enterprise-Planning/device-inventory.md#fresh-build-vm-baseline): 4096 MB RAM, 2 vCPU, and an approximately 80 GB system VDI as the guide's rebuild target. The original live disk capacity remains unverified. Match the recorded EFI enabled, Secure Boot enabled, TPM 2.0, VBoxSVGA, and 128 MB video-memory settings; these are recorded build values, not newly inspected VM settings.
2. With the VM powered off, enable Adapter 1 as **NAT Network / Corp-Clients**, check **Cable Connected**, and attach Windows 11 installation media to the virtual optical drive. VirtualBox DHCP must remain disabled on this NAT Network. Complete the [NAT service gateway checkpoint](../02-Network-Design/network-plan.md#nat-network-gateway-verification-checkpoint) before relying on pfSense OPT1's address.
3. Boot the media and follow Windows Setup for a fresh installation to the new system disk. Use Windows 11 Enterprise Evaluation to match the recorded edition. Product-key prompts, disk partitioning, language/keyboard, and the exact media build depend on the supplied ISO; no original choices are inferred for those screens.
4. Complete the initial setup/OOBE using choices and an initial administrative account supported by that edition/media. The historical initial account, local-versus-online setup path, privacy options, and any setup workarounds were not recorded. Use reader-supplied credentials; no undocumented bypass or account name is prescribed. If setup requires internet, pfSense's bootstrap connectivity must already be available, with working DNS from DC01.
5. Finish installation, remove the virtual media, and sign in with the initial account that can administer this guest. Microsoft's [Windows installation-media guide](https://support.microsoft.com/en-us/windows/deployment/install-upgrade/reinstall-windows-with-the-installation-media) explains the setup controls; screen wording varies by Windows build. Joining `corp.internal` is the later explicit step below, not an assumed result of OOBE.

### 2. Rename and verify DHCP addressing

1. Run `sysdm.cpl`, open **Computer Name > Change**, enter `Corp-CL01`, confirm, and restart. The VM name in VirtualBox does not itself rename Windows; the original generated name is historical only.
2. Sign in again, run `ncpa.cpl`, and open the enabled adapter's **Properties > Internet Protocol Version 4 (TCP/IPv4) > Properties**. Select **Obtain an IP address automatically** and **Obtain DNS server address automatically** so pfSense supplies both. Confirm the dialogs.
3. In Command Prompt run `ipconfig /all`. If a lease is missing or stale, run `ipconfig /release` followed by `ipconfig /renew`, then inspect it again. Compare with the table below and with **Status > DHCP Leases** in pfSense; the MAC should match this new VM's adapter, not necessarily the original screenshot's MAC.

| Item | Expected design / historical observation |
|---|---|
| IPv4 subnet / mask | `10.10.30.0/24` / `255.255.255.0` |
| Lease pool | `10.10.30.100-10.10.30.199` |
| DHCP enabled | Yes |
| Gateway / DHCP server | `10.10.30.1` |
| DNS server | `10.10.20.10` |
| Connection-specific DNS suffix | `corp.internal` |
| Observed original client lease | `10.10.30.100`; not a reservation or a guaranteed fresh-build lease |

Do not set `10.10.30.100` statically or create a DHCP reservation to reproduce an observation. Another address in the documented pool is valid for a fresh client. A `169.254.*` address is not a valid completed lab lease; check adapter attachment/cable, pfSense OPT1 enablement, DHCP service, and the gateway checkpoint before proceeding. Do not enable VirtualBox DHCP as a workaround.

### 3. Check DC connectivity and join corp.internal

While DC01 and pfSense are running, use Command Prompt on CL01:

```cmd
ping 10.10.20.10
nslookup corp.internal 10.10.20.10
nslookup Corp-DC01.corp.internal 10.10.20.10
nslookup -type=SRV _ldap._tcp.dc._msdcs.corp.internal 10.10.20.10
```

DC ping and DNS access are permitted by the documented OPT1 design. The host/domain answers should be `10.10.20.10`, and the SRV query should identify the domain controller. Diagnose failures before joining: verify the client uses DC01 DNS, the DC's DNS/AD services are ready, and the OPT1 DC-access rule exists. Correct DNS answers can precede reverse DNS setup; an Unknown DNS-server display name alone is not a failed forward lookup. `ping 8.8.8.8` is the recorded internet checkpoint, separate from AD discovery.

1. As an administrator on CL01, run `sysdm.cpl`, open **Computer Name > Change**, select **Domain**, and enter `corp.internal`.
2. Supply `CORP\<authorized-domain-join-account>` and its reader-supplied password when prompted. The historical join used `CORP\Administrator`; using another authorized join account is a reader choice, not a new historical claim.
3. Wait for the domain confirmation, close the dialogs, and restart. Choose **Other user** at sign-in when available and use `CORP\<enabled-domain-user>` with that account's password. `jsmith` is the documented later test user once the AD user/group stage is complete; do not assume the account exists immediately after forest creation.
4. On DC01, open **Server Manager > Tools > Active Directory Users and Computers**, find `CORP-CL01` (initially often under **Computers**), right-click it, select **Move**, and choose the documented top-level `Workstations` OU. If the OU does not yet exist, complete the [OU structure stage](../04-Active-Directory/active-directory-installation.md#verified-ou-structure---2026-10-06) first. Move the computer before testing Workstations-linked GPOs; do not move DC01 from `Domain Controllers`.

Microsoft's [domain-join instructions](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/join-computer-to-domain) explain the join dialogs. OU/GPO creation and detailed user configuration remain in the later topic guides.

### 4. Post-join checkpoints and handoff

Run the PowerShell checks on CL01 after restarting. Use `whoami` in the intended domain user's session; membership of the computer and identity of the current user are separate facts.

| Check | Expected result |
|---|---|
| `hostname`; `ipconfig /all` | `Corp-CL01`; DHCP address in the client pool, gateway/DHCP `10.10.30.1`, DNS `10.10.20.10`; primary DNS suffix `corp.internal` after joining |
| `Get-CimInstance Win32_ComputerSystem \| Select-Object Name,Domain,PartOfDomain` | `Corp-CL01`, `corp.internal`, `True` |
| `nltest /dsgetdc:corp.internal` | DC discovery identifies `Corp-DC01` |
| `whoami` | `corp\<enabled-domain-user>` for the selected domain sign-in |
| ADUC computer-object location on DC01 | Enabled `CORP-CL01` in `Workstations` |

Proceed to [share/access testing](../03-Virtual-Infrastructure/file-server.md#documented-testing) and [GPO configuration/verification](../04-Active-Directory/group-policy.md) after membership, DNS, sign-in, and OU placement checks pass. Before shares and GPOs are configured, missing mapped drives are not an initial client build failure. Under the final firewall policy, CL01 ping to FS01 is intentionally blocked; later verify SMB using `Test-NetConnection 10.10.20.20 -Port 445` and the actual share/access tests instead.

Unknown historical details remain unguessed: exact media/current Windows build, initial account and OOBE route, passwords/product key, language/keyboard/privacy choices, partition layout, exact live system VDI capacity/allocation, and uninspected firmware/network settings. Fresh MACs and DHCP lease addresses are environment dependent. No user account, GPO, share ACL, or backup configuration is changed by these instructions.

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

Memory (4096 MB) and CPU (2 vCPU) were verified on 2026-10-06. Disk size, other uninspected VM settings, and adapter model are **To verify**. On 2026-10-06, Adapter 1 was verified enabled, attached to **NAT Network** named `Corp-Clients`, with cable connected and MAC `08:00:27:CC:6D:95`, matching the pfSense lease. VirtualBox DHCP is disabled on this NAT Network.

## Network configuration

The existing `ipconfig /all` screenshot records the values below. Live `ipconfig /all` verification on 2026-09-20 reconfirmed them, including host name `Corp-CL01` and primary DNS suffix `corp.internal`.

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

On 2026-10-06, `ipconfig /release` and successful `ipconfig /renew` returned `10.10.30.100` again. Post-renewal `ipconfig /all` confirmed DHCP enabled, IPv4 `10.10.30.100`, gateway and DHCP server `10.10.30.1`, DNS `10.10.20.10`, and connection-specific DNS suffix `corp.internal`. The pfSense lease showed hostname `Corp-CL01`, MAC `08:00:27:cc:6d:95`, and exactly 2 hours, matching the 7200-second default. No OPT1 static mapping exists, so the address is not permanently reserved or guaranteed. See [DHCP evidence and status](../04-Active-Directory/dhcp.md) for verified settings and remaining scope.

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

An OPT1 IPv4 Any-to-Any rule was added and connectivity was recorded as restored. It was subsequently hardened with ordered exceptions for `Corp-DC01` and TCP 445 to `Corp-FS01`, followed by a block for the rest of `10.10.20.0/24` and then an allow for other destinations. See [Firewall Rules](../08-Security/firewall-rules.md).

## Documented verification and use

Repository records describe successful:

- DHCP address acquisition
- DNS resolution using `10.10.20.10`
- Communication with `Corp-DC01`
- Domain join and domain authentication
- Internet access after the OPT1 rule was added
- User and computer GPO application
- Mapped-drive and file-access testing against `Corp-FS01`
- Failed ping to `Corp-FS01` while SMB over TCP 445 and the `I:` and `P:` mappings remained functional, demonstrating restricted general server access

These are preserved historical test results, not new tests performed during this documentation cleanup.

## Live verification - 2026-09-16

Computer and user `gpresult` checks confirmed the recorded policies applied to Corp-CL01 and Jhon Smith (`CORP\jsmith`). Jhon received I:/P: with F: absent after IT targeting was corrected; the recorded restrictions, wallpaper, 600-second inactivity value, update mode 3 and intentional IT local-administrator membership were verified.

The authoritative detailed application list, policy values and mapping results are retained in [Group Policy live verification](../04-Active-Directory/group-policy.md#live-verification---2026-09-16). Use that record and the [GPO inventory](../04-Active-Directory/gpo-inventory.md) rather than a second detailed status table here. These are historical results, not new live tests or configuration changes.

## DNS verification - 2026-09-20

Client tests confirmed DNS server `Corp-DC01.corp.internal` / `10.10.20.10`: `nslookup corp.internal` returned `10.10.20.10`; `nslookup Corp-FS01.corp.internal` returned `10.10.20.20`; and `nslookup 10.10.20.10` returned `Corp-DC01.corp.internal`. The client uses `Corp-DC01` for DNS and successfully performs these forward and reverse lookups. See [Active Directory DNS](../04-Active-Directory/dns.md) for the new server-network reverse zone/PTR and diagnostic results; these checks do not establish an exhaustive DNS audit.

## To verify

- Current Windows edition, version, build, activation, and patch state
- Current VM disk capacity/allocation, firmware, TPM, display, and uninspected network settings beyond the verified CPU, memory, VDI/snapshot baseline, Adapter 1 attachment, MAC, and cable state
- Current local accounts and local group membership beyond verified `GG_IT` administrator assignment
- Detailed resultant policy settings beyond the verified GPOs/settings

## Related documentation

- [Current network topology](../02-Network-Design/network-topology.md)
- [IP addressing, DHCP, and DNS](../02-Network-Design/ip-addressing.md)
- [DHCP evidence and status](../04-Active-Directory/dhcp.md)
- [Corp-DC01 build](../03-Virtual-Infrastructure/windows-server-build-guide.md)
- [Corp-FS01 file server](../03-Virtual-Infrastructure/file-server.md)
- [Group Policy](../04-Active-Directory/group-policy.md)
