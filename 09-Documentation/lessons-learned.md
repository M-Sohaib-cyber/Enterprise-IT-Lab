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