# Device Inventory

This is the authoritative inventory of devices and virtual machines confirmed by current repository documentation or evidence. Unknown values are marked **To verify**.

## Host

| Name | Role | OS/platform | IP/network | Status |
|---|---|---|---|---|
| Host name: To verify | VirtualBox host | Windows 11; edition/build to verify | Host networking: To verify | In use |

## Virtual machines

| Hostname | Role | OS/platform | Known IP/network | Status |
|---|---|---|---|---|
| `Corp-FW01` | Firewall, router, NAT, and network gateway | pfSense CE 2.8.1 documented; FreeBSD-based VM | WAN/`em0`: DHCP `10.0.2.15/24`, gateway `10.0.2.2`; LAN/`Corp-Core`: `10.10.20.1/24`; OPT1/`Corp-Clients`: `10.10.30.1/24` | Implemented |
| `Corp-DC01` | Domain controller and DNS server | Windows Server 2022 | `10.10.20.10/24` on `Corp-Core`; gateway `10.10.20.1`; DNS `10.10.20.10` | Implemented |
| `Corp-FS01` | SMB file server | Windows Server 2022 Standard Evaluation, build 20348 | Static `10.10.20.20/24`; gateway `10.10.20.1`; DNS `10.10.20.10`; domain `corp.internal`; exact VirtualBox attachment To verify | Implemented; inventory incomplete |
| `Corp-CL01` | Domain-joined workstation and GPO test client | Windows 11 Enterprise Evaluation | DHCP; observed `10.10.30.100/24` on `Corp-Clients`; gateway/DHCP endpoint `10.10.30.1`; DNS `10.10.20.10` | Implemented |

## Inventory notes

- `Corp-CL01` IP information is supported by `Screenshots/Verifications/01-Corp-CL01 ipconfig.png`.
- `Corp-FS01` OS, build, domain, and static network settings were live verified on 2026-09-16. `Corp-DC01` static addressing and domain were also confirmed.
- Older names such as `SRV-DC01`, `SRV-FS01`, and `FW01` are obsolete planning values and are not current inventory entries.
- pfSense DHCP is live verified enabled on OPT1, with pool `10.10.30.100-10.10.30.199`. Verification on 2026-10-06 confirmed pfSense ISC DHCP on OPT1, the supplied gateway/DNS/domain options, 7200/86400-second default/maximum leases, and no OPT1 static mappings. Corp-CL01 successfully released/renewed 10.10.30.100; this observed address is not permanently reserved. VirtualBox DHCP is disabled on NAT Networks Corp-Core (10.10.20.0/24) and Corp-Clients (10.10.30.0/24). Corp-DC01 remains static at 10.10.20.10 with DHCP disabled and the Windows DHCP Server role Available, not Installed. Exclusions and uninspected settings remain to verify. See [DHCP verification](../04-Active-Directory/dhcp.md). See the [IP addressing reference](../02-Network-Design/ip-addressing.md).
