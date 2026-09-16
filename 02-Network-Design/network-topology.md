# Current Network Topology

## Overview

The Enterprise IT Lab runs in Oracle VirtualBox and uses `Corp-FW01` (pfSense) to connect the WAN, server, and client networks. Active Directory and DNS are provided by `Corp-DC01`; `Corp-CL01` is the domain-joined Windows 11 client. File sharing is provided by `Corp-FS01`, although its IP address and exact network attachment remain to verify.

Authoritative addresses are maintained in [IP Addressing, DHCP, and DNS](ip-addressing.md). The logical design and naming conventions are described in the [current network plan](network-plan.md).

## Topology

```text
Internet
  |
VirtualBox NAT
  |
Corp-FW01 (pfSense)
  |-- WAN: DHCP address - To verify
  |-- LAN: Corp-Core / 10.10.20.1
  |     `-- Corp-DC01 / 10.10.20.10
  |
  `-- OPT1: Corp-Clients / 10.10.30.1
        `-- Corp-CL01 / observed 10.10.30.100

Corp-FS01: file server / address and network attachment To verify
```

## Current components

| Component | Current role | Network information |
|---|---|---|
| `Corp-FW01` | pfSense firewall, router, and NAT gateway | WAN via VirtualBox NAT; LAN `10.10.20.1`; OPT1 `10.10.30.1` |
| `Corp-DC01` | Windows Server 2022 domain controller and DNS server | `10.10.20.10/24` on `Corp-Core` |
| `Corp-FS01` | SMB file server | Address and exact attachment To verify |
| `Corp-CL01` | Domain-joined Windows 11 client | DHCP; observed `10.10.30.100/24` on `Corp-Clients` |

## Network roles

- `Corp-Core` (`10.10.20.0/24`) carries server and infrastructure traffic.
- `Corp-Clients` (`10.10.30.0/24`) carries client workstation traffic.
- `Corp-DC01` supplies DNS for `corp.internal` at `10.10.20.10`.
- `Corp-CL01` reports `10.10.30.1` as both its gateway and DHCP server.
- The current DHCP provider configuration remains to verify because the existing pfSense deployment record says OPT1 DHCP was disabled.

## Routing and firewall status

Repository documentation records successful communication from `Corp-CL01` to the domain controller and internet after an OPT1 IPv4 Any-to-Any pass rule was added. That rule is a current lab rule, not a least-privilege design, and requires later practical review. No firewall change is made by this documentation.

## Related documentation

- [Current network plan](network-plan.md)
- [IP addressing, DHCP, and DNS](ip-addressing.md)
- [pfSense deployment](../03-Virtual-Infrastructure/pfsense.md)
- [Firewall rules](../08-Security/firewall-rules.md)
- [Domain controller build](../03-Virtual-Infrastructure/windows-server-build-guide.md)
- [File server](../03-Virtual-Infrastructure/file-server.md)
- [Windows 11 client](../05-Client-Management/windows11-client.md)
