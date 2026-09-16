# Account Recovery Exercise

## Scope

This document records the password-reset and account-unlock exercise performed for John Smith (`jsmith`). The work was carried out manually with Active Directory Users and Computers; no script, self-service tool, or ticketing integration is claimed.

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

## To verify

- Current `jsmith` enabled/locked state
- Current Default Domain Policy password and lockout values
- Whether any helpdesk delegation, audit process, or ticket workflow exists

## Related documentation

- [Group Policy Inventory](../04-Active-Directory/gpo-inventory.md)
- [OU, User, and Group Inventory](../04-Active-Directory/users-and-groups.md)
- [Known Issues](../09-Documentation/known-issues.md)
