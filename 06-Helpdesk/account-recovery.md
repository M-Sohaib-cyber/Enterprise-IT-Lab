# Account Recovery Exercise

## Scope

This document records the historical password-reset and account-unlock exercise performed for John Smith (`jsmith`) using Active Directory Users and Computers, plus the supplied 2026-10-06 AD Recycle Bin enablement and temporary-account restore test. No self-service tool or ticketing integration is claimed.

## Starting condition

The documented `Default Domain Policy` records an account lockout threshold of five invalid attempts. During testing, repeated incorrect passwords caused `CORP\jsmith` to become locked and unable to sign in.

Evidence: [Account locked out](../Screenshots/Active%20Directory/11-Account-Locked-Out.png).

## Demonstrated recovery steps

The existing exercise records that the administrator:

1. Opened John Smith's account in Active Directory Users and Computers on `Corp-DC01`.
2. Confirmed and cleared the locked state.
3. Reset the password to a temporary value.
4. Enabled **User must change password at next logon**.
5. Confirmed the account was unlocked.
6. Had the user sign in with the temporary password.
7. Confirmed Windows required a password change.
8. Recorded a successful sign-in after a compliant new password was set.

Password values are not documented.

## Evidence

- [Password reset and account unlocked](../Screenshots/Active%20Directory/12-Password-Reset-And-Unlocked.png)
- [Password change required](../Screenshots/Active%20Directory/13-Password-Change-Required.png)

## Result

The documented exercise demonstrates a manual unlock, administrative password reset, forced password change, and return to successful domain sign-in for `CORP\jsmith`.

This is a lab exercise, not a complete helpdesk identity-verification or ticket workflow.

## AD Recycle Bin enablement and restore test - 2026-10-06

Initial verification found Recycle Bin Feature disabled with an empty `EnabledScopes` value. During the supplied live work, AD Recycle Bin was enabled for the `corp.internal` forest; PowerShell verification confirmed `EnabledScopes` became populated. This was a controlled configuration improvement, separate from the checks and practical recovery test below.

1. Created temporary lab account Recovery Test (`recovery.test`) in `Company Users` and verified it existed.
2. Deleted the account; `Get-ADUser recovery.test` returned object not found.
3. Located Recovery Test under Deleted Objects in Active Directory Administrative Center and used **Restore** on the selected test object.
4. Verified `recovery.test` was restored to its original `Company Users` OU. The restored account was disabled.
5. Deleted the temporary account again after successful verification. Final `Get-ADUser recovery.test` returned object not found.

The temporary account is not part of the permanent active lab user inventory. Only the selected test object's restore and subsequent deletion are recorded; no purge of all historical Deleted Objects is claimed. This test verifies the recorded restore workflow, while broader backup and recovery capabilities remain unverified. This documentation update changes no live configuration.

Verification on 2026-10-06 also confirmed `jsmith` enabled and the default domain password/lockout values in [Group Policy Inventory](../04-Active-Directory/gpo-inventory.md). The current locked state was not supplied.

## To verify

- Current `jsmith` locked state
- Whether any helpdesk delegation, audit process, or ticket workflow exists

## Related documentation

- [Group Policy Inventory](../04-Active-Directory/gpo-inventory.md)
- [OU, User, and Group Inventory](../04-Active-Directory/users-and-groups.md)
- [Known Issues](../09-Documentation/known-issues.md)
