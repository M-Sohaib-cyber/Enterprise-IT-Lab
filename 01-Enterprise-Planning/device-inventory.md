# Device Inventory

This is the authoritative inventory of devices and virtual machines confirmed by current repository documentation or evidence. Unknown values are marked **To verify**.

## Host

| Name | Role | OS/platform | IP/network | Status |
|---|---|---|---|---|
| Host name: To verify | VirtualBox host | Windows 11; edition/build to verify | Host networking: To verify | In use |

## Virtual machines

| Hostname | Role | OS/platform | Known IP/network | Status |
|---|---|---|---|---|
| `Corp-FW01` | Firewall, router, NAT, and network gateway | pfSense CE 2.8.1 documented; FreeBSD-based VM | WAN: DHCP address to verify; LAN/`Corp-Core`: `10.10.20.1/24`; OPT1/`Corp-Clients`: `10.10.30.1/24` | Implemented |
| `Corp-DC01` | Domain controller and DNS server | Windows Server 2022 | `10.10.20.10/24` on `Corp-Core`; gateway `10.10.20.1`; DNS `10.10.20.10` | Implemented |
| `Corp-FS01` | SMB file server | Windows Server; edition/version to verify | IP address and exact network: To verify | Implemented; inventory incomplete |
| `Corp-CL01` | Domain-joined workstation and GPO test client | Windows 11 Enterprise Evaluation | DHCP; observed `10.10.30.100/24` on `Corp-Clients`; gateway/DHCP endpoint `10.10.30.1`; DNS `10.10.20.10` | Implemented |

## Inventory notes

- `Corp-CL01` IP information is supported by `Screenshots/Verifications/01-Corp-CL01 ipconfig.png`.
- `Corp-FS01` is supported by file-server, share, permission, and mapped-drive documentation and screenshots, but its IP and OS version are not recorded reliably.
- Older names such as `SRV-DC01`, `SRV-FS01`, and `FW01` are obsolete planning values and are not current inventory entries.
- The full DHCP scope and current provider configuration remain to be verified. See the [IP addressing reference](../02-Network-Design/ip-addressing.md).
