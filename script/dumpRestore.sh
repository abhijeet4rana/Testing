#!/bin/bash

# Ask user for the main folder location (without the trailing /)
echo "Enter the main folder location (without a trailing /):"
read main_folder

# Add the trailing slash to the folder path
main_folder="$main_folder/"

# Check if the folder exists
if [[ ! -d "$main_folder" ]]; then
    echo "Error: Directory does not exist."
    exit 1
fi

# Find all zip files in the specified folder
zip_files=($(find "$main_folder" -maxdepth 1 -name "*.zip"))

# Check if any zip files are found
if [[ ${#zip_files[@]} -eq 0 ]]; then
    echo "Error: No zip files found in the given folder."
    exit 1
fi

# Display the list of found zip files (showing only the file names)
echo "Found the following zip files:"
for i in "${!zip_files[@]}"; do
    zip_name=$(basename "${zip_files[$i]}")
    echo "$((i+1)): $zip_name"
done

# Ask the user to select a zip file
echo "Enter the number of the zip file you want to restore:"
read zip_choice

# Validate the user input
if [[ ! "$zip_choice" =~ ^[0-9]+$ ]] || (( zip_choice < 1 )) || (( zip_choice > ${#zip_files[@]} )); then
    echo "Invalid choice. Please enter a valid number from the list."
    exit 1
fi

# Get the full path of the selected zip file
selected_zip="${zip_files[$((zip_choice-1))]}"

# Get the name of the zip file without the extension
zip_name=$(basename "$selected_zip" .zip)

# Create the 'dump' directory if it doesn't exist
mkdir -p dump

# Create a directory for the zip file inside the 'dump' directory
mkdir -p dump/"$zip_name"

# Extract the selected zip file into the new folder
echo "Extracting $selected_zip to dump/$zip_name..."
unzip "$selected_zip" -d dump/"$zip_name"

# Check if the extraction was successful
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to extract the zip file."
    exit 1
fi

# Run the mongorestore command
echo "Running mongorestore for the extracted dump..."
mongorestore

# Check if the mongorestore command was successful
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to restore MongoDB dump."
    exit 1
else
    echo "MongoDB restore completed successfully."
fi
