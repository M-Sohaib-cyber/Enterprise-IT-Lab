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
| WAN | `em0` | VirtualBox NAT | DHCP; current address To verify |
| LAN | `em1` | `Corp-Core` | `10.10.20.1/24` |
| OPT1 | `em2` | `Corp-Clients` | `10.10.30.1/24` |

Authoritative lab addressing is maintained in [IP Addressing, DHCP, and DNS](../02-Network-Design/ip-addressing.md).

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

## DHCP evidence conflict

The original OPT1 setup record says the DHCP server was disabled. However, the `Corp-CL01` `ipconfig /all` screenshot reports:

- DHCP enabled: Yes
- DHCP server: `10.10.30.1`
- Client address: `10.10.30.100`
- Default gateway: `10.10.30.1`
- DNS server: `10.10.20.10`

Because `10.10.30.1` is also the documented OPT1 address, the client evidence and deployment narrative conflict. The current DHCP provider, pfSense service state, scope, exclusions, reservations, and lease configuration are all **To verify**. This documentation does not resolve the conflict by assumption.

See [DHCP](../04-Active-Directory/dhcp.md) for the evidence record.

## OPT1 firewall rule

The repository records that `Corp-CL01` initially obtained an address but could not reach pfSense, `Corp-DC01`, or the internet because OPT1 had no pass rule. An IPv4 Any-to-Any pass rule was then added on OPT1, after which connectivity was documented as restored.

The screenshot records an OPT1 IPv4 rule with protocol `Any` and the description `Allow OPT1 to Any`. The exact saved rule details should be confirmed from pfSense during later practical verification.

This permissive rule is a known practical security concern. It is documented as the current lab state and is not presented as a hardened or least-privilege policy. No firewall rule is changed here.

See [Firewall Rules](../08-Security/firewall-rules.md).

## Documented verification

Existing documentation records successful checks for:

- Reachability of the relevant pfSense gateway
- Communication between `Corp-CL01` and `Corp-DC01`
- DNS resolution through `10.10.20.10`
- Internet connectivity after the OPT1 pass rule was added

The repository does not contain a current pfSense configuration export. Rule order, NAT details, logs, aliases, DNS resolver settings, and the complete ruleset remain **To verify**.

## Evidence

- [OPT1 firewall rule screenshot](../Screenshots/Security/01-pfSense-firewall%20rules.png)
- [Corp-CL01 IP configuration](../Screenshots/Verifications/01-Corp-CL01%20ipconfig.png)

## Related documentation

- [Current network topology](../02-Network-Design/network-topology.md)
- [IP addressing, DHCP, and DNS](../02-Network-Design/ip-addressing.md)
- [DHCP](../04-Active-Directory/dhcp.md)
- [Firewall rules](../08-Security/firewall-rules.md)
