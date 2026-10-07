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
