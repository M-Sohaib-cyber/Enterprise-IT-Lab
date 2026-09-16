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

## To verify

The repository does not contain a current DNS configuration export. The following remain **To verify**:

- Forwarder addresses and forwarding policy
- Reverse lookup zones
- Zone replication scope and detailed zone properties
- Aging and scavenging settings
- Dynamic update settings
- Resource records beyond the documented domain/DC result
- DNS logging and diagnostics configuration

No unverified DNS feature is claimed as implemented.

## Related documentation

- [Corp-DC01 build and configuration](../03-Virtual-Infrastructure/windows-server-build-guide.md)
- [Windows 11 client](../05-Client-Management/windows11-client.md)
- [Current network topology](../02-Network-Design/network-topology.md)
