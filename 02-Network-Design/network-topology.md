# Current Network Topology

## Overview

The Enterprise IT Lab runs in Oracle VirtualBox and uses `Corp-FW01` (pfSense) to connect the WAN, server, and client networks. Active Directory and DNS are provided by `Corp-DC01`; `Corp-CL01` is the domain-joined Windows 11 client. File sharing is provided by `Corp-FS01` at static `10.10.20.20/24`; its exact VirtualBox attachment remains to verify.

Authoritative addresses are maintained in [IP Addressing, DHCP, and DNS](ip-addressing.md). The logical design and naming conventions are described in the [current network plan](network-plan.md).

## Topology

```text
Internet
  |
VirtualBox NAT
  |
Corp-FW01 (pfSense)
  |-- WAN: em0 / DHCP 10.0.2.15/24 / gateway 10.0.2.2
  |-- LAN: Corp-Core / 10.10.20.1
  |     `-- Corp-DC01 / 10.10.20.10
  |
  `-- OPT1: Corp-Clients / 10.10.30.1
        `-- Corp-CL01 / observed 10.10.30.100

Corp-FS01: file server / static 10.10.20.20/24 / exact VirtualBox attachment To verify
```

## Current components

| Component | Current role | Network information |
|---|---|---|
| `Corp-FW01` | pfSense firewall, router, and NAT gateway | WAN via VirtualBox NAT; LAN `10.10.20.1`; OPT1 `10.10.30.1` |
| `Corp-DC01` | Windows Server 2022 domain controller and DNS server | `10.10.20.10/24` on `Corp-Core` |
| `Corp-FS01` | SMB file server | Static `10.10.20.20/24`; gateway `10.10.20.1`; exact VirtualBox attachment To verify |
| `Corp-CL01` | Domain-joined Windows 11 client | DHCP; observed `10.10.30.100/24` on `Corp-Clients` |

## Network roles

- `Corp-Core` (`10.10.20.0/24`) carries server and infrastructure traffic.
- `Corp-Clients` (`10.10.30.0/24`) carries client workstation traffic.
- `Corp-DC01` supplies DNS for `corp.internal` at `10.10.20.10`.
- `Corp-CL01` reports `10.10.30.1` as both its gateway and DHCP server.
- Live verification on 2026-09-16 confirmed pfSense DHCP enabled on OPT1 with pool `10.10.30.100-10.10.30.199`.

## Routing and firewall status

The original OPT1 IPv4 Any-to-Any pass rule was hardened with ordered rules: allow `Corp-DC01`, allow TCP 445 to `Corp-FS01`, block the remaining LAN/server network, then allow other destinations. Verification confirmed DC reachability, DNS, and internet access; ping to `Corp-FS01` failed while SMB and mapped drives worked. No firewall change is made by this documentation update.

## Related documentation

- [Current network plan](network-plan.md)
- [IP addressing, DHCP, and DNS](ip-addressing.md)
- [pfSense deployment](../03-Virtual-Infrastructure/pfsense.md)
- [Firewall rules](../08-Security/firewall-rules.md)
- [Domain controller build](../03-Virtual-Infrastructure/windows-server-build-guide.md)
- [File server](../03-Virtual-Infrastructure/file-server.md)
- [Windows 11 client](../05-Client-Management/windows11-client.md)
