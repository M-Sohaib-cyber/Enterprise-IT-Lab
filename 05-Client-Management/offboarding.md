# Finance User Offboarding Exercise

## Scope

This document records the offboarding exercise performed for Sarah Ahmed (`sahmed`). Demonstrated actions are separated from recommended future improvements that were not performed or evidenced.

## Demonstrated actions

The existing exercise records that:

1. A `Disabled Users` OU was created.
2. The `sahmed` account was disabled.
3. The account was moved from `Company Users` to `Disabled Users`.
4. Sarah was removed from `GG_Finance`.
5. The account's **Member Of** view was recorded as showing only `Domain Users` after removal.
6. A fresh sign-in attempt using `CORP\sahmed` was rejected because the account was disabled.

The account was retained rather than deleted.

## Documented access result

The Finance drive mapping was recorded as unavailable after removal from `GG_Finance`. The final sign-in test was denied with the disabled-account message.

Evidence: [Disabled account login denied](../Screenshots/Active%20Directory/10-Disabled-Account-Login-Denied.png).

The current account state and complete memberships have not been verified from a live directory export.

## Recommended future improvements - not demonstrated

The following are possible additions to a future production-style offboarding process, but are **not** claimed as completed in this lab:

- Record authorization and an offboarding ticket
- Revoke active sessions and remote access
- Review all group memberships, delegated rights, and application access
- Transfer or retain business data according to an approved policy
- Record equipment return and account-retention dates
- Verify completion with an audit checklist

These recommendations do not change the demonstrated lab procedure.

## To verify

- Whether `sahmed` remains disabled and located in `Disabled Users`
- Current complete group membership
- Current drive-mapping and file-access result
- Any sessions, application accounts, data ownership, or retention controls

## Related documentation

- [Finance onboarding exercise](onboarding.md)
- [OU, User, and Group Inventory](../04-Active-Directory/users-and-groups.md)
- [Group-Based File Permissions](../04-Active-Directory/agdlp-and-permissions.md)
