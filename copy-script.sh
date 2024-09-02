#!/bin/bash

# Function to list all tags in the specified subdirectory
list_tags() {
    local dir_path=$1

    # Resolve absolute path of the directory
    dir_path=$(realpath "$dir_path")

    # Check if the directory exists
    if [ ! -d "$dir_path" ]; then
        echo "Directory $dir_path not found"
        exit 1
    fi

    # Check if the directory is a Git repository
    if [ ! -d "$dir_path/.git" ]; then
        echo "Directory $dir_path is not a Git repository"
        exit 1
    fi

    # List all tags, one per line using git -C to specify the directory
    git -C "$dir_path" tag -l
}

# Function to find tags that exist in bullet3 but not in stripped

find_unique_tags() {
    local dir_bullet3=$1
    local dir_stripped=$2

    # Resolve absolute paths
    dir_bullet3=$(realpath "$dir_bullet3")
    dir_stripped=$(realpath "$dir_stripped")

    # Get tags from bullet3
    tags_bullet3=$(list_tags "$dir_bullet3")

    # Get tags from stripped
    tags_stripped=$(list_tags "$dir_stripped")

    # Compare the tags
    for tag in $tags_bullet3; do
        if ! echo "$tags_stripped" | grep -q "^$tag$"; then
            echo "$tag"
        fi
    done
}

#find_unique_tags bullet3 stripped
#


# Function to checkout a tag in bullet3, sync to stripped, copy LICENSE.txt, and commit
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

    # Checkout the specified tag using git -C to specify the directory
    git -C "$bullet3_dir" checkout "$tag_name" || { echo "Tag $tag_name not found in $bullet3_dir"; exit 1; }

    # Sync src directory from bullet3 to stripped using rsync
    rsync -av --delete "$bullet3_dir/src/" "$stripped_dir/src/" || { echo "Rsync failed"; exit 1; }

    # Check if LICENCE.txt exists and copy it if it does
    if [ -f "$bullet3_dir/LICENCE.txt" ]; then
        cp "$bullet3_dir/LICENCE.txt" "$stripped_dir/" || { echo "Failed to copy LICENCE.txt"; exit 1; }
    else
        echo "LICENCE.txt not found in $bullet3_dir, skipping copy."
    fi

    # Add changes to the Git index using git -C
    git -C "$stripped_dir" add . || { echo "Git add failed"; exit 1; }

    # Check if there are any changes to commit
    if git -C "$stripped_dir" diff --cached --quiet; then
        echo "No changes to commit for tag $tag_name."
    else
        # Commit the changes with the tag name as the commit message using git -C
        git -C "$stripped_dir" commit -m "$tag_name" || { echo "Git commit failed"; exit 1; }
        echo "Checked out $tag_name in $bullet3_dir, synced to $stripped_dir, copied LICENCE.txt (if it existed), and committed."
    fi

    # Tag the commit with the tag name
    git -C "$stripped_dir" tag "$tag_name" || { echo "Failed to create tag $tag_name"; exit 1; }

    echo "Tag $tag_name created in $stripped_dir."
}


# Function to process each tag from find_unique_tags and pass it to checkout_and_sync
process_tags() {
    local bullet3_dir=$1
    local stripped_dir=$2

    # Get the list of unique tags from find_unique_tags function
    unique_tags=$(find_unique_tags "$bullet3_dir" "$stripped_dir")

    # Process each tag
    echo "$unique_tags" | while read -r tag; do
        if [ -n "$tag" ]; then
            echo "Processing tag: $tag"
            checkout_and_sync "$tag"
        fi
    done
}

# Example usage: pass the paths to the bullet3 and stripped directories
bullet3_dir="`realpath ./bullet3`"
stripped_dir="`realpath ./stripped`":

# Call the process_tags function with the paths to bullet3 and stripped directories
process_tags "$bullet3_dir" "$stripped_dir"



