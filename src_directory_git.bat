mkdir src_versions -ErrorAction Ignore
$commits = git log --format="%H" -- src/

foreach ($commit in $commits) {
    Write-Host "Checking out commit: $commit"

    # Remove existing 'src' before checking out new one
    if (Test-Path src) {
        Remove-Item -Recurse -Force src
    }

    # Checkout the 'src' directory from the commit
    git checkout $commit -- src/

    # Ensure the destination folder exists
    $destination = "src_versions\src_$commit"
    mkdir $destination -ErrorAction Ignore

    # Copy only files from the 'src' directory (not subdirectories)
    Get-ChildItem -Path src -File | ForEach-Object {
        Copy-Item $_.FullName -Destination $destination
    }
}
