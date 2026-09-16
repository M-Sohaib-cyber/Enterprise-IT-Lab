# DHCP Evidence and Current Status

## Status

DHCP is active from the perspective of `Corp-CL01`, but the provider's live configuration has not been proven from the repository. This document records observed client values without guessing the server configuration.

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

## Unresolved provider conflict

`10.10.30.1` is the documented address of the `Corp-FW01` OPT1 interface. The original pfSense deployment record says DHCP was disabled on OPT1, while the client identifies `10.10.30.1` as its DHCP server.

The following require live practical verification:

- Actual DHCP provider and service state
- Whether pfSense or a VirtualBox service supplied the observed lease
- Scope start and end addresses
- Subnet, gateway, DNS, and suffix options in the server configuration
- Exclusions and reservations
- Lease duration
- Whether `10.10.30.100` is dynamic or reserved
- Whether any DHCP service exists on `Corp-Core`

The screenshot proves that a lease was received; it does not prove how the server is configured. No DHCP settings are changed by this documentation.

## Related documentation

- [pfSense deployment](../03-Virtual-Infrastructure/pfsense.md)
- [Windows 11 client](../05-Client-Management/windows11-client.md)
- [Current network topology](../02-Network-Design/network-topology.md)
