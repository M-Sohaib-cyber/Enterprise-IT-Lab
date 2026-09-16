# Firewall Rules

## Scope

This document records firewall behavior supported by current repository documentation and evidence. It is not a complete pfSense ruleset or a proposed redesign.

## Current evidenced OPT1 rule design

OPT1 serves the `10.10.30.0/24` client network. The earlier broad pass rule was subsequently hardened with the following ordered rules:

| Order | Action | Source | Destination | Protocol/port | Purpose |
|---|---|---|---|---|---|
| 1 | Allow | OPT1 subnets | `Corp-DC01` (`10.10.20.10`) | Not further specified | Preserve domain-controller and DNS access |
| 2 | Allow | OPT1 subnets | `Corp-FS01` (`10.10.20.20`) | TCP 445 / Microsoft-DS | Permit SMB file-share access only |
| 3 | Block | OPT1 subnets | LAN/server network (`10.10.20.0/24`) | Any | Deny other client-to-server traffic |
| 4 | Allow | OPT1 subnets | Any | Any | Preserve traffic not blocked above, including internet access |

The older [pfSense OPT1 rule screenshot](../Screenshots/Security/01-pfSense-firewall%20rules.png) records the previous broad rule, not this current ordered ruleset.

## Practical verification

- `Corp-CL01` can reach `Corp-DC01` and resolve DNS through it.
- `Corp-CL01` retains internet connectivity.
- `Corp-CL01` cannot ping `Corp-FS01`, consistent with general client-to-server traffic being blocked.
- SMB access to `Corp-FS01` works over TCP 445.
- Jhon's `I:` (IT) and `P:` (Public) mapped drives work after Group Policy refresh.

Together, these results demonstrate that required SMB access is allowed while general access from the client network to the server network is restricted. This update records the completed firewall work; it does not change the lab configuration.

## To verify

- Complete WAN and LAN rulesets, and OPT1 fields beyond the ordered design recorded above
- Enabled/disabled state of other rules
- NAT rules
- Aliases
- IPv6 policy
- Logging settings and recorded events

## Related documentation

- [Corp-FW01 pfSense deployment](../03-Virtual-Infrastructure/pfsense.md)
- [Current network topology](../02-Network-Design/network-topology.md)
- [IP addressing, DHCP, and DNS](../02-Network-Design/ip-addressing.md)
