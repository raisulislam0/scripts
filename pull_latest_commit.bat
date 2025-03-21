# Create destination directory if it doesn't exist
mkdir src_versions -ErrorAction Ignore

# Get only the most recent commit hash that affected the src/ directory
$latestCommit = git log -n 1 --format="%H" -- src/

Write-Host "Checking out latest commit: $latestCommit"

# Checkout the 'src' directory from the latest commit
git checkout $latestCommit -- src/

# Create destination folder
$destination = "src_versions\src_$latestCommit"
mkdir $destination -ErrorAction Ignore

# Copy all files from the 'src' directory to the destination
if (Test-Path src) {
    # Copy only files directly in the src directory (not subdirectories)
    Get-ChildItem -Path src -File | ForEach-Object {
        Copy-Item $_.FullName -Destination $destination
        Write-Host "Copied $($_.Name) to $destination"
    }
    
    # Check if any files were copied
    $fileCount = (Get-ChildItem -Path $destination -File).Count
    Write-Host "Total files copied: $fileCount"
} else {
    Write-Host "Error: src directory not found after checkout"
}