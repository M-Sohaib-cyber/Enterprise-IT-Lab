# Known Issues and Verification Items

This is the authoritative summary of unresolved documentation and practical verification items. Detailed evidence remains in the linked documents. An item listed here is not automatically proof that the lab is malfunctioning.

## Practical issues - do not treat as remediated

### AD-01: `DL_*` group scopes

- **Recorded state:** The `DL_*` groups were reportedly created as Global Security groups rather than Domain Local Security groups.
- **Impact:** The lab must not be described as a fully or correctly implemented AGDLP model.
- **Required later work:** Verify live group scopes, nesting, and ACLs before planning remediation.
- **Current action:** Documentation only; no group or permission changed.
- **Details:** [Group-Based File Permissions](../04-Active-Directory/agdlp-and-permissions.md)

### SEC-01: Broad workstation local-administrator assignment

- **Recorded state:** `GPO - Local Administrators` adds `CORP\GG_IT` to the local `Administrators` group on affected workstations.
- **Impact:** All applicable `GG_IT` members may receive broad local administrator rights.
- **Required later work:** Verify current scope, membership, and business requirement before remediation.
- **Current action:** Documentation only; no GPO or membership changed.
- **Details:** [Group Policy Inventory](../04-Active-Directory/gpo-inventory.md)

### SEC-02: Permissive OPT1 firewall rule

- **Recorded state:** An OPT1 IPv4 Any-to-Any pass rule restored client connectivity.
- **Impact:** The rule is not a least-privilege policy.
- **Required later work:** Verify required traffic and the live saved rule before designing narrower rules.
- **Current action:** Documentation only; no firewall rule changed.
- **Details:** [Firewall Rules](../08-Security/firewall-rules.md)

## Verification conflicts

### NET-01: DHCP provider

`Corp-CL01` reports `10.10.30.1` as its DHCP server, while the original pfSense record says OPT1 DHCP was disabled. Provider, service state, scope, options, reservations, and lease configuration remain **To verify**.

Details: [DHCP Evidence and Current Status](../04-Active-Directory/dhcp.md)

### AD-02: Active Directory functional levels

Older records conflict between Windows Server 2016 and Windows Server 2025 functional levels. The current forest and domain functional levels remain **To verify** on `Corp-DC01`.

Details: [Corp-DC01 Build and Configuration](../03-Virtual-Infrastructure/windows-server-build-guide.md)

### GPO-01: Inactivity timing

The workstation-security policy export recorded a 600-second inactivity value, but the observed lock/display behavior occurred at approximately five minutes. The setting responsible for the observed timing remains **To verify**.

Details: [Group Policy Operation and Verification](../04-Active-Directory/group-policy.md)

## Status convention

- **Documented:** Supported by repository records or evidence.
- **To verify:** Requires a live configuration check or stronger evidence.
- **Remediated:** Use only after a practical change and verification evidence exist.

No item in this document is marked remediated.
