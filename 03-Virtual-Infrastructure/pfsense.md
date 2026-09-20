# Corp-FW01 pfSense Deployment

## Purpose

`Corp-FW01` is the pfSense firewall and router for the Enterprise IT Lab. It provides WAN connectivity, network address translation, gateways for the internal networks, and routing between the server and client segments.

This document records the configuration supported by current repository documentation and evidence. Items requiring a live configuration check are marked **To verify**.

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

The current pfSense version and VM resource allocation should be verified from the live VM before they are treated as an inventory export.

## Recorded VirtualBox adapters

| Adapter | Recorded attachment | Purpose |
|---|---|---|
| Adapter 1 | VirtualBox NAT | WAN/internet access |
| Adapter 2 | NAT Network named `Corp-Core` | Server network |
| Adapter 3 | NAT Network named `Corp-Clients` | Client network |

These attachment settings come from the existing deployment record. Current VirtualBox network and DHCP settings remain **To verify**.

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

Server-side options, exclusions, reservations, and lease duration remain **To verify**. See [DHCP](../04-Active-Directory/dhcp.md).

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

The repository does not contain a current pfSense configuration export. Individual generated NAT rules, aliases, DNS resolver settings, fields beyond the recorded OPT1 design, and the complete WAN/LAN rulesets remain **To verify**. Remote syslog is not configured; broader monitoring is not complete.

## Evidence

- [OPT1 firewall rule screenshot](../Screenshots/Security/01-pfSense-firewall%20rules.png)
- [Corp-CL01 IP configuration](../Screenshots/Verifications/01-Corp-CL01%20ipconfig.png)

## Related documentation

- [Current network topology](../02-Network-Design/network-topology.md)
- [IP addressing, DHCP, and DNS](../02-Network-Design/ip-addressing.md)
- [DHCP](../04-Active-Directory/dhcp.md)
- [Firewall rules](../08-Security/firewall-rules.md)
