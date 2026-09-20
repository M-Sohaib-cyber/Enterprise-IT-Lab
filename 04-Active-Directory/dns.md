# Active Directory DNS

## Current role

`Corp-DC01` provides DNS for the `corp.internal` Active Directory domain at `10.10.20.10`. The server is documented as using its own address as preferred DNS, and `Corp-CL01` is observed using the same DNS server.

Authoritative address information is maintained in [IP Addressing, DHCP, and DNS](../02-Network-Design/ip-addressing.md).

## Confirmed configuration

| Item | Confirmed value |
|---|---|
| DNS server | `Corp-DC01` |
| DNS server address | `10.10.20.10` |
| Active Directory DNS domain | `corp.internal` |
| NetBIOS domain | `CORP` |
| `Corp-DC01` preferred DNS | `10.10.20.10` |
| `Corp-CL01` DNS server | `10.10.20.10` |

DNS was installed with Active Directory Domain Services during promotion of `Corp-DC01`. Existing documentation records successful resolution of `corp.internal` and successful client DNS operation.

## Documented verification

The domain-controller build record uses these checks:

```cmd
nslookup corp.internal
ipconfig /all
```

The recorded result for the internal domain resolves to `10.10.20.10`. Client documentation also records working DNS and domain authentication.

Live verification on 2026-09-16 confirmed successful DNS resolution for both `corp.internal` and `Corp-DC01.corp.internal`.

## DNS verification and configuration - 2026-09-20

These supplied live results verify working core DNS functionality. The reverse zone and PTR below were implemented during that live work; this documentation update makes no live configuration changes. The checks do not constitute an exhaustive audit of all DNS records or settings.

### Forward lookup zones and host records

DNS Manager on `Corp-DC01` showed `_msdcs.corp.internal` and `corp.internal` present and running. Both zones are Active Directory-integrated. The `corp.internal` zone contains the expected AD DNS folders/records: `_msdcs`, `_sites`, `_tcp`, `_udp`, `DomainDnsZones`, and `ForestDnsZones`.

| Verified host record | IPv4 address |
|---|---|
| `corp.internal` | `10.10.20.10` |
| `Corp-DC01` | `10.10.20.10` |
| `Corp-CL01` | `10.10.30.100` |
| `Corp-FS01` | `10.10.20.20` |

These are the inspected records, not an exhaustive record audit.

### Forwarders and external resolution

`Corp-DC01` has no explicit DNS forwarders configured. No forwarder was added. External resolution works with the existing configuration; explicit forwarders are not required for the verified working resolution.

| Test from Corp-DC01 | Observed result |
|---|---|
| `nslookup google.com` | Returned external IPv4 and IPv6 records; the initial query using the local `::1` resolver displayed a timeout before eventually succeeding |
| `nslookup google.com 10.10.20.10` | Succeeded without the initial timeout |

No root cause was proven for the `::1` timeout. It remains an [open observation](../09-Documentation/known-issues.md#dns-01-initial-local-1-query-timeout). Successful DNS answers containing IPv6 records do not establish IPv6 network connectivity.

### Server-network reverse lookup zone and PTR

No reverse lookup zone was configured before this verification. A new IPv4 reverse lookup zone was intentionally created with these settings:

| Setting | Implemented value |
|---|---|
| Network | `10.10.20.0/24` |
| Zone | `20.10.10.in-addr.arpa` |
| Zone type | Primary |
| Storage | Stored in Active Directory / AD-integrated |
| Replication scope | All DNS servers running on domain controllers in the `corp.internal` domain |
| Dynamic updates | Allow only secure dynamic updates |
| Created PTR | `10.10.20.10` -> `Corp-DC01.corp.internal` |

`nslookup 10.10.20.10` successfully returned `Corp-DC01.corp.internal`. No reverse zones or PTR records are claimed for other networks or hosts.

### AD/DNS diagnostics

The following command was run on `Corp-DC01`:

```cmd
dcdiag /test:dns /v
```

`corp.internal` passed test DNS. `Corp-DC01` showed **PASS** for `Auth`, `Basc`, `Forw`, `Del`, `Dyn`, and `RReg`. The DNS root-server tests shown in the output also passed. This is successful AD/DNS diagnostic verification for the tests performed; it does not establish that every possible diagnostic or configuration setting was audited. The historical WinRM WSMAN SPN warning remains a separate open item.

### Corp-CL01 configuration and lookups

`ipconfig /all` confirmed host name `Corp-CL01`, primary DNS suffix `corp.internal`, DHCP enabled, IPv4 `10.10.30.100`, subnet mask `255.255.255.0`, gateway and DHCP server `10.10.30.1`, and DNS server `10.10.20.10`.

| Test from Corp-CL01 | Successful result |
|---|---|
| `nslookup corp.internal` | DNS server `Corp-DC01.corp.internal` / `10.10.20.10`; `corp.internal` -> `10.10.20.10` |
| `nslookup Corp-FS01.corp.internal` | `Corp-FS01.corp.internal` -> `10.10.20.20` |
| `nslookup 10.10.20.10` | `10.10.20.10` -> `Corp-DC01.corp.internal` |

The domain client uses `Corp-DC01` for DNS and successfully performs the tested forward and reverse lookups.

## To verify

The repository does not contain a current DNS configuration export. The following remain **To verify**:

- Forward-zone replication scope, dynamic update settings, and other detailed properties not inspected
- Zone properties beyond the recorded reverse-zone settings
- Aging and scavenging settings
- Resource records beyond the inspected and tested records above
- DNS logging and diagnostics configuration beyond the diagnostic run recorded above
- Cause of the observed initial `::1` query timeout

No unverified DNS feature is claimed as implemented.

## Related documentation

- [Corp-DC01 build and configuration](../03-Virtual-Infrastructure/windows-server-build-guide.md)
- [Windows 11 client](../05-Client-Management/windows11-client.md)
- [Current network topology](../02-Network-Design/network-topology.md)
