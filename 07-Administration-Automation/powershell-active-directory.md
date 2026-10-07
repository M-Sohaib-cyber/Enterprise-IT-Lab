# PowerShell Active Directory Administration

## Lab 1 — User and Group Management

### Objective

Practise common Active Directory administration tasks using PowerShell instead of Active Directory Users and Computers (ADUC).

All configuration changes were performed against a temporary test account and cleaned up after verification.

## Environment

- Domain: `corp.internal`
- Domain Controller: `Corp-DC01`
- Test account: `pstest`
- Test OU: `Company Users`
- Test security group: `GG_IT`

## Tasks Completed

### Query Active Directory Users

Command:
    Get-ADUser -Filter * | Select-Object Name, SamAccountName, Enabled

Verified existing domain users and account status.

### Inspect User Properties

Command:
    Get-ADUser -Identity jsmith -Properties * | Select-Object Name,SamAccountName,Enabled,UserPrincipalName,DistinguishedName,LastLogonDate

Verified user identity, UPN, OU location and last logon information.

### Check Group Membership

Command:
    Get-ADPrincipalGroupMembership jsmith | Select-Object Name,GroupScope

Confirmed `jsmith` membership in `Domain Users` and `GG_IT`.

### Create a Temporary AD User

Commands:
    $Password = Read-Host "Enter temporary password" -AsSecureString

    New-ADUser `
      -Name "PowerShell Test User" `
      -GivenName "PowerShell" `
      -Surname "Test" `
      -SamAccountName "pstest" `
      -UserPrincipalName "pstest@corp.internal" `
      -Path "OU=Company Users,DC=corp,DC=internal" `
      -AccountPassword $Password `
      -Enabled $true

Verified that `pstest` was created successfully in the `Company Users` OU.

### Manage Group Membership

Added the temporary user to `GG_IT`:

    Add-ADGroupMember -Identity "GG_IT" -Members "pstest"

Verified membership:

    Get-ADPrincipalGroupMembership pstest | Select-Object Name,GroupScope

Removed the user from `GG_IT`:

    Remove-ADGroupMember -Identity "GG_IT" -Members "pstest"

Verified that only the default `Domain Users` membership remained.

### Disable and Re-enable an Account

Commands:
    Disable-ADAccount -Identity pstest
    Enable-ADAccount -Identity pstest

Account state was verified after each operation using `Get-ADUser`.

### Reset an AD User Password

Commands:
    $NewPassword = Read-Host "Enter new password" -AsSecureString
    Set-ADAccountPassword -Identity pstest -Reset -NewPassword $NewPassword

The password was entered securely and was not stored as plaintext.

### Clean Up the Test Account

Command:
    Remove-ADUser -Identity pstest

A final `Get-ADUser -Identity pstest` query returned an object-not-found error, confirming successful removal.

## Result

Successfully completed common Active Directory user lifecycle and group-management tasks using PowerShell.

The temporary account and group membership changes were removed after testing, leaving the existing lab configuration unchanged.

## Lab 2 — Automated AD User Provisioning

### Objective

Build and test a reusable PowerShell script for provisioning Active Directory users with validation, secure password handling, error handling, verification, and optional security-group assignment.

### Script

The reusable script is stored at:

`Scripts/New-ADUser.ps1`

### Automation Implemented

The script accepts administrator-supplied parameters for:

- First name
- Last name
- Username
- Optional AD security group

It automatically:

- Builds the user's full name and UPN
- Checks whether the username already exists
- Stops safely if a duplicate account is detected
- Requests the account password securely at runtime
- Creates the account in the `Company Users` OU
- Enables the new account
- Handles account-creation errors
- Queries Active Directory to verify successful creation
- Optionally adds the new user to a specified AD security group
- Reports group-assignment errors without automatically deleting the created account

Passwords are not hard-coded or stored in the repository.

### Testing

The script was syntax-checked before execution.

A temporary account named `autotest` was successfully created with:

- Name: `Automation Test`
- UPN: `autotest@corp.internal`
- Enabled: `True`
- OU: `Company Users`

The same provisioning command was executed again to test duplicate protection. The script detected the existing `autotest` account, stopped before requesting another password, and made no additional account.

A second temporary account named `grouptest` was created using the optional group parameter with `GG_IT`.

Independent verification confirmed that `grouptest` was a member of:

- `Domain Users`
- `GG_IT`

### Cleanup

Both temporary accounts, `autotest` and `grouptest`, were deleted after testing.

A final Active Directory query returned no matching accounts, confirming successful cleanup.

### Result

The automated provisioning script successfully completed user creation, duplicate detection, secure password handling, account verification, and optional security-group assignment.

This exercise moved the lab from individual PowerShell administration commands to reusable Active Directory automation.

## Lab 3 — Bulk AD User Provisioning from CSV

### Objective

Build and test a reusable PowerShell workflow for provisioning multiple Active Directory users from structured CSV data.

### Files

- `Data/bulk-users.csv`
- `Scripts/New-BulkADUsers.ps1`

### Automation Implemented

The bulk provisioning script:

- Accepts a CSV file path as a parameter
- Validates that the CSV file exists
- Imports multiple user records using `Import-Csv`
- Requests the temporary account password securely at runtime
- Checks each username against Active Directory before creation
- Skips existing accounts to prevent duplicate users
- Creates new users in the `Company Users` OU
- Generates each user's UPN using the `corp.internal` domain
- Enables successfully created accounts
- Uses error handling for account creation
- Processes an optional security-group value from each CSV record
- Adds users to the specified group when one is provided
- Safely ignores blank group values
- Reports group-assignment failures without deleting the created account

Passwords are not stored in the CSV, script, or repository.

### Testing

Three temporary users were supplied through the CSV:

- Alice Johnson — `ajohnson` — `GG_IT`
- David Wilson — `dwilson` — `GG_IT`
- Emma Brown — `ebrown` — no additional group

The script successfully created all three accounts.

Independent Active Directory queries confirmed that the accounts existed, were enabled, and were created in the `Company Users` OU.

The script was then executed again using the same CSV. All three existing usernames were detected and skipped, confirming duplicate-account protection.

After adding CSV-based group processing, the final provisioning test confirmed:

- `ajohnson` — member of `Domain Users` and `GG_IT`
- `dwilson` — member of `Domain Users` and `GG_IT`
- `ebrown` — member of `Domain Users` only

Group memberships were independently verified using `Get-ADPrincipalGroupMembership`.

### Cleanup

All three temporary accounts were removed after testing.

A final Active Directory query returned no matching accounts, confirming that the lab environment was returned to its original state.

### Result

Bulk Active Directory provisioning from CSV was successfully implemented and tested, demonstrating repeatable user onboarding, duplicate protection, secure password handling, optional group assignment, validation, and cleanup.

## Lab 4 — System Health Reporting with PowerShell

### Objective

Build and test a reusable PowerShell script for collecting common Windows system and server health information.

### Script

The reusable script is stored at:

`Scripts/Get-SystemHealth.ps1`

### Health Checks Implemented

The script reports:

- Computer name
- Windows operating system and build number
- System uptime
- Total, used, and available RAM
- Fixed-disk capacity and available space
- Percentage of free disk space
- Warning when a fixed disk has less than 15% free space
- Active IPv4 address
- Default gateway
- DNS server configuration
- Role-appropriate Windows service status

Optical media and mounted ISO volumes are excluded from disk-space monitoring to prevent false low-space warnings.

### Role-Aware Service Checks

The script selects services based on the computer on which it is executed.

For `CORP-DC01`:

- DNS
- Active Directory Domain Services (`NTDS`)
- Netlogon

For `CORP-FS01`:

- Server (`LanmanServer`)

Other systems use the DNS Client service as the default check.

### Testing — CORP-DC01

The script was tested successfully on the domain controller.

Testing confirmed:

- Windows Server 2022 Standard Evaluation
- Build 20348
- 4 GB RAM detected
- System uptime reported correctly
- `C:` disk capacity and available space reported
- IPv4 address `10.10.20.10`
- Default gateway `10.10.20.1`
- DNS servers `::1` and `10.10.20.10`
- DNS, NTDS, and Netlogon services running

An initial test incorrectly treated the mounted VirtualBox Guest Additions ISO as a disk with 0% free space. The script was improved to monitor only fixed disks, removing this false-positive warning.

### Testing — CORP-FS01

The same script was tested on the file server without modifying the script.

Testing confirmed:

- Windows Server 2022 Standard Evaluation
- Build 20348
- Approximately 3 GB RAM detected
- System uptime reported correctly
- `C:` disk information reported
- IPv4 address `10.10.20.20`
- Default gateway `10.10.20.1`
- DNS server `10.10.20.10`
- Server (`LanmanServer`) service running

This demonstrated that the script could adapt its service checks to different server roles.

### Result

A reusable Windows system-health reporting script was successfully created and tested across the domain controller and file server.

The exercise demonstrated practical PowerShell use for system information gathering, resource monitoring, network verification, service-health checks, conditional logic, calculated values, and basic alerting.