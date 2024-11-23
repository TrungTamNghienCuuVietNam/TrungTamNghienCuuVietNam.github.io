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

  # Create the info.json file in the new directory
  info_json="$new_dir/info.json"

  # Get the width and height of the image using 'identify' from ImageMagick
  # (Assuming ImageMagick is installed, otherwise install it with 'apt install imagemagick' or 'brew install imagemagick')
  width=$(magick identify -format "%w" "$img")
  height=$(magick identify -format "%h" "$img")

  # Construct the ID URL
  img_id="https://trungtamnghiencuuvietnam.github.io/images/$img_name"

  # Create the JSON content
  cat > "$info_json" <<EOF
{
  "@context": "http://iiif.io/api/image/3/context.json",
  "id": "$img_id",
  "type": "ImageService3",
  "protocol": "http://iiif.io/api/image",
  "profile": "level0",
  "width": $width,
  "height": $height,
  "sizes": [
    { "width": $width, "height": $height },
    { "width": $(($width * 80 / 100)), "height": $(($height * 80 / 100)) },
    { "width": $(($width * 60 / 100)), "height": $(($height * 60 / 100)) },
    { "width": $(($width * 40 / 100)), "height": $(($height * 40 / 100)) }
  ]
}
EOF

  # Create the full folder structure
  full_max="$new_dir/full/max/0"
  mkdir -p "$full_max"

  # Copy the image to the '0' folder and rename it to 'default.jpg'
  cp "$img" "$full_max/default.jpg"

  full_full="$new_dir/full/full/0"
  mkdir -p "$full_full"

  cp "$img" "$full_full/default.jpg"

  # Create the full/{width},{height}/0 folder structure
  full_res_dir="$new_dir/full/$width,$height/0"
  mkdir -p "$full_res_dir"

  # Copy the image to the new resolution folder and rename it to 'default.jpg'
  cp "$img" "$full_res_dir/default.jpg"

  # Create resized images at 80%, 60%, and 40%
  for scale in 80 60 40; do
    scaled_width=$(($width * $scale / 100))
    scaled_height=$(($height * $scale / 100))
    scale_dir="$new_dir/full/$scaled_width,$scaled_height/0"
    mkdir -p "$scale_dir"

    # Resize the image and save it
    magick "$img" -resize "${scaled_width}x${scaled_height}" "$scale_dir/default.jpg"
  done

done
