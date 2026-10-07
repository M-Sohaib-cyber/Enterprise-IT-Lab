# Current Network Plan

## Purpose

The lab separates infrastructure servers from client workstations using two VirtualBox networks routed by `Corp-FW01`. This document records the current logical design; confirmed addresses are maintained in the [IP addressing reference](ip-addressing.md).

## Identity and naming

| Item | Current value |
|---|---|
| Active Directory domain | `corp.internal` |
| NetBIOS domain | `CORP` |
| Firewall/router | `Corp-FW01` |
| Domain controller/DNS | `Corp-DC01` |
| File server | `Corp-FS01` |
| Windows client | `Corp-CL01` |

The older `northtech.local`, `SRV-*`, and `FW01` values are obsolete and must not be used as the current configuration.

## Network separation

| Segment | Subnet | Purpose | pfSense interface/address |
|---|---|---|---|
| VirtualBox NAT | `10.0.2.0/24` | pfSense WAN and internet access | WAN / `em0`, DHCP `10.0.2.15/24`, gateway `10.0.2.2` |
| `Corp-Core` | `10.10.20.0/24` | Domain controller, DNS, and server-side infrastructure | LAN / `10.10.20.1` |
| `Corp-Clients` | `10.10.30.0/24` | Domain-joined Windows workstations | OPT1 / `10.10.30.1` |

`Corp-DC01` and `Corp-CL01` are confirmed on their respective server and client segments. `Corp-FS01` is live verified at static `10.10.20.20/24`, gateway `10.10.20.1`; its `Corp-Core` VirtualBox attachment was verified on 2026-10-06.

## Create the VirtualBox networks

Complete the [host prerequisites](../00-Project-Overview/environment.md#prerequisites-for-a-fresh-build) first. These steps reproduce the verified NAT Network names, prefixes, and disabled VirtualBox DHCP. Compare the result with the tested baseline below.

1. Open VirtualBox Manager's **Network Manager** / **Network** tool, commonly under **File > Tools > Network Manager**. Select **NAT Networks**; menu labels depend on the installed version.
2. Select **Create**, open the new network's **Properties**, set its name to `Corp-Core`, and set the IPv4 prefix/network CIDR to `10.10.20.0/24`.
3. Enable the network and clear **Enable DHCP** / the DHCP option. Save or apply the properties.
4. Create `Corp-Clients` with IPv4 prefix `10.10.30.0/24`; enable this network and disable its VirtualBox DHCP option too. Save or apply.
5. Reopen both networks and confirm the names, prefixes, enabled state, and disabled DHCP. The verified design uses these two **NAT Networks** for internal VM attachments. pfSense Adapter 1 uses the separate **NAT** attachment mode, which does not require creating a third named NAT Network.

The lab is intentionally IPv4-focused. Live verification confirmed IPv6 disabled on both internal VirtualBox NAT Networks; port-forwarding properties remain unverified. Oracle's [VirtualBox networking guide](https://docs.oracle.com/en/virtualization/virtualbox/7.2/user/networkingdetails.html) describes the Network Manager and distinguishes NAT from NAT Network. That reference explains the software controls, not the original host's unrecorded settings.

### NAT Network gateway verification checkpoint

**Verified tested baseline - 2026-10-07:** The following read-only command was used on the Windows 11 host running Oracle VirtualBox 7.1.12 to inspect the live NAT Network configuration:

```cmd
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" natnetwork list
```

| NAT Network | Enabled | Network | Gateway | DHCP Server | IPv6 |
|---|---|---|---|---|---|
| `Corp-Core` | Yes | `10.10.20.0/24` | `10.10.20.1` | No | No |
| `Corp-Clients` | Yes | `10.10.30.0/24` | `10.10.30.1` | No | No |

These are the observed values of the tested working lab. pfSense LAN also uses `10.10.20.1/24`, and OPT1 uses `10.10.30.1/24`. The lab has passed practical routing, DNS, SMB, firewall segmentation, and internet-connectivity tests with this configuration; see the [firewall verification record](../08-Security/firewall-rules.md#final-verification---2026-09-20). This host inspection records configuration, not a new execution of those connectivity tests. No verified explanation of VirtualBox's internal handling of the same `.1` values is established here.

For a fresh build, run the command on your host and compare the output with this tested baseline. In PowerShell, prefix the quoted executable path with `&`; adjust the installation path if necessary. Record differences and verify the documented functional checks. A displayed `.1` gateway matching this baseline is not itself a reason to stop the build. pfSense remains the intended lab router/firewall and DHCP provider for `Corp-Clients`; keep VirtualBox DHCP disabled on both NAT Networks. Other VirtualBox versions have not been specifically tested for this lab, so identical behavior is not guaranteed. No lab configuration was changed during this verification.

### Configure VM network adapters

Create the VMs using the [resource baseline](../01-Enterprise-Planning/device-inventory.md#fresh-build-vm-baseline). With each VM powered off, open **Settings > Network**, select each listed adapter, enable it, and set **Attached to** and **Name** as follows:

| VM | Adapter | Attached to | Name | Intended connection |
|---|---|---|---|---|
| `Corp-FW01` | 1 | NAT | No named NAT Network selection | pfSense WAN |
| `Corp-FW01` | 2 | NAT Network | `Corp-Core` | pfSense LAN |
| `Corp-FW01` | 3 | NAT Network | `Corp-Clients` | pfSense OPT1 |
| `Corp-DC01` | 1 | NAT Network | `Corp-Core` | Server network |
| `Corp-FS01` | 1 | NAT Network | `Corp-Core` | Server network |
| `Corp-CL01` | 1 | NAT Network | `Corp-Clients` | Client network |

Check **Cable Connected** for these adapters and save the settings. Cable connected is verified for CL01; checking it on the other fresh VM adapters is an explicit build instruction. Adapter hardware models for FW01 and the servers remain **To verify**; select hardware supported by the guest and record the choice. The CL01 screenshot shows Intel PRO/1000 MT Desktop. Each adapter should have a unique MAC address; record the pfSense adapter MACs to help correlate WAN/LAN/OPT1 during guest setup. The documented pfSense interface names are `em0`, `em1`, and `em2`; interface names can differ if a reader chooses different virtual adapter hardware.

For a fresh build, leave additional adapters disabled unless a later documented step requires one. Extra adapters and unrelated Host-Only networks are not prerequisites for this baseline. Check each attachment again before booting: selecting plain NAT instead of the named NAT Network on a server or client would not reproduce the documented shared segment.

### Foundation checks and handoff

- Both named NAT Networks exist with the correct `/24` prefixes and VirtualBox DHCP disabled.
- The live NAT Network configuration has been compared with the verified tested baseline above, including displayed gateways, disabled VirtualBox DHCP, and disabled IPv6.
- FW01 has the three adapters above; each Windows VM has its listed network attachment and connected cable.
- Continue with the [pfSense deployment record](../03-Virtual-Infrastructure/pfsense.md) for guest installation, interface addressing, routing, and client DHCP. Those settings are not configured merely by attaching VirtualBox adapters.
- Once pfSense is configured, it provides routing between `Corp-Core` and `Corp-Clients` and DHCP on `Corp-Clients`, with pool `10.10.30.100-10.10.30.199`, gateway `10.10.30.1`, and DNS `10.10.20.10`. Windows servers use the documented static addresses. Initial connectivity rules must be in place before client domain joining; detailed pfSense steps belong to the next build stage.
- Before pfSense DHCP is ready, a fresh DHCP client may not receive a lab address; this is not a reason to enable VirtualBox DHCP. Later checks are documented in [DHCP verification](../04-Active-Directory/dhcp.md) and the [firewall test matrix](../08-Security/firewall-rules.md#connectivity-from-corp-cl01).

## Service flow

```text
Internet
  |
VirtualBox NAT
  |
Corp-FW01 (pfSense)
  |-- Corp-Core: 10.10.20.0/24
  |     |-- Corp-DC01: AD DS and DNS
  |     `-- Corp-FS01: SMB file shares
  |
  `-- Corp-Clients: 10.10.30.0/24
        `-- Corp-CL01: domain-joined Windows 11 client
```

- pfSense is the documented gateway and router between the lab networks.
- `Corp-DC01` provides DNS for the Active Directory domain.
- `Corp-CL01` uses `10.10.20.10` for DNS and `10.10.30.1` as its gateway.
- pfSense DHCP on OPT1 is live verified enabled, with pool `10.10.30.100-10.10.30.199` (2026-09-16).

## Security boundary

The separate subnets provide a logical boundary between server and client systems. Ordered OPT1 rules allow access to `Corp-DC01`, allow SMB-only access to `Corp-FS01` on TCP 445, block other traffic to `10.10.20.0/24`, and then allow other destinations such as the internet.

No network or firewall remediation is performed by this documentation update.
