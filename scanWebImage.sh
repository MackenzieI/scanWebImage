#!/bin/bash

echo -n "Please enter a direct URL to an image file: "
read webImage
if [[ -z "$webImage" ]]; then
    echo "Invalid input: Empty."
elif ! file --mime-type "$webImage" | grep -qE 'image/(jpg|jpeg|png|gif|bmp|webp|tiff|svg\+xml)'; then
    echo "Invalid input: Not an image."
fi

echo -n "Please enter the name you would like to save this file as: "
read imageName
if [[ -z "$webImage" ]]; then
    echo "Invalid input: Empty."
    #check that name is valid too
fi

exit 0
