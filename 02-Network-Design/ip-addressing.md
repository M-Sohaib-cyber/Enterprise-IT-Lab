# IP Addressing, DHCP, and DNS

This is the authoritative reference for network addresses confirmed by repository documentation or evidence. Values not established by evidence are marked **To verify**.

## Networks

| Network | CIDR | Mask | Gateway/router | Purpose |
|---|---|---|---|---|
| VirtualBox NAT/WAN | `10.0.2.0/24` | `255.255.255.0` | `10.0.2.2` | Internet access for pfSense WAN |
| `Corp-Core` | `10.10.20.0/24` | `255.255.255.0` | `10.10.20.1` | Servers and infrastructure |
| `Corp-Clients` | `10.10.30.0/24` | `255.255.255.0` | `10.10.30.1` | Windows client systems |

## Assigned and observed addresses

| Address | Device/interface | Assignment | Evidence status |
|---|---|---|---|
| `10.10.20.1` | `Corp-FW01` LAN | Static | Consistently documented |
| `10.10.30.1` | `Corp-FW01` OPT1 | Static | Consistently documented |
| `10.10.20.10` | `Corp-DC01` | Static | Documented as DC and DNS address |
| `10.10.30.100` | `Corp-CL01` | DHCP lease | Confirmed by client `ipconfig` screenshot |
| `10.10.20.20` | `Corp-FS01` | Static | Live verified 2026-09-16 |
| `10.0.2.15` | `Corp-FW01` WAN (`em0`) | DHCP | Live verified 2026-09-16; `/24`, gateway `10.0.2.2` |

Live verification on 2026-09-16 confirmed LAN `em1` at `10.10.20.1/24`, OPT1 `em2` at `10.10.30.1/24`, and static `Corp-DC01` at `10.10.20.10/24` with gateway `10.10.20.1`. `Corp-FS01` uses static `10.10.20.20/24`, gateway `10.10.20.1`, and DNS `10.10.20.10`; both servers belong to `corp.internal`.

An observed DHCP lease is not a permanent reservation unless the server configuration confirms one. Therefore `10.10.30.100` is recorded as observed, not reserved.

## Interface observations - 2026-09-20

WAN IPv4 remains DHCP at `10.0.2.15/24`, gateway `10.0.2.2`. LAN is `10.10.20.1/24` and OPT1 is `10.10.30.1/24`.

WAN IPv6 configuration type is DHCP6, with an observed `fd17:.../64` address and an IPv6 link-local address; DHCPv6 prefix delegation size is `/64`. The full IPv6 addresses were not supplied. The WAN address is within `fd00::/8` (Unique Local IPv6), not evidence of globally routed public IPv6 connectivity. Only IPv6 link-local addresses were observed on LAN and OPT1; no routed IPv6 addressing was observed there.

The implemented server/client design and firewall segmentation are IPv4-based. No IPv6 configuration change was made; IPv6 is not documented as fully disabled. A comprehensive IPv6 security review remains open beyond these observations. See [pfSense](../03-Virtual-Infrastructure/pfsense.md).

## DHCP

`Corp-CL01` reports:

| DHCP item | Observed value |
|---|---|
| DHCP enabled | Yes |
| DHCP server | `10.10.30.1` |
| Leased client address | `10.10.30.100` |
| Supplied gateway | `10.10.30.1` |
| Supplied DNS server | `10.10.20.10` |
| Scope start/end | `10.10.30.100-10.10.30.199` (live verified 2026-09-16) |
| Exclusions/reservations | To verify |
| Lease duration | To verify from current configuration |

Live verification on 2026-09-16 confirmed pfSense DHCP enabled on OPT1 with the pool above, resolving the older disabled-service record. Client options above are observed values; server-side options remain to verify.

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

- Current VirtualBox DHCP settings and pfSense DHCP options
- DHCP exclusions, reservations, and lease duration
- `Corp-FS01` exact VirtualBox network attachment
- DNS forwarders and reverse lookup zones

These are documentation gaps, not confirmed technical failures.
