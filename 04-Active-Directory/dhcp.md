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

## Remaining server-side verification

The live check resolves the older pfSense record stating OPT1 DHCP was disabled. The following remain **To verify**:

- Subnet, gateway, DNS, and suffix options in the server configuration
- Exclusions and reservations
- Lease duration
- Whether `10.10.30.100` is dynamic or reserved
- Whether any DHCP service exists on `Corp-Core`
- Current VirtualBox DHCP settings

The client values above remain screenshot evidence; no DHCP settings are changed by this documentation update.

## Related documentation

- [pfSense deployment](../03-Virtual-Infrastructure/pfsense.md)
- [Windows 11 client](../05-Client-Management/windows11-client.md)
- [Current network topology](../02-Network-Design/network-topology.md)
