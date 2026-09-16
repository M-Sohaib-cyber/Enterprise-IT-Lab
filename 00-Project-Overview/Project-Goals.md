# Project Goals

## Purpose

The Enterprise IT Lab is a practical portfolio environment for developing and demonstrating entry-level enterprise infrastructure skills. It provides a safe virtual environment in which to build, document, test, and troubleshoot common IT services.

## Goals

- Design and explain a small segmented enterprise network.
- Administer Windows Server 2022 and Windows 11 in Oracle VirtualBox.
- Deploy and operate an Active Directory domain with centralized DNS.
- Manage organizational units, users, security groups, computers, and routine account tasks.
- Apply Group Policy to domain users and workstations and verify its effect.
- Provide departmental file sharing and group-based access.
- Practise client deployment, domain join, connectivity testing, and fault diagnosis.
- Record security decisions, limitations, evidence, and lessons learned clearly.
- Build repeatable documentation appropriate for junior infrastructure, networking, systems administration, helpdesk, and security roles.

## Current scope

The implemented lab currently includes pfSense routing, separate server and client networks, the `corp.internal` Active Directory domain, DNS, a Windows 11 domain client, file sharing, user administration exercises, and several GPOs.

Future ideas are not considered implemented until configuration and verification evidence are added. The current status is maintained in the [lab roadmap](Lab-Roadmap.md).

## Documentation principles

- Describe the configuration that is actually present, not an older design or intended future state.
- Use **To verify** when repository evidence is incomplete.
- Separate implemented work from planned work.
- Link claims to detailed documentation and evidence where available.
- Record practical security concerns without claiming they have already been remediated.
