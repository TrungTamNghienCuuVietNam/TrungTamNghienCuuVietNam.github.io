#!/bin/bash

# Define the directories
original_dir="./original-images"
target_dir="./images"

# Create the target directory if it doesn't exist
mkdir -p "$target_dir"

# Loop through each .jpg file in the original-images directory
for img in "$original_dir"/*.jpg; do
  # Get the base name of the image (without the extension)
  img_name=$(basename "$img" .jpg)

  # Create the target subdirectory for this image in the images folder
  new_dir="$target_dir/$img_name"
  mkdir -p "$new_dir"

  # Copy or move the image to the new directory
#   cp "$img" "$new_dir/"  # Use cp for copying, or mv for moving

  # Print a message indicating the image has been copied
  echo "Copied $img to $new_dir/"
done
