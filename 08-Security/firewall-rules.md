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

This order was verified on 2026-09-20. Rule 3, **Block OPT1 to Server Network**, now has packet logging enabled. The final **Allow OPT1 to Any** rule remains broad for traffic not matched by the preceding rules, including the internal LAN block. The server-network segmentation objective for OPT1 is verified; this does not establish that the entire firewall is fully hardened or least privilege.

## Practical verification

- `Corp-CL01` can reach `Corp-DC01` and resolve DNS through it.
- `Corp-CL01` retains internet connectivity.
- `Corp-CL01` cannot ping `Corp-FS01`, consistent with general client-to-server traffic being blocked.
- SMB access to `Corp-FS01` works over TCP 445.
- Jhon's `I:` (IT) and `P:` (Public) mapped drives work after Group Policy refresh.

Together, these results demonstrate that required SMB access is allowed while general access from the client network to the server network is restricted. This update records the completed firewall work; it does not change the lab configuration.

## Final verification - 2026-09-20

These results record the supplied completed live verification; this documentation update makes no live configuration changes.

### Connectivity from Corp-CL01

| Test | Result | Verified behavior |
|---|---|---|
| `ping 10.10.20.10` | SUCCESS | `Corp-DC01` is reachable |
| `nslookup corp.internal` | SUCCESS | DNS resolution works through `Corp-DC01` at `10.10.20.10` |
| `Test-NetConnection 10.10.20.20 -Port 445` | `TcpTestSucceeded = True` | SMB access to `Corp-FS01` is permitted |
| `ping 10.10.20.20` | BLOCKED / FAILED as intended | General ICMP access from OPT1 to `Corp-FS01` is blocked |
| `ping 8.8.8.8` | SUCCESS | Client internet connectivity is retained |

### Outbound NAT

pfSense uses **Automatic outbound NAT rule generation**. `Corp-CL01` retains working internet connectivity through pfSense. No NAT configuration change was required.

### OPT1 packet blocking and logging

The existing **Block OPT1 to Server Network** rule initially did not have per-rule packet logging enabled. Logging was enabled specifically on this block rule; logging on all custom firewall rules was not established.

After enabling logging, `Corp-CL01` (`10.10.30.100`) was used to ping `Corp-FS01` (`10.10.20.20`). The ping was blocked as intended. The pfSense GUI firewall log continued to display older entries from 2026-09-16 and did not show the fresh test entries. The underlying log was checked from the pfSense shell using:

```sh
tail -20 /var/log/filter.log
```

The raw log contained fresh 2026-09-20 entries with the following fields (a summary of the supplied results, not a verbatim log extract):

| Field | Verified value |
|---|---|
| Source | `10.10.30.100` |
| Destination | `10.10.20.20` |
| Protocol | ICMP |
| Action | block |

Firewall packet blocking and logging were therefore verified successfully. The stale GUI log display remains an [open observation](../09-Documentation/known-issues.md#sec-03-stale-pfsense-gui-firewall-log-display); no root cause was proven.

### Logging settings

| Setting | Verified state |
|---|---|
| Local logging | Enabled |
| Default firewall block logging | Enabled |
| Per-rule packet logging on **Block OPT1 to Server Network** | Enabled |
| Remote syslog | Not configured |
| GUI log display | 500 entries |
| Log retention count | 7 |

Remote/centralized logging and broader monitoring implementation remain incomplete.

### IPv6 review

WAN uses DHCP6, with an observed `fd17:.../64` address and an IPv6 link-local address; DHCPv6 prefix delegation size is `/64`. The WAN address is within `fd00::/8` (Unique Local IPv6), not evidence of globally routed public IPv6 connectivity. Only IPv6 link-local addresses were observed on LAN and OPT1; no routed IPv6 addressing was observed on either internal interface. The implemented server/client design and segmentation are IPv4-based. No IPv6 configuration change was made, and IPv6 is not documented as fully disabled. A comprehensive IPv6 security review remains open. See the [pfSense interface review](../03-Virtual-Infrastructure/pfsense.md#interface-review---2026-09-20).

## To verify

- Complete WAN and LAN rulesets, and OPT1 fields beyond the ordered design recorded above
- Enabled/disabled state of other rules
- Individual generated NAT rules beyond the verified automatic mode and client connectivity
- Aliases
- IPv6 policy
- Logging state of other custom rules and the cause of the stale GUI log display

## Related documentation

- [Corp-FW01 pfSense deployment](../03-Virtual-Infrastructure/pfsense.md)
- [Current network topology](../02-Network-Design/network-topology.md)
- [IP addressing, DHCP, and DNS](../02-Network-Design/ip-addressing.md)
