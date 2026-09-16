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
| Source | OPT1 subnets (live verified 2026-09-16) |
| Destination | Any |
| Action | Pass |
| Description | `Allow OPT1 to Any` |
| Rule order | To verify |
| Logging | To verify |

Evidence: [pfSense OPT1 rule screenshot](../Screenshots/Security/01-pfSense-firewall%20rules.png).

Existing documentation records connectivity to pfSense, `Corp-DC01`, and the internet after this rule was added. Live verification on 2026-09-16 confirmed an IPv4 allow rule from OPT1 subnets to any. The screenshot shows the rule editor, so a complete ruleset, rule order, logging, and remaining fields still require verification.

## Known practical security concern

The OPT1 IPv4 allow rule from OPT1 subnets to any is permissive and does not demonstrate least-privilege filtering between client, server, and internet destinations. It remains the documented current lab rule and must not be mistaken for a hardened target policy.

Practical review and remediation are intentionally deferred. No rule is changed by this documentation update.

## To verify

- Complete WAN, LAN, and OPT1 rulesets
- Rule order and enabled/disabled state of other rules
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
