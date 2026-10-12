# Linux User Management & Backup Automation

A Bash shell scripting project for managing Linux users and groups, creating backups of user home directories, restoring backups, and maintaining activity logs.

## Features

- Create Linux users
- Delete Linux users
- Create groups
- Add users to groups
- List system users
- Backup user home directories
- Restore user backups
- Log successful and failed operations
- Menu-driven interface
- Basic input validation

## Project Structure

```text
user-management/
├── user_backup_manager.sh
├── README.md
├── backups/
├── logs/
│   └── user_management.log
└── .gitignore
```

## Requirements

- Linux or WSL
- Bash
- sudo privileges
- Standard Linux utilities such as:
  - `useradd`
  - `userdel`
  - `groupadd`
  - `usermod`
  - `tar`
  - `getent`

## Setup

Clone the repository:

```bash
git clone <your-repository-url>
```

Move into the project directory:

```bash
cd user-management
```

Give execute permission to the script:

```bash
chmod +x user_backup_manager.sh
```

Run the script:

```bash
./user_backup_manager.sh
```

Some user-management operations require root privileges, so you may also run:

```bash
sudo ./user_backup_manager.sh
```

## Menu

When the script starts, it displays:

```text
====================================
     Linux User & Backup Manager
====================================
1. Create User
2. Delete User
3. Create Group
4. Add User to Group
5. List Users
6. Backup User
7. Restore Backup
8. Exit
====================================
```

## User Creation

The script asks for a username and checks whether the user already exists.

Example:

```text
Enter username: fazil
User fazil created successfully
```

The command used internally is similar to:

```bash
useradd -m fazil
```

The `-m` option creates the user's home directory.

## Delete User

The script checks whether the user exists and asks for confirmation before deleting the account.

Example:

```text
Enter username to delete: fazil
Are you sure you want to delete fazil? (y/n): y
User fazil deleted successfully
```

The command used is:

```bash
userdel -r fazil
```

The `-r` option removes the user's home directory along with the account.

## Group Management

Create a new group:

```text
Enter group name: developers
Group developers created successfully
```

Add a user to a group:

```text
Enter username: fazil
Enter group name: developers
fazil added to developers successfully
```

The script uses:

```bash
usermod -aG developers fazil
```

Where:

- `-a` means append
- `-G` specifies supplementary groups

## Backup

The script creates a compressed backup of a user's home directory.

Example:

```text
Enter username to backup: fazil
Backup created successfully
Backup location: ./backups/fazil_2026-10-12_21-48-10.tar.gz
```

The backup command is based on:

```bash
tar -czf backup.tar.gz /home/fazil
```

Where:

- `c` = create archive
- `z` = gzip compression
- `f` = specify archive filename

## Restore

The restore option displays available backup files and asks which one should be restored.

Example:

```text
Available backups:
fazil_2026-10-12_21-48-10.tar.gz

Enter backup filename:
fazil_2026-10-12_21-48-10.tar.gz
```

The script restores the archive using:

```bash
tar -xzf backup.tar.gz -C /
```

Where:

- `x` = extract archive
- `z` = gzip compressed archive
- `f` = specify archive filename
- `-C /` = extract relative to the root directory

This restores files such as:

```text
/home/fazil/file1.txt
/home/fazil/documents/
```

## Logging

All important actions are recorded in:

```text
logs/user_management.log
```

Example log entries:

```text
2026-10-12 21:45:12 - SUCCESS: User fazil created
2026-10-12 21:46:01 - SUCCESS: Group developers created
2026-10-12 21:46:35 - SUCCESS: fazil added to group developers
2026-10-12 21:48:10 - SUCCESS: Backup created for fazil
```

You can monitor the log file with:

```bash
tail -f logs/user_management.log
```

## .gitignore

Backup archives and logs should not be pushed to GitHub.

Create a `.gitignore` file:

```text
backups/
logs/
*.tar.gz
```

This prevents large backup files and generated logs from being committed.

## Concepts Practiced

This project helped practice:

- Bash functions
- Variables
- `read`
- `if` conditions
- `case`
- `while` loops
- Exit codes
- `$?`
- Function arguments using `$1`
- Linux user management
- Linux group management
- File and directory checks
- `tar` archives
- Logging
- Input validation
- File permissions
- Basic system administration

## Future Improvements

Possible improvements include:

- Automatic scheduled backups using cron
- Backup retention policy
- Backup before deleting a user
- Password creation for new users
- Better username validation
- Group deletion
- Backup size reporting
- Email notifications
- Configuration file support

## Author

Mohamed Fazil

## Purpose

This project was created as a hands-on Linux and DevOps shell scripting project to automate common system administration tasks and strengthen practical Bash scripting skills.
