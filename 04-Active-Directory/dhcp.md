# DHCP Evidence and Current Status

## Status

Live verification on 2026-09-16 confirmed pfSense DHCP enabled on OPT1 (`10.10.30.1`) with pool `10.10.30.100-10.10.30.199`.

Authoritative addresses are maintained in [IP Addressing, DHCP, and DNS](../02-Network-Design/ip-addressing.md).

## Confirmed client evidence

The existing `ipconfig /all` screenshot for `Corp-CL01` records:

| Item | Observed value |
|---|---|
| DHCP enabled | Yes |
| Client IPv4 address | `10.10.30.100` |
| Subnet mask | `255.255.255.0` |
| Default gateway | `10.10.30.1` |
| DHCP server | `10.10.30.1` |
| DNS server | `10.10.20.10` |
| DNS suffix | `corp.internal` |

Evidence: [Corp-CL01 IP configuration](../Screenshots/Verifications/01-Corp-CL01%20ipconfig.png).

## Verified OPT1 configuration - 2026-10-06

Supplied live verification reconfirmed pfSense OPT1 as the DHCP provider for `Corp-Clients`.

| Setting | Verified value |
|---|---|
| Backend / OPT1 DHCP server | ISC DHCP / Enabled |
| Client subnet | `10.10.30.0/24` |
| Primary address pool | `10.10.30.100` through `10.10.30.199` |
| Unknown clients | Allowed |
| Supplied DNS server | `10.10.20.10` (`Corp-DC01`) |
| Supplied gateway | `10.10.30.1` (pfSense OPT1) |
| Supplied domain name | `corp.internal` |
| WINS servers | Not configured |
| OMAPI | Not configured |
| DHCP failover peer | Not configured |
| Static ARP | Disabled |
| Ping checking | Enabled; "Disable ping check" is unchecked |
| Static mappings/reservations | None configured on OPT1 |
| Default lease time | 7200 seconds (2 hours) |
| Maximum lease time | 86400 seconds (24 hours) |

## Live lease and release/renew verification - 2026-10-06

pfSense showed hostname `Corp-CL01`, IP `10.10.30.100`, and MAC `08:00:27:cc:6d:95`. The observed lease duration was exactly 2 hours, matching the configured default. OPT1 pool capacity was 100 addresses, with one address in use during verification.

On `Corp-CL01`, `ipconfig /release` was performed, followed by a successful `ipconfig /renew`. The client received `10.10.30.100` again. This is the observed result only: no static mapping exists, so the address is not permanently reserved or guaranteed.

After renewal, `ipconfig /all` confirmed DHCP enabled, IPv4 `10.10.30.100`, default gateway and DHCP server `10.10.30.1`, DNS server `10.10.20.10`, and connection-specific DNS suffix `corp.internal`. The client successfully obtained the tested configuration from pfSense DHCP. These supplied live observations are separate from the earlier screenshot evidence above.

## VirtualBox network verification - 2026-10-06

VirtualBox Network Manager was inspected:

| NAT Network | IPv4 prefix | VirtualBox DHCP |
|---|---|---|
| `Corp-Core` | `10.10.20.0/24` | Disabled |
| `Corp-Clients` | `10.10.30.0/24` | Disabled |

`Corp-CL01` Adapter 1 was enabled, attached to **NAT Network** named `Corp-Clients`, with cable connected and MAC `08:00:27:CC:6D:95`. This matches the MAC in the pfSense lease.

A separate Host-Only network had its own DHCP server enabled in `192.168.37.0/24`. It is separate from the verified lab NAT networks; the tested client adapter uses `Corp-Clients`, where VirtualBox DHCP is disabled. This observation does not establish a DHCP conflict with the lab.

## Corp-DC01 verification - 2026-10-06

`Get-WindowsFeature DHCP` showed the DHCP Server role as **Available**, not **Installed**. `Corp-DC01` is not running the Windows DHCP Server role. Its IPv4 address remained `10.10.20.10`, with **DHCP Enabled: No**, confirming static IPv4 configuration on `Corp-Core`.

## Remaining verification scope

Exclusions remain **To verify**. Whether any other DHCP service exists on `Corp-Core` remains open beyond the verified absence of VirtualBox DHCP there and the Windows DHCP Server role on `Corp-DC01`. Other uninspected DHCP and VirtualBox settings remain unverified; these checks do not establish an exhaustive audit.

This update records supplied verification results only; no lab configuration is changed.

## Related documentation

- [pfSense deployment](../03-Virtual-Infrastructure/pfsense.md)
- [Windows 11 client](../05-Client-Management/windows11-client.md)
- [Current network topology](../02-Network-Design/network-topology.md)
