# SMB Enumeration & Automation Scripts

This repository contains three Bash scripts designed for SMB enumeration and authentication testing using `enum4linux-ng`, `netexec`, `smbmap`, and `crackmapexec`.

## Scripts Overview

### 1. `enum4linux_smb.sh`
This script uses `enum4linux-ng` to enumerate SMB shares and user information from a list of IP addresses or CIDR notations.

#### Usage:

```bash
./enum4linux_smb.sh <input_file.txt>
```

- `<input_file.txt>` should contain a list of IP addresses or CIDR ranges (one per line).
- Automatically expands CIDR ranges into individual IPs.
- Skips empty lines and comments.

### 2. `netexec+smbmap.sh`
This script combines netexec and smbmap to check anonymous SMB access and authenticated share enumeration.

#### Features:
- Attempts anonymous login to SMB shares.
- Checks share permissions using smbmap.
- Attempts authenticated access using a default administrator username and password.

```bash
chmod +x netexec+smbmap.sh
./netexec+smbmap.sh
```

- Prompts for an input file containing IPs.
- Uses netexec to list SMB shares anonymously and with credentials.
- Requires smbmap for permission checks.

### 3. `crackmap_automation.sh`
- This script automates SMB authentication tests using crackmapexec.

#### Features:
- Reads an IP list from a file.
- Attempts authentication using the provided administrator credentials.
- Runs with a timeout to prevent hanging.

#### Usage
```bash
chmod +x crackmap_automation.sh
./crackmap_automation.sh
```

- Prompts for an IP list file.
- Uses crackmapexec for SMB authentication attempts.

### Prerequisites
- Ensure the following tools are installed:

- enum4linux-ng
- netexec
- smbmap
- crackmapexec

## Notes
- Modify the USERNAME and PASSWORD variables in netexec+smbmap.sh and crackmap_automation.sh before use.
- Ensure appropriate permissions before executing:

```bash
chmod +x *.sh
```

## Disclaimer
- These scripts are intended for legal penetration testing and security research purposes only. Unauthorized usage is strictly prohibited.

