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
    exit 1
elif [[ "$imageName" =~ [\0/] ]]; then
    echo "Invalid input: Invalid characters." >&2
    exit 1
elif [[ ${#imageName} -gt 255 ]]; then
    echo "Invalid input: Name exceeds 255 characters." >&2
    exit 1
else
    echo "Filename: $imageName"
fi

echo "Ready to begin downloading..."

downloadedFile="downloadedFile"
wget -q $webImage -O downloadedFile
if [[ $? -ne 0 ]]; then
    echo "Download failed." >&2
    exit 1
fi

echo "File downloaded. Scanning image..."

clamscan --no-summary -i "$downloadedFile"
virusResult=$?
if [[ $virusResult -eq 0 ]]; then
    echo "File has no virus. Checking image type..."
else
    echo "Virus detected detected or unable to complete scan. Exiting program." >&2
    exit 1
fi

originalFileName=$(echo "$webImage" | rev | cut -d "/" -f 1 | rev)
ext=$(echo "$originalFileName" | rev | cut -d "." -f 1 | rev)
if [[ $ext == "jpg" || $ext == "jpeg" ]]; then 
    cp "$downloadedFile" fileToName.jpg
    echo "No conversion necessary. File already JPG."
else
    echo "Converting file to jpg..."
    convert "$downloadedFile" fileToName.jpg
    echo "Conversion complete."
fi

echo "Grabbing resolution..."

exit 0
