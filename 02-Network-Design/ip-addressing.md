# IP Addressing, DHCP, and DNS

This is the authoritative reference for network addresses confirmed by repository documentation or evidence. Values not established by evidence are marked **To verify**.

## Networks

| Network | CIDR | Mask | Gateway/router | Purpose |
|---|---|---|---|---|
| VirtualBox NAT/WAN | To verify | To verify | Provided by VirtualBox; current value to verify | Internet access for pfSense WAN |
| `Corp-Core` | `10.10.20.0/24` | `255.255.255.0` | `10.10.20.1` | Servers and infrastructure |
| `Corp-Clients` | `10.10.30.0/24` | `255.255.255.0` | `10.10.30.1` | Windows client systems |

## Assigned and observed addresses

| Address | Device/interface | Assignment | Evidence status |
|---|---|---|---|
| `10.10.20.1` | `Corp-FW01` LAN | Static | Consistently documented |
| `10.10.30.1` | `Corp-FW01` OPT1 | Static | Consistently documented |
| `10.10.20.10` | `Corp-DC01` | Static | Documented as DC and DNS address |
| `10.10.30.100` | `Corp-CL01` | DHCP lease | Confirmed by client `ipconfig` screenshot |
| To verify | `Corp-FS01` | To verify | No reliable address found |
| To verify | `Corp-FW01` WAN | DHCP | Exact lease not confirmed |

An observed DHCP lease is not a permanent reservation unless the server configuration confirms one. Therefore `10.10.30.100` is recorded as observed, not reserved.

## DHCP

`Corp-CL01` reports:

| DHCP item | Observed value |
|---|---|
| DHCP enabled | Yes |
| DHCP server | `10.10.30.1` |
| Leased client address | `10.10.30.100` |
| Supplied gateway | `10.10.30.1` |
| Supplied DNS server | `10.10.20.10` |
| Scope start/end | To verify |
| Exclusions/reservations | To verify |
| Lease duration | To verify from current configuration |

The pfSense deployment document also states that DHCP was disabled on OPT1. This conflicts with the client evidence identifying `10.10.30.1` as its DHCP server. The current service owner and configuration must be verified in a later practical session; this documentation batch does not change it.

## DNS

| Item | Current value |
|---|---|
| Internal DNS domain | `corp.internal` |
| NetBIOS domain | `CORP` |
| DNS server | `Corp-DC01` - `10.10.20.10` |
| `Corp-DC01` preferred DNS | `10.10.20.10` |
| `Corp-CL01` DNS | `10.10.20.10` |
| DNS forwarders | To verify |
| Reverse lookup zones | To verify |

Existing documentation records successful internal domain resolution and client DNS operation. It does not provide an authoritative current export of DNS forwarders or reverse zones.

## Items requiring later verification

- Current pfSense/VirtualBox DHCP ownership and settings
- Full DHCP scope, exclusions, reservations, and lease duration
- `Corp-FS01` address and network attachment
- Current pfSense WAN lease
- DNS forwarders and reverse lookup zones

These are documentation gaps, not confirmed technical failures.
