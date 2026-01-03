#Requires -RunAsAdministrator

Read-Host "Push Enter to start package installation..."

# PowerShell script to install packages and set PATH
# Install Git
& winget install --id Git.Git -e --source winget

# Install TortoiseGit
& winget install --id TortoiseGit.TortoiseGit -e --source winget

# Install 7-Zip
& winget install --id 7zip.7zip -e --source winget

# Install Google Cloud CLI
& winget install --id Google.CloudSDK

# Get current system PATH
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")

# Function to join paths, remove duplicates, and check existence
function Join-PathCustom {
    param (
        [string]$existingPath,
        [string]$newPaths
    )

    Out-

    $paths = $existingPath -split ';'
    $newPathList = $newPaths -split ';'

    foreach ($newPath in $newPathList) {
        if ($newPath -and (Test-Path $newPath)) {
            if ($paths -notcontains $newPath) {
                $paths += $newPath
            }
        }
    }

    return $paths -join ';'
}

# Check Git installation path
$gitPath = ""
if (Test-Path "C:\Program Files\Git\cmd") {
    $gitPath = "C:\Program Files\Git\cmd"
} elseif (Test-Path "C:\Program Files\Git\bin") {
    $gitPath = "C:\Program Files\Git\bin"
}

# Check 7-Zip installation path
$sevenZipPath = ""
if (Test-Path "C:\Program Files\7-Zip") {
    $sevenZipPath = "C:\Program Files\7-Zip"
}

# Add Git path if found
if ($gitPath) {
    $currentPath = Join-PathCustom -existingPath $currentPath -newPaths $gitPath
}

# Add 7-Zip path if found
if ($sevenZipPath) {
    $currentPath = Join-PathCustom -existingPath $currentPath -newPaths $sevenZipPath
}

# Clean up semicolons
$currentPath = $currentPath.TrimStart(';').TrimEnd(';')

# Set new PATH
[Environment]::SetEnvironmentVariable("PATH", $currentPath, "Machine")

Write-Host "Installation and PATH setup completed."
Read-Host "Push Enter to exit..."