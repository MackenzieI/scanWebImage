#!/bin/bash

echo -n "Please enter a direct URL to an image file: "
read webImage
if [[ -z "$webImage" ]]; then
    echo "Invalid input: Empty." >&2
    exit 1
elif ! curl -sI "$webImage" | grep -qiE 'Content-Type: image/(jpg|jpeg|png|gif|bmp|webp|tiff|svg\+xml)'; then
    echo "Invalid input: Not an image." >&2
    exit 1
else
    echo "Image URL path: $webImage"
fi

echo -n "Please enter the name you would like to save this file as: "
read imageName
if [[ -z "$imageName" ]]; then
    echo "Invalid input: Empty." >&2
    exit 1
elif [[ -e $imageName ]]; then
    echo "A file with this name already exists." >&2
    exit 0
elif [[ "$imageName" =~ [\0/\] ]]; then
    echo "Invalid input: Invalid characters." >&2
elif [[ ${#imageName} -gt 255 ]]; then
    echo "Invalid input: Name exceeds 255 characters." >&2
else
    echo "Filename: $imageName"
fi

echo "Ready to begin downloading..."

exit 0
