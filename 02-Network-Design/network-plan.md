# Current Network Plan

## Purpose

The lab separates infrastructure servers from client workstations using two VirtualBox networks routed by `Corp-FW01`. This document records the current logical design; confirmed addresses are maintained in the [IP addressing reference](ip-addressing.md).

## Identity and naming

| Item | Current value |
|---|---|
| Active Directory domain | `corp.internal` |
| NetBIOS domain | `CORP` |
| Firewall/router | `Corp-FW01` |
| Domain controller/DNS | `Corp-DC01` |
| File server | `Corp-FS01` |
| Windows client | `Corp-CL01` |

The older `northtech.local`, `SRV-*`, and `FW01` values are obsolete and must not be used as the current configuration.

## Network separation

| Segment | Subnet | Purpose | pfSense interface/address |
|---|---|---|---|
| VirtualBox NAT | `10.0.2.0/24` | pfSense WAN and internet access | WAN / `em0`, DHCP `10.0.2.15/24`, gateway `10.0.2.2` |
| `Corp-Core` | `10.10.20.0/24` | Domain controller, DNS, and server-side infrastructure | LAN / `10.10.20.1` |
| `Corp-Clients` | `10.10.30.0/24` | Domain-joined Windows workstations | OPT1 / `10.10.30.1` |

`Corp-DC01` and `Corp-CL01` are confirmed on their respective server and client segments. `Corp-FS01` is live verified at static `10.10.20.20/24`, gateway `10.10.20.1`; its exact VirtualBox attachment remains to verify.

## Service flow

```text
Internet
  |
VirtualBox NAT
  |
Corp-FW01 (pfSense)
  |-- Corp-Core: 10.10.20.0/24
  |     `-- Corp-DC01: AD DS and DNS
  |
  `-- Corp-Clients: 10.10.30.0/24
        `-- Corp-CL01: domain-joined Windows 11 client
```

- pfSense is the documented gateway and router between the lab networks.
- `Corp-DC01` provides DNS for the Active Directory domain.
- `Corp-CL01` uses `10.10.20.10` for DNS and `10.10.30.1` as its gateway.
- pfSense DHCP on OPT1 is live verified enabled, with pool `10.10.30.100-10.10.30.199` (2026-09-16).

## Security boundary

The separate subnets provide a logical boundary between server and client systems. A permissive OPT1 IPv4 allow-any rule is currently documented; it requires later practical review and is not presented as a least-privilege firewall design.

No network or firewall remediation is performed by this documentation update.
