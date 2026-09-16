# Firewall Rules

## Scope

This document records firewall behavior supported by current repository documentation and evidence. It is not a complete pfSense ruleset or a proposed redesign.

## Current evidenced OPT1 rule

The repository documents an OPT1 pass rule created after `Corp-CL01` received a DHCP address but could not reach the gateway, `Corp-DC01`, or the internet.

| Field | Current documented value |
|---|---|
| Interface | OPT1 |
| Address family | IPv4 |
| Protocol | Any |
| Source | Any |
| Destination | Any |
| Action | Pass |
| Description | `Allow OPT1 to Any` |
| Rule order | To verify |
| Logging | To verify |

Evidence: [pfSense OPT1 rule screenshot](../Screenshots/Security/01-pfSense-firewall%20rules.png).

Existing documentation records connectivity to pfSense, `Corp-DC01`, and the internet after this rule was added. The screenshot shows the rule editor rather than a complete saved ruleset, so exact saved fields and order require live verification.

## Known practical security concern

The OPT1 IPv4 Any-to-Any rule is permissive and does not demonstrate least-privilege filtering between client, server, and internet destinations. It remains the documented current lab rule and must not be mistaken for a hardened target policy.

Practical review and remediation are intentionally deferred. No rule is changed by this documentation update.

## To verify

- Complete WAN, LAN, and OPT1 rulesets
- Exact saved source value for the OPT1 rule
- Rule order and enabled/disabled state
- NAT rules
- Aliases
- IPv6 policy
- Logging settings and recorded events

## Future hardening

Future practical work should review the rule using least-privilege requirements. This is a recommendation only; no replacement rules are claimed or specified here because the required traffic has not yet been verified.

## Related documentation

- [Corp-FW01 pfSense deployment](../03-Virtual-Infrastructure/pfsense.md)
- [Current network topology](../02-Network-Design/network-topology.md)
- [IP addressing, DHCP, and DNS](../02-Network-Design/ip-addressing.md)
