#!/bin/bash

# ==============================
# Linux User & Backup Manager
# ==============================

BACKUP_DIR="./backups"
LOG_DIR="./logs"
LOG_FILE="$LOG_DIR/user_management.log"

# Create required directories if they do not exist
mkdir -p "$BACKUP_DIR"
mkdir -p "$LOG_DIR"


# ==============================
# Logging Function
# ==============================

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}


# ==============================
# Create User
# ==============================

create_user() {

    read -p "Enter username: " username

    if [ -z "$username" ]; then
        echo "Username cannot be empty"
        log_message "FAILED: Empty username entered"
        return
    fi

    if id "$username" &>/dev/null; then
        echo "User $username already exists"
        log_message "FAILED: User $username already exists"
        return
    fi

    sudo useradd -m "$username"

    if [ $? -eq 0 ]; then
        echo "User $username created successfully"
        log_message "SUCCESS: User $username created"
    else
        echo "Failed to create user"
        log_message "FAILED: Could not create user $username"
    fi
}


# ==============================
# Delete User
# ==============================

delete_user() {

    read -p "Enter username to delete: " username

    if ! id "$username" &>/dev/null; then
        echo "User $username does not exist"
        log_message "FAILED: Delete requested for non-existing user $username"
        return
    fi

    read -p "Are you sure you want to delete $username? (y/n): " confirm

    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then

        sudo userdel -r "$username"

        if [ $? -eq 0 ]; then
            echo "User $username deleted successfully"
            log_message "SUCCESS: User $username deleted"
        else
            echo "Failed to delete user"
            log_message "FAILED: Could not delete user $username"
        fi

    else
        echo "User deletion cancelled"
        log_message "CANCELLED: User deletion for $username"
    fi
}


# ==============================
# Create Group
# ==============================

create_group() {

    read -p "Enter group name: " groupname

    if [ -z "$groupname" ]; then
        echo "Group name cannot be empty"
        log_message "FAILED: Empty group name entered"
        return
    fi

    if getent group "$groupname" > /dev/null; then
        echo "Group $groupname already exists"
        log_message "FAILED: Group $groupname already exists"
        return
    fi

    sudo groupadd "$groupname"

    if [ $? -eq 0 ]; then
        echo "Group $groupname created successfully"
        log_message "SUCCESS: Group $groupname created"
    else
        echo "Failed to create group"
        log_message "FAILED: Could not create group $groupname"
    fi
}


# ==============================
# Add User To Group
# ==============================

add_user_to_group() {

    read -p "Enter username: " username
    read -p "Enter group name: " groupname

    if ! id "$username" &>/dev/null; then
        echo "User $username does not exist"
        log_message "FAILED: User $username does not exist"
        return
    fi

    if ! getent group "$groupname" > /dev/null; then
        echo "Group $groupname does not exist"
        log_message "FAILED: Group $groupname does not exist"
        return
    fi

    sudo usermod -aG "$groupname" "$username"

    if [ $? -eq 0 ]; then
        echo "$username added to $groupname successfully"
        log_message "SUCCESS: $username added to group $groupname"
    else
        echo "Failed to add user to group"
        log_message "FAILED: Could not add $username to group $groupname"
    fi
}


# ==============================
# List Users
# ==============================

list_users() {

    echo
    echo "Linux Users:"
    echo "----------------------------"

    cut -d: -f1 /etc/passwd

    echo "----------------------------"

    log_message "INFO: User list displayed"
}


# ==============================
# Backup User
# ==============================

backup_user() {

    read -p "Enter username to backup: " username

    HOME_DIR="/home/$username"

    if [ ! -d "$HOME_DIR" ]; then
        echo "Home directory $HOME_DIR does not exist"
        log_message "FAILED: Backup requested for $username - home directory missing"
        return
    fi

    timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

    backup_file="$BACKUP_DIR/${username}_${timestamp}.tar.gz"

    sudo tar -czf "$backup_file" "$HOME_DIR"

    if [ $? -eq 0 ]; then

        echo "Backup created successfully"
        echo "Backup location: $backup_file"

        log_message "SUCCESS: Backup created for $username at $backup_file"

    else

        echo "Backup failed"

        log_message "FAILED: Backup failed for $username"

    fi
}


# ==============================
# Restore Backup
# ==============================

restore_backup() {

    echo
    echo "Available backups:"
    echo "----------------------------"

    ls -1 "$BACKUP_DIR"

    echo "----------------------------"

    read -p "Enter backup filename: " backup_name

    backup_file="$BACKUP_DIR/$backup_name"

    if [ ! -f "$backup_file" ]; then
        echo "Backup file does not exist"
        log_message "FAILED: Restore requested for missing backup $backup_name"
        return
    fi

    sudo tar -xzf "$backup_file" -C /

    if [ $? -eq 0 ]; then
        echo "Backup restored successfully"
        log_message "SUCCESS: Backup $backup_name restored"
    else
        echo "Restore failed"
        log_message "FAILED: Could not restore backup $backup_name"
    fi
}


# ==============================
# Main Menu
# ==============================

while true
do

    echo
    echo "===================================="
    echo "     Linux User & Backup Manager"
    echo "===================================="
    echo "1. Create User"
    echo "2. Delete User"
    echo "3. Create Group"
    echo "4. Add User to Group"
    echo "5. List Users"
    echo "6. Backup User"
    echo "7. Restore Backup"
    echo "8. Exit"
    echo "===================================="

    read -p "Choose an option [1-8]: " choice

    case "$choice" in

        1)
            create_user
            ;;

        2)
            delete_user
            ;;

        3)
            create_group
            ;;

        4)
            add_user_to_group
            ;;

        5)
            list_users
            ;;

        6)
            backup_user
            ;;

        7)
            restore_backup
            ;;

        8)
            echo "Exiting User Management System..."
            log_message "INFO: Program exited"
            exit 0
            ;;

        *)
            echo "Invalid option. Please choose between 1 and 8."
            log_message "FAILED: Invalid menu option entered: $choice"
            ;;

    esac

done
