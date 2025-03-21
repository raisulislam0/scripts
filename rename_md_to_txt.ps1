Get-ChildItem -Path . -Filter "*.md" | ForEach-Object {
    
    Rename-Item -Path $_.FullName -NewName ($_.BaseName + ".txt")
}

Write-Host "All .md files have been renamed to .txt."
