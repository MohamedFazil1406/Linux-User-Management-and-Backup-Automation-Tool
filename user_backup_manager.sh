
BACKUP_DIR="./backups"
LOG_FILE="./logs/user_management.log"

create_user(){
        read -p "Enter username: " username

        sudo useradd -m "$username"

        if [ $? -eq 0 ]; then
                echo "User $username is created successfully"
        else
                echo "Failed to create user"
        fi
}

delete_user(){
	read -p "Enter to delete username: " username

	if id $username &>/dev/null; then 
		sudo userdel -r $username

		echo "Username $username deleted"
	else
		echo "user does not exist"
	fi	

}

create_group(){

	read -p "Enter the group name: " groupuser

	if getent groupuser > /dev/null; then
		echo "group alredy existed"

	else
		sudo groupadd "$groupuser"
		echo "Group $groupuser is created successfully"
	fi	
}

add_user_to_group() {

    read -p "Enter username: " username
    read -p "Enter group name: " groupname

    sudo usermod -aG "$groupname" "$username"

    if [ $? -eq 0 ]; then
        echo "$username added to $groupname successfully"
    else
        echo "Failed to add $username to $groupname"
    fi
}


echo "================================"
echo " Linux User & Backup Manager"
echo "================================"

echo "1. Create User"
echo "2. Delete User"
echo "3. Create Group"
echo "4. Add User to Group"
echo "5. List Users"
echo "6. Backup User"
echo "7. Restore Backup"
echo "8. Exit"

read -p "Choose an option: " choice


case $choice in

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
        echo "List users selected"
        ;;

    6)
        echo "Backup selected"
        ;;

    7)
        echo "Restore selected"
        ;;

    8)
        echo "Exiting..."
        exit 0
        ;;

    *)
        echo "Invalid option"
        ;;
esac


