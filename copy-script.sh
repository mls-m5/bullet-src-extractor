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

# Call the function with the provided arguments
find_unique_tags bullet3 stripped

