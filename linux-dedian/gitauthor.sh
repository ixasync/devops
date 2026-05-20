#!/bin/bash

# if <command> ; then ... fi  by check exit code(0 - true, not 0 -i false)
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Not a git repository"
    exit 1
fi

cur_email=$(git config user.email)
cur_name=$(git config user.name)

new_email="$1"

if [ -z "$new_email" ]; then
	echo "user.name $cur_name"
	echo "user.email $cur_email"
	exit 0
fi

# check email format
if ! echo "$new_email"|grep -q "@" ; then
	echo "Invalid email: $new_email"
	exit 1
fi


new_name="${new_email%@*}"

# only config for current repository
git config user.name "$new_name"
git config user.email "$new_email"

echo "Success to update: user.name=$new_name , user.email=$new_email"
