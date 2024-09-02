#!/bin/bash

# Function to list all tags in the specified subdirectory
list_tags() {
    local dir_path=$1

    # Check if the directory exists
    if [ ! -d "$dir_path" ]; then
        echo "Directory $dir_path not found"
        exit 1
    fi

    # Navigate to the specified directory
    cd "$dir_path" || { echo "Failed to navigate to $dir_path"; exit 1; }

    # Check if the directory is a Git repository
    if [ ! -d ".git" ]; then
        echo "Directory $dir_path is not a Git repository"
        exit 1
    fi

    # List all tags, one per line
    git tag -l
}

# Function to find tags that exist in bullet3 but not in stripped
find_unique_tags() {
    local dir_bullet3=$1
    local dir_stripped=$2

    # Get tags from bullet3
    tags_bullet3=$(list_tags "$dir_bullet3")

    # Get tags from stripped
    tags_stripped=$(list_tags "$dir_stripped")

    echo "Tags in $dir_bullet3 but not in $dir_stripped:"

    # Compare the tags
    for tag in $tags_bullet3; do
        if ! echo "$tags_stripped" | grep -q "^$tag$"; then
            echo "$tag"
        fi
    done
}

#find_unique_tags bullet3 stripped
#

# Function to checkout a tag in bullet3, sync to stripped, and commit
checkout_and_sync() {
    local tag_name=$1

    # Hardcoded directories (use realpath to get absolute paths)
    bullet3_dir=$(realpath "./bullet3")
    stripped_dir=$(realpath "./stripped")

    # Check if the bullet3 directory is a Git repository
    if [ ! -d "$bullet3_dir/.git" ]; then
        echo "Directory $bullet3_dir is not a Git repository"
        exit 1
    fi

    # Check if the stripped directory is a Git repository
    if [ ! -d "$stripped_dir/.git" ]; then
        echo "Directory $stripped_dir is not a Git repository"
        exit 1
    fi

    # Navigate to the bullet3 directory
    cd "$bullet3_dir" || { echo "Failed to navigate to $bullet3_dir"; exit 1; }

    # Checkout the specified tag
    git checkout "$tag_name" || { echo "Tag $tag_name not found in $bullet3_dir"; exit 1; }

    # Sync src directory from bullet3 to stripped using rsync
    rsync -av --delete "$bullet3_dir/src/" "$stripped_dir/src/" || { echo "Rsync failed"; exit 1; }

    # Navigate to the stripped directory
    cd "$stripped_dir" || { echo "Failed to navigate to $stripped_dir"; exit 1; }

    # Add changes to the Git index
    git add . || { echo "Git add failed"; exit 1; }

    # Commit the changes with the tag name as the commit message
    git commit -m "$tag_name" || { echo "Git commit failed"; exit 1; }

    echo "Checked out $tag_name in $bullet3_dir, synced to $stripped_dir, and committed."
}

# Call the function with the provided tag name
#checkout_and_sync "$1"
#


