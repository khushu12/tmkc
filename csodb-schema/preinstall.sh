#!/bin/bash

echo -e "\n\033[1;34m Pre Install Hook - Started \033[0m"

DB_FILE="/opt/celona/etc/db.yaml"

if [[ -f "$DB_FILE" ]]; then
    echo -e " $DB_FILE file exists"
    if grep -q 'DbEnv' $DB_FILE; then
        echo -e "\033[1;33m DbEnv already exists within $DB_FILE \033[0m"
    else
        echo -e "\033[1;34m Adding DbEnv to $DB_FILE file - Started \033[0m"
        DB_VAL="DbEnv: `grep '^CfgmDbUser: ' $DB_FILE | cut -d' ' -f2 | cut -d'_' -f2`"
        echo -e "\033[1;33m Value Appended - $DB_VAL \033[0m"
        echo "$DB_VAL" >> $DB_FILE
        echo -e "\033[1;34m Adding DbEnv to $DB_FILE file - Completed \033[0m"
    fi
    if grep -q 'DbSuffix' $DB_FILE; then
        echo -e "\033[1;33m DbSuffix already exists within $DB_FILE \033[0m"
    else
        echo -e "\033[1;34m Adding DbSuffix to $DB_FILE file - Started \033[0m"
        DB_SUFFIX="DbSuffix: `grep '^CfgmDbUser: ' $DB_FILE | cut -d' ' -f2 | cut -d'_' -f3-4`"
        echo -e "\033[1;33m Value Appended - $DB_SUFFIX \033[0m"
        echo -en "\n$DB_SUFFIX" >> $DB_FILE
        echo -e "\033[1;34m Adding DbSuffix to $DB_FILE file - Completed \033[0m"
    fi
else
    echo -e "\033[1;31m $DB_FILE doesn't exist \033[0m"
    echo -e "\n\033[1;31m Pre Install Hook - FAILED \n Exiting \033[0m"
    exit 1
fi
echo -e "\033[1;32m Pre Install Hook - Completed \033[0m"
exit 0
