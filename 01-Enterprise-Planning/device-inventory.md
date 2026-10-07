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
| `Corp-FS01` | SMB file server | Windows Server 2022 Standard Evaluation, build 20348 | Static `10.10.20.20/24`; gateway `10.10.20.1`; DNS `10.10.20.10`; domain `corp.internal`; `Corp-Core` attachment verified 2026-10-06 | Implemented; inventory incomplete |
| `Corp-CL01` | Domain-joined workstation and GPO test client | Windows 11 Enterprise Evaluation | DHCP; observed `10.10.30.100/24` on `Corp-Clients`; gateway/DHCP endpoint `10.10.30.1`; DNS `10.10.20.10` | Implemented |

## VirtualBox baseline - verified 2026-10-06

| VM | RAM | CPU | Network attachments |
|---|---|---|---|
| `Corp-FW01` | 2048 MB | 2 vCPU | NAT WAN + `Corp-Core` + `Corp-Clients` |
| `Corp-DC01` | 4096 MB | 2 vCPU | `Corp-Core` |
| `Corp-FS01` | 3075 MB | 2 vCPU | `Corp-Core` |
| `Corp-CL01` | 4096 MB | 2 vCPU | `Corp-Clients` |

Host hardware, VDI/snapshot state, Guest Additions, and retained snapshot metadata are recorded in the [environment](../00-Project-Overview/environment.md).

## Fresh-build VM baseline

Use these resource allocations when creating the four VMs. RAM, CPU, and network attachments retain the verified 2026-10-06 values above. Disk sizes are approximate build capacities; they are not sizes of snapshot differencing files or newly measured live disk capacities.

| VM | RAM | CPU | Approximate system disk | Additional disk | Network attachments |
|---|---|---|---|---|---|
| `Corp-FW01` | 2048 MB | 2 vCPU | 20 GB VDI | None required by this baseline | Adapter 1: NAT; Adapter 2: NAT Network `Corp-Core`; Adapter 3: NAT Network `Corp-Clients` |
| `Corp-DC01` | 4096 MB | 2 vCPU | 80 GB VDI | None required by this baseline | Adapter 1: NAT Network `Corp-Core` |
| `Corp-FS01` | 3075 MB | 2 vCPU | 60 GB VDI | Separate 20 GB `Corp-FS01-Backup.vdi` | Adapter 1: NAT Network `Corp-Core` |
| `Corp-CL01` | 4096 MB | 2 vCPU | 80 GB VDI | None required by this baseline | Adapter 1: NAT Network `Corp-Clients` |

The 20 GB FW01 and 80 GB DC01 disks are supported by their existing build records; the separate 20 GB FS01 backup disk is verified in the [file-server record](../03-Virtual-Infrastructure/file-server.md). The approximately 60 GB FS01 system disk and 80 GB CL01 disk are rebuild targets for this guide. The existing FS01 record verifies a 60.32 GB `C:` volume, not an exact system VDI capacity; the existing client record leaves live disk capacity **To verify**. These targets do not supersede those live-inventory uncertainties. Dynamic allocation is recorded for FW01, DC01, and the backup VDI; allocation mode for the other fresh system disks is a reader choice pending verification.

### Create the VMs

1. In VirtualBox Manager, select **New**, enter the exact VM name from the table, and choose a host storage folder with the capacity described in the [prerequisites](../00-Project-Overview/environment.md#prerequisites-for-a-fresh-build).
2. Select the guest OS type/version matching the intended installation media: FreeBSD 64-bit for pfSense, Windows Server 2022 for the servers, and Windows 11 for the client. Labels vary by VirtualBox version. If unattended installation is offered, choose a manual installation so the later guest setup can be followed explicitly; this is a guide workflow choice, not a verified historical setting.
3. Set RAM and CPU to the table values. If CPU selection is not in the creation wizard, set it afterward under **Settings > System > Processor**.
4. Create a new VDI system disk with the listed approximate capacity. For FS01, add a separate 20 GB VDI using **Settings > Storage** and a SATA controller, matching the recorded backup-disk attachment. Its formatting and Windows Server Backup configuration belong to the later backup stage.
5. With the VM powered off, check RAM under **Settings > System**, disk attachments under **Settings > Storage**, and configure adapters using the [network procedure](../02-Network-Design/network-plan.md#configure-vm-network-adapters).
6. Attach the appropriate installation media to the virtual optical drive. Review guest-specific settings in the [pfSense record](../03-Virtual-Infrastructure/pfsense.md), [DC build record](../03-Virtual-Infrastructure/windows-server-build-guide.md), and [Windows 11 client record](../05-Client-Management/windows11-client.md) before starting installation. DC01 records EFI disabled/TPM None; CL01 records EFI, Secure Boot, and TPM 2.0 enabled. Unspecified FS01 firmware/display settings and other unverified VM options remain reader choices or later verification items.

Create fresh base disks. Historical snapshots and differencing VDIs are not prerequisites, installation disks, or templates for a new build. The repository does not supply prebuilt VM images. Exact MAC addresses do not need to match the original lab; retain unique addresses and compare your client MAC with its later DHCP lease.

## Inventory notes

- `Corp-CL01` IP information is supported by `Screenshots/Verifications/01-Corp-CL01 ipconfig.png`.
- `Corp-FS01` OS, build, domain, and static network settings were live verified on 2026-09-16. `Corp-DC01` static addressing and domain were also confirmed.
- Older names such as `SRV-DC01`, `SRV-FS01`, and `FW01` are obsolete planning values and are not current inventory entries.
- pfSense DHCP is live verified enabled on OPT1, with pool `10.10.30.100-10.10.30.199`. Verification on 2026-10-06 confirmed pfSense ISC DHCP on OPT1, the supplied gateway/DNS/domain options, 7200/86400-second default/maximum leases, and no OPT1 static mappings. Corp-CL01 successfully released/renewed 10.10.30.100; this observed address is not permanently reserved. VirtualBox DHCP is disabled on NAT Networks Corp-Core (10.10.20.0/24) and Corp-Clients (10.10.30.0/24). Corp-DC01 remains static at 10.10.20.10 with DHCP disabled and the Windows DHCP Server role Available, not Installed. Exclusions and uninspected settings remain to verify. See [DHCP verification](../04-Active-Directory/dhcp.md). See the [IP addressing reference](../02-Network-Design/ip-addressing.md).
