# Active Directory Lessons Learned

## Group Membership Token Refresh

Problem:

A user was added to a new security group but still received "Access Denied".

Cause:

Windows creates the user's security token during logon. New group memberships are not applied to the existing logon session.

Resolution:

Sign out and sign back in.

Verification:

```
whoami /groups
```

After logging back in, the new security group appeared in the user's token and access worked correctly.

---

## Share Permissions vs NTFS Permissions

Share permissions determine whether a user can access the shared folder.

NTFS permissions determine what actions the user can perform.

Best practice:

- Share Permissions → Everyone = Full Control
- NTFS Permissions → Restrict access using Domain Local Groups

---

## AGDLP

Using Global Groups and Domain Local Groups simplifies permission management and follows Microsoft's recommended enterprise design.

## Future Improvement

### AGDLP Group Scope

During this lab, the `DL_*` groups were accidentally created as **Global Security Groups** instead of **Domain Local Security Groups**.

The current implementation functions correctly in this single-domain environment because the Global groups are assigned directly to NTFS permissions.

For a production Active Directory environment, these groups should be recreated as **Domain Local** groups to fully implement the Microsoft AGDLP model.

Target design:

```
Accounts
    ↓
Global Groups (GG_*)
    ↓
Domain Local Groups (DL_*)
    ↓
NTFS Permissions
```

This improvement is planned for a future milestone.

