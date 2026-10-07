# Active Directory DNS

## Current role

`Corp-DC01` provides DNS for the `corp.internal` Active Directory domain at `10.10.20.10`. The server is documented as using its own address as preferred DNS, and `Corp-CL01` is observed using the same DNS server.

Authoritative address information is maintained in [IP Addressing, DHCP, and DNS](../02-Network-Design/ip-addressing.md).

## Implement the recorded DNS configuration

Start after [AD DS/DNS promotion](../03-Virtual-Infrastructure/windows-server-build-guide.md#build-from-zero), with FS01 and CL01 joined when checking their host records. These instructions implement the inspected records; they do not assume a complete DNS export.

### Check the forward zones and register hosts

1. On DC01, open **Server Manager > Tools > DNS**, expand `Corp-DC01 > Forward Lookup Zones`, and inspect `corp.internal` and `_msdcs.corp.internal`. They are created by AD DS/DNS promotion; do not create duplicate zones or manually recreate the AD service-record hierarchy.
2. Inspect `corp.internal` for the records listed in the verified host table below: the zone-root record and DC01 at `10.10.20.10`, FS01 at `10.10.20.20`, and CL01 at its actual DHCP address. `10.10.30.100` is the historical observed lease, not a reservation or a required static A record for every rebuild.
3. Confirm each Windows machine uses DNS `10.10.20.10` and has the intended domain suffix. On the relevant machine, run `ipconfig /registerdns` in an elevated Command Prompt to request host registration, then refresh DNS Manager and verify the resulting record. On DC01, `nltest /dsregdns` requests DC-specific record registration if diagnostics show missing registration. These are fresh-build recovery methods, not claims about the original record-creation mechanism.
4. If a host record is still missing, investigate its registration and DNS errors first. DNS Manager's **New Host (A or AAAA)** can create a known host's A record using its exact hostname and verified current address, but manual creation is a reader-selected fallback, not an established historical method. Do not manually pin CL01 to an old lease or assume pfSense dynamically updates Windows DNS.
5. Inspect server **Properties > Forwarders**: the verified design has no explicit forwarders. Do not add public resolvers or an invented forwarding target. Forward-zone replication/dynamic-update properties, aging/scavenging, and the original mechanism that created each host record were not historically recorded; retain the promotion-created configuration and flag any exact-match requirement for live verification.

### Create the server-network reverse zone and DC01 PTR

1. In DNS Manager, right-click **Reverse Lookup Zones > New Zone**. Choose **Primary zone** and **Store the zone in Active Directory**.
2. Select replication to **all DNS servers running on domain controllers in this domain: corp.internal**.
3. Choose **IPv4 Reverse Lookup Zone**, enter Network ID `10.10.20`, and confirm the generated name `20.10.10.in-addr.arpa` for `10.10.20.0/24`.
4. Select **Allow only secure dynamic updates** and finish. If the zone already exists, inspect these properties instead of recreating it.
5. In that zone choose **New Pointer (PTR)**. Enter the host address for `10.10.20.10` (host portion `10` where the dialog already supplies the network prefix), and host name `Corp-DC01.corp.internal`. Save and refresh. Do not add unverified reverse zones or PTRs for other hosts/networks.

The choices above are the recorded reverse-zone settings. Microsoft's [DNS-zone instructions](https://learn.microsoft.com/en-us/windows-server/networking/dns/manage-dns-zones) explain the wizard.

### DNS checkpoints

On DC01 and then CL01, run the lookups below. The DC/domain answers must be `10.10.20.10`, FS01 must be `10.10.20.20`, CL01 must match its current DHCP lease, and the reverse lookup must return `Corp-DC01.corp.internal`.

```cmd
ipconfig /all
nslookup corp.internal 10.10.20.10
nslookup Corp-DC01.corp.internal 10.10.20.10
nslookup Corp-FS01.corp.internal 10.10.20.10
nslookup Corp-CL01.corp.internal 10.10.20.10
nslookup 10.10.20.10 10.10.20.10
nslookup -type=SRV _ldap._tcp.dc._msdcs.corp.internal 10.10.20.10
nslookup google.com 10.10.20.10
```

Run `dcdiag /test:dns /v` on DC01 with administrative rights and review failures before proceeding. AD/DC service discovery must identify DC01. External lookup tests require working WAN connectivity; they do not imply a forwarder is configured. The original local `::1` timeout remains a historical observation below. A missing reverse name before PTR creation is distinct from failure to resolve a forward record.

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
