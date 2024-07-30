#!/bin/bash

# To import the environment variables from .env file
eval "$(
  cat .env | awk '!/^\s*#/' | awk '!/^\s*$/' | while IFS='' read -r line; do
    key=$(echo "$line" | cut -d '=' -f 1)
    value=$(echo "$line" | cut -d '=' -f 2-)
    echo "export $key=\"$value\""
  done
)"

# Check the authentication via token on github
function set_authentication {
    status_code=$(curl -w "%{http_code}\n" -o /dev/null -s -i -u "$GITHUB_USERNAME:$GITHUB_TOKEN" "https://api.github.com/users/$GITHUB_USERNAME")
    if [ $status_code != "200" ]
    then
        echo "Authentication failed"
        exit 1
    fi
}

# List of all branches
function list_branches {
    search_exp=$1
    if [ -z "$search_exp" ]
    then
        search_exp=".[] | .name + \";\" + .commit.sha"
    fi

    branches=$(curl -s "https://api.github.com/repos/$GITHUB_USERNAME/$GITHUB_REPO/branches" | jq -r "$search_exp")
    echo $branches
}

# Get branch info
function get_branch_info {
    search_exp=$2
    if [ -z "$search_exp" ]
    then
        search_exp=".name"
    fi

    info=$(curl -s "https://api.github.com/repos/$GITHUB_USERNAME/$GITHUB_REPO/branches/$1" | jq -r "$search_exp")
    echo $info
}

# get the commit information from the service
function get_commit_info {
    response=$(curl -s "https://api.github.com/repos/$GITHUB_USERNAME/$GITHUB_REPO/commits/$1" | jq -r ".commit.author.date + \";\" + .commit.author.name")
    IFS=';'
    read -a parts <<< "$response"
    echo "$(date -d ${parts[0]}) - ${parts[1]}" # here to change the date format with: +(%Y%m...
}

# Get the branch information by the commit
function get_branches_info {
    for branch in $@
    do
        IFS=';'
        read -a parts <<< "$branch"
        echo "${parts[0]} - $(get_commit_info ${parts[1]})"
    done
}

# deletes the old branches
function delete_old_branches {
    found=$false
    for branch in $@
    do
        # read -a parts <<< "$branch"
        branch_name=$(echo $branch | cut -d ";" -f 1)
        protected=$(echo $branch | cut -d ";" -f 2)

        if [[ $protected == "false" ]]
        then
            branch_date=$(get_branch_info "$branch_name" ".commit.commit.author.date")
            branch_date=$(date -d $branch_date +%s)
            limit_date=$(date -d "$DELETE_OLDER_THAN" +%s)
            
            if [[ "$branch_date" < "$limit_date" ]]
            then
                found=$true
                status=$(curl -w "%{http_code}\n" -o /dev/null -s -X DELETE "https://api.github.com/repos/$GITHUB_USERNAME/$GITHUB_REPO/git/refs/$branch_name")
                if [ "$status" -gt 200 ] || [ "$status" -lt 299 ]
                then
                    echo "Se ha eliminado la rama: $branch_name"
                fi
            fi
        fi
    done

    if [ ! $found ]
    then
        echo "No se encontraron ramas para eliminar"
    fi 
}

# 1. Get the authentication
set_authentication

# 2. Create the file
# BRANCHES_FILE_NAME="branches.txt"
# if [ -f $BRANCHES_FILE_NAME ] ; then
#     rm "$BRANCHES_FILE_NAME"
# fi
# get_branches_info $(list_branches) >> $BRANCHES_FILE_NAME

# 3. Delete the branches
delete_old_branches $(list_branches ".[] | .name + \";\" + (.protected|tostring)")
