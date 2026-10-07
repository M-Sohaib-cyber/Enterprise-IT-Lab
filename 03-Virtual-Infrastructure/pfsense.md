# Corp-FW01 pfSense Deployment

## Purpose

`Corp-FW01` is the pfSense firewall and router for the Enterprise IT Lab. It provides WAN connectivity, network address translation, gateways for the internal networks, and routing between the server and client segments.

This document records the configuration supported by current repository documentation and evidence. Items requiring a live configuration check are marked **To verify**.

## Build from zero

The steps below implement the recorded design; they are instructions for a fresh build, not a new live verification. Required addresses and attachments come from the repository. Passwords and unrecorded setup options are reader choices. Complete the [Batch 1 prerequisites](../00-Project-Overview/environment.md#prerequisites-for-a-fresh-build) and compare your host's configuration with the [verified NAT Network baseline](../02-Network-Design/network-plan.md#nat-network-gateway-verification-checkpoint) first. The displayed `.1` gateways match the tested working lab and are not themselves a reason to stop assigning the documented pfSense addresses.

### 1. Prepare and install Corp-FW01

1. Create `Corp-FW01` using the [fresh-build VM baseline](../01-Enterprise-Planning/device-inventory.md#fresh-build-vm-baseline): 2048 MB RAM, 2 vCPU, and approximately 20 GB VDI. Use the verified host baseline, Oracle VirtualBox 7.1.12; other releases have not been specifically tested for this lab.
2. With the VM powered off, use **Settings > Network** to enable Adapter 1 as **NAT**, Adapter 2 as **NAT Network / Corp-Core**, and Adapter 3 as **NAT Network / Corp-Clients**. Check **Cable Connected** and record each adapter's MAC address for interface identification. Keep VirtualBox DHCP disabled on both named networks.
3. Attach the pfSense installation media to the virtual optical drive and boot it. The historical build used Netgate Installer and pfSense CE 2.8.1. Select installation rather than configuration recovery. If the online installer requests network setup, identify Adapter 1 by MAC as WAN and select IPv4 DHCP so packages can be downloaded through VirtualBox NAT.
4. Select the CE release matching the recorded 2.8.1 installation where available. A different available release is a reader choice requiring retesting; do not silently describe it as the historical version.
5. Select the fresh 20 GB guest disk as the installation target. Match the recorded ZFS filesystem, GPT partition scheme, and single-disk Stripe layout. Review the disk before confirming installation. Keyboard, swap size, ZFS pool name, firmware/boot options, and other installer selections were not recorded; document your choices instead of treating defaults as verified.
6. Complete installation, remove the virtual installation media, and boot from the VDI. Check the console's reported version and interfaces. Netgate's [installation walkthrough](https://docs.netgate.com/pfsense/en/latest/install/install-walkthrough.html) explains installer screens; its current defaults are not evidence of the original build's choices.

### 2. Assign interfaces and configure LAN

1. In the installed system's console, use **Assign Interfaces** (normally option 1). Identify the three devices by their VirtualBox MAC addresses: Adapter 1 is WAN, Adapter 2 is LAN, and Adapter 3 is OPT1. The recorded names are `em0`, `em1`, and `em2`; hardware-dependent names on a fresh build may differ. The documented design uses the direct adapters without a required VLAN setup.
2. Use **Set interface(s) IP address** (normally option 2) to configure WAN IPv4 as DHCP. The original WAN lease was `10.0.2.15/24`, gateway `10.0.2.2`; verify what VirtualBox NAT supplies rather than assigning the observed lease statically.
3. Set LAN IPv4 to `10.10.20.1` with prefix length `24`. LAN is an internal interface, so do not enter an upstream gateway for it; the firewall's upstream path is WAN.
4. If prompted about LAN DHCP, this fresh-build procedure uses **No** and the static DC01 management address below. This is a bootstrap workflow choice, not verification that the original pfSense LAN DHCP service was disabled. Its historical state and LAN IPv6 configuration remain unrecorded; no LAN DHCP scope is assumed.
5. Keep HTTPS management when the console offers a switch to HTTP. This is the guide's management method, not a claim that a historical WebGUI protocol/port was inspected. Confirm the console displays LAN `10.10.20.1/24` before continuing.

See Netgate's [console menu reference](https://docs.netgate.com/pfsense/en/latest/config/console-menu.html) for the controls. WAN IPv6 DHCP6 with `/64` prefix delegation was recorded in the earlier interface review below; that observation does not establish all IPv6 settings or public IPv6 connectivity.

### 3. Reach initial WebGUI management

1. Use `Corp-DC01` on `Corp-Core` as the management guest: complete its [Windows installation](windows-server-build-guide.md#1-create-the-vm-and-install-windows-server) and [static-address steps](windows-server-build-guide.md#2-rename-and-set-static-ipv4), stopping before AD promotion. Its address is `10.10.20.10/24`, gateway `10.10.20.1`. This bootstrap order uses an existing lab VM and does not add a permanent management machine.
2. From DC01's browser, open `https://10.10.20.1`. An IP-based connection does not need the domain DNS service, which has not yet been installed. Check the address and firewall identity before proceeding past a self-signed certificate warning. The original management certificate was not recorded.
3. Sign in using the installed system's initial WebGUI credentials. For a fresh factory installation, consult Netgate's [documented initial credentials](https://docs.netgate.com/pfsense/en/latest/usermanager/defaults.html); do not assume an existing lab VM still uses them. Choose your own `<pfSense-admin-password>` in the setup wizard.
4. Complete the wizard while retaining WAN IPv4 DHCP and LAN `10.10.20.1/24`. The pfSense system hostname/domain, firewall DNS resolver settings, NTP/time-zone choices, WAN private-network/bogon options, and original administrator credentials were not recorded. Record reader choices and investigate any connectivity issue rather than inventing the original settings. `Corp-FW01` is the documented VM identity; `corp.internal` is the AD domain and client DHCP suffix, not proof of the firewall's own configured domain.

Netgate's [GUI connection guidance](https://docs.netgate.com/pfsense/en/latest/config/index.html) and [setup wizard reference](https://docs.netgate.com/pfsense/en/latest/config/setup-wizard.html) explain these controls. Initial management is from the LAN guest, not an assumed host-to-NAT Network connection or an OPT1 connection before its rules exist.

### 4. Enable OPT1 and configure client DHCP

1. Open **Interfaces > Assignments**. If the third device is not assigned, add the Adapter 3 device as OPT1. Open **Interfaces > OPT1**, enable it, select **Static IPv4**, and enter `10.10.30.1/24`. Use **None** for IPv6 Configuration Type, matching the verified 2026-10-07 setting. Do not select an upstream IPv4 gateway for this internal interface. Save and apply.
2. Under **System > Advanced > Networking**, select the **ISC DHCP** server backend if needed to match the verified backend. This is the recorded lab baseline, not a claim that later releases provide the same backend. If the selected release no longer supports it, record that deviation for review. See Netgate's [DHCP backend reference](https://docs.netgate.com/pfsense/en/latest/services/dhcp/index.html).
3. Open **Services > DHCP Server > OPT1**, enable DHCP for OPT1, and enter the settings below. Save/apply and re-open the page to check the values. The subnet is derived from the interface address, not a separate Windows DHCP scope.

| DHCP setting | Required/verified value |
|---|---|
| Network / mask | `10.10.30.0/24` / `255.255.255.0` |
| Range start / end | `10.10.30.100` / `10.10.30.199` |
| DNS server | `10.10.20.10` |
| Gateway supplied to clients | `10.10.30.1` |
| Domain name | `corp.internal` |
| Default / maximum lease | 7200 / 86400 seconds |
| Static mappings | None |

Enter `10.10.30.1` explicitly in the gateway field for this procedure. The original supplied client gateway is verified, but the repository does not establish whether the original field was explicit or blank with the interface address supplied automatically. Do not create a reservation for the observed CL01 lease. Keep the other [verified DHCP settings](../04-Active-Directory/dhcp.md#verified-opt1-configuration---2026-10-06) as recorded; uninspected fields/exclusions remain unverified. Netgate's [DHCPv4 reference](https://docs.netgate.com/pfsense/en/latest/services/dhcp/ipv4.html) explains the fields. DNS at `10.10.20.10` becomes usable after DC01 promotion.

### 5. Establish initial client connectivity

The historical build first used a broad OPT1 IPv4 pass rule before applying the final ordered policy. For an isolated fresh build with no OPT1 pass rules, open **Firewall > Rules > OPT1**, add a **Pass** rule with address family **IPv4**, protocol **Any**, source **OPT1 subnets**, and destination **Any**, then save and apply. A temporary description is a reader choice. This is a bootstrap rule, not the final security state; do not insert it ahead of an already hardened ruleset.

Before final verification, replace the bootstrap policy with the [documented ordered OPT1 rules](../08-Security/firewall-rules.md#current-evidenced-opt1-rule-design) and verify the recorded allow/block results. The final DC allow rule's exact protocol/port fields remain unverified, so this bootstrap procedure does not claim to establish them. Detailed final hardening remains in the security guide.

### 6. Build checkpoints

| Stage | Check | Proceed when |
|---|---|---|
| Console setup | Inspect WAN/LAN/OPT1 assignments against recorded MACs | WAN uses Adapter 1/NAT; LAN and OPT1 use the correct named networks; LAN/OPT1 addresses are `10.10.20.1/24` and `10.10.30.1/24` |
| Management | Open `https://10.10.20.1` from DC01 | WebGUI sign-in works over LAN; continue/return to DC01 promotion |
| Routing baseline | Inspect **Firewall > NAT > Outbound** | Mode is **Automatic outbound NAT rule generation**, matching the verified design; no manual generated-rule values are assumed |
| DHCP readiness | Inspect OPT1 DHCP configuration | Service is enabled with the table values; lease testing follows when CL01 exists |
| Client networking, after DC01 is ready | On CL01 run `ipconfig /all`, `ping 10.10.20.10`, `nslookup corp.internal`, and `ping 8.8.8.8`; inspect **Status > DHCP Leases** | Client receives the intended subnet/gateway/DNS; DC and internet checks succeed before domain joining |
| Final security handoff | Run the [firewall test matrix](../08-Security/firewall-rules.md#connectivity-from-corp-cl01) after hardening and file-service setup | DC/DNS and SMB work; ping from CL01 to FS01 is blocked as intended |

If management or routing fails, inspect adapter assignments, link state, rule placement, and differences from the verified NAT Network baseline before continuing. The checkpoints are expected fresh-build results, not additional historical test claims. No exact current WAN lease, generated NAT rule export, full WAN/LAN ruleset, management certificate, or uninspected IPv6 policy is inferred.

## Virtual machine record

| Setting | Recorded value |
|---|---|
| VM name | `Corp-FW01` |
| Platform | Oracle VirtualBox |
| Guest type | FreeBSD 64-bit |
| Software | pfSense CE 2.8.1 |
| CPU | 2 vCPU |
| Memory | 2 GB |
| Storage | 20 GB dynamic VDI |

CPU (2 vCPU) and memory (2048 MB) were verified on 2026-10-06; see the [device inventory](../01-Enterprise-Planning/device-inventory.md#virtualbox-baseline---verified-2026-10-06). Current pfSense version and other uninspected build settings remain to verify.

## Recorded VirtualBox adapters

| Adapter | Recorded attachment | Purpose |
|---|---|---|
| Adapter 1 | VirtualBox NAT | WAN/internet access |
| Adapter 2 | NAT Network named `Corp-Core` | Server network |
| Adapter 3 | NAT Network named `Corp-Clients` | Client network |

The existing adapter order above is retained from the deployment record. Verification on 2026-10-06 confirmed the NAT WAN + `Corp-Core` + `Corp-Clients` attachments; no additional adapter details are newly claimed. Network Manager verification on 2026-10-06 confirmed both lab NAT Network prefixes and disabled VirtualBox DHCP on each; see [DHCP verification](../04-Active-Directory/dhcp.md).

## Interfaces

| pfSense interface | Virtual adapter | Network | Address |
|---|---|---|---|
| WAN | `em0` | VirtualBox NAT | DHCP; `10.0.2.15/24`; gateway `10.0.2.2` |
| LAN | `em1` | `Corp-Core` | `10.10.20.1/24` |
| OPT1 | `em2` | `Corp-Clients` | `10.10.30.1/24` |

Live verification on 2026-09-16 confirmed WAN `em0`, LAN `em1` at `10.10.20.1/24`, and OPT1 `em2` at `10.10.30.1/24`.

Authoritative lab addressing is maintained in [IP Addressing, DHCP, and DNS](../02-Network-Design/ip-addressing.md).

### Interface review - 2026-09-20

- WAN IPv4 configuration type: DHCP; address `10.0.2.15/24`; gateway `10.0.2.2`.
- WAN IPv6 configuration type: DHCP6; an address in `fd17:.../64` and an IPv6 link-local address were observed. DHCPv6 prefix delegation size is `/64`. The full IPv6 addresses were not supplied.
- LAN IPv4 address: `10.10.20.1/24`; only an IPv6 link-local address (`fe80::...`) was observed.
- OPT1 IPv4 address: `10.10.30.1/24`; only an IPv6 link-local address (`fe80::...`) was observed.

The implemented server/client design and firewall segmentation are IPv4-based. No routed IPv6 addressing was observed on LAN or OPT1. The WAN address is within `fd00::/8` (Unique Local IPv6), which is not evidence of globally routed public IPv6 connectivity. No IPv6 configuration change was made, and IPv6 is not documented as fully disabled. All other unspecified IPv6 settings remain **To verify**. A comprehensive IPv6 security review remains open beyond these observations.

### Interface review - 2026-10-07

OPT1 **IPv6 Configuration Type** is set to **None**. The lab is intentionally IPv4-focused; no pfSense configuration changes were required during this review.

## Outbound NAT verification - 2026-09-20

Outbound NAT mode is **Automatic outbound NAT rule generation**. `Corp-CL01` retains working internet connectivity through pfSense. No NAT configuration change was required.

## Installation record

The repository records the following installation choices:

- Netgate Installer used to install pfSense CE 2.8.1
- ZFS filesystem
- GPT partition scheme
- Stripe virtual device on the 20 GB virtual disk
- WAN assigned to `em0`, LAN to `em1`, and OPT1 to `em2`
- Installation media removed before the first normal reboot

These values describe the recorded build. A live export or current console capture is not present for every setting.

## Integration with the lab

| System | Addressing relationship |
|---|---|
| `Corp-DC01` | Static `10.10.20.10/24`; gateway `10.10.20.1`; DNS `10.10.20.10` |
| `Corp-CL01` | Observed `10.10.30.100/24`; gateway `10.10.30.1`; DNS `10.10.20.10` |

`Corp-DC01` provides DNS for `corp.internal`. pfSense routes traffic between the documented network segments and provides WAN access.

## Verified DHCP configuration

Live verification on 2026-09-16 confirmed pfSense DHCP enabled on OPT1 (`10.10.30.1`), with pool `10.10.30.100-10.10.30.199`. This resolves the older record stating OPT1 DHCP was disabled and agrees with the client evidence.

Verification on 2026-10-06 confirmed pfSense ISC DHCP on OPT1, the supplied gateway/DNS/domain options, 7200/86400-second default/maximum leases, and no OPT1 static mappings. Corp-CL01 successfully released/renewed 10.10.30.100; this observed address is not permanently reserved. VirtualBox DHCP is disabled on NAT Networks Corp-Core (10.10.20.0/24) and Corp-Clients (10.10.30.0/24). Corp-DC01 remains static at 10.10.20.10 with DHCP disabled and the Windows DHCP Server role Available, not Installed. Exclusions and uninspected settings remain to verify. See [DHCP verification](../04-Active-Directory/dhcp.md).

## OPT1 firewall rules

The repository records that `Corp-CL01` initially obtained an address but could not reach pfSense, `Corp-DC01`, or the internet because OPT1 had no pass rule. A broad pass rule restored connectivity and was later replaced by an ordered design for OPT1 (`10.10.30.0/24`):

- Allow OPT1 subnets to `Corp-DC01` (`10.10.20.10`).
- Allow OPT1 subnets to `Corp-FS01` (`10.10.20.20`) on TCP 445 / Microsoft-DS only.
- Block OPT1 subnets from the LAN/server network (`10.10.20.0/24`).
- Allow OPT1 subnets to any destination after the LAN block to preserve other required traffic, including internet access.

This rule order was verified on 2026-09-20, with packet logging enabled on the LAN block rule. Rule order is material: the two required server exceptions precede the LAN block, and the general allow follows it. The final allow remains broad for traffic not matched by the preceding rules; the verified server-network segmentation does not establish that the entire firewall is fully hardened or least privilege. No firewall rule is changed by this documentation update.

See [Firewall Rules](../08-Security/firewall-rules.md).

## Documented verification

Existing documentation records successful checks for:

- Reachability of the relevant pfSense gateway
- Communication between `Corp-CL01` and `Corp-DC01`
- DNS resolution through `10.10.20.10`
- Internet connectivity after the OPT1 pass rule was added
- General access to `Corp-FS01` blocked, demonstrated by failed ping
- SMB access to `Corp-FS01` over TCP 445 and Jhon's `I:` and `P:` drive mappings after Group Policy refresh

Final verification on 2026-09-20 confirmed outbound NAT mode and continued client internet access. Packet logging was enabled specifically on the existing **Block OPT1 to Server Network** rule, which previously had per-rule logging disabled. A ping from `Corp-CL01` (`10.10.30.100`) to `Corp-FS01` (`10.10.20.20`) was blocked, and fresh ICMP block entries were confirmed in `/var/log/filter.log`. The GUI continued to show older 2026-09-16 entries; its display issue remains unresolved. See [Firewall Rules](../08-Security/firewall-rules.md) for the test and logging settings.

Final review on 2026-10-07 confirmed that the live OPT1 firewall ruleset matches the documented hardened ruleset and that logging is enabled on **Block OPT1 to Server Network**. Firewall aliases are currently not configured and are intentionally unused for this small lab. Existing IPv4 NAT and internet connectivity had already been verified. No pfSense configuration changes were required during this review. See [final firewall verification](../08-Security/firewall-rules.md#final-verification---2026-10-07).

The repository does not contain a current pfSense configuration export. Individual generated NAT rules, DNS resolver settings, fields beyond the recorded OPT1 design, and the complete WAN/LAN rulesets remain **To verify**. Remote syslog is not configured; broader monitoring is not complete.

## Evidence

- [OPT1 firewall rule screenshot](../Screenshots/Security/01-pfSense-firewall%20rules.png)
- [Corp-CL01 IP configuration](../Screenshots/Verifications/01-Corp-CL01%20ipconfig.png)

## Related documentation

- [Current network topology](../02-Network-Design/network-topology.md)
- [IP addressing, DHCP, and DNS](../02-Network-Design/ip-addressing.md)
- [DHCP](../04-Active-Directory/dhcp.md)
- [Firewall rules](../08-Security/firewall-rules.md)
