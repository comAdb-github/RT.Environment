# Requires -RunAsAdministrator
# --- PowerShell 実行ポリシーをこのプロセスだけ Bypass ---
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# Set console and output encoding to UTF-8 to prevent garbled characters
cmd /c chcp 65001 > $null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8


# --- 管理者権限チェック ---
$IsAdmin = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $IsAdmin) {
    Write-Host "管理者権限で再実行します...xxxxx"

    # 自分自身のスクリプトパスを取得
    $script = $PSCommandPath

    # PowerShell Core (pwsh) が利用可能かチェック
    $psCommand = if (Get-Command pwsh -ErrorAction SilentlyContinue) { "pwsh" } else { "powershell" }

    # 管理者権限で自分自身を再実行（実行ポリシーを設定してからスクリプトを実行）
    Start-Process $psCommand -Verb RunAs -ArgumentList "-Command `"Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; & '$script'`""

    # 現在のプロセスは終了  
    exit
}
Read-Host "管理者権限で実行されています..."

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


#############################################
# Main Routine
#############################################
try {
    # Check Git installation path
    Write-Host "Checking Git installation path...";
    $gitPath = "";
    if (Test-Path "C:\Program Files\Git\cmd") {
        $gitPath = "C:\Program Files\Git\cmd";
    } elseif (Test-Path "C:\Program Files\Git\bin") {
        $gitPath = "C:\Program Files\Git\bin";
    }

    # Check 7-Zip installation path
    Write-Host "Checking 7-Zip installation path...";
    $sevenZipPath = "";
    if (Test-Path "C:\Program Files\7-Zip") {
        $sevenZipPath = "C:\Program Files\7-Zip";
    }

    # Check GCloud installation path
    Write-Host "Checking GCloud installation path...";
    $gcloudPath = ""
    if (Test-Path "C:\Program Files (x86)\Google\Cloud SDK\google-cloud-sdk\bin") {
        $gcloudPath = "C:\Program Files (x86)\Google\Cloud SDK\google-cloud-sdk\bin";
    }

    # Add Git path if found
    Write-Host "Adding Git path...";
    if ($gitPath) {
        $currentPath = Join-PathCustom -existingPath $currentPath -newPaths $gitPath
    }

    # Add 7-Zip path if found
    Write-Host "Adding 7-Zip path..."
    if ($sevenZipPath) {
        $currentPath = Join-PathCustom -existingPath $currentPath -newPaths $sevenZipPath
    }

    # Add GCloud path if found
    Write-Host "Adding GCloud path..."
    if ($gcloudPath) {
        $currentPath = Join-PathCustom -existingPath $currentPath -newPaths $gcloudPath
    }

    # Clean up semicolons
    Write-Host "Trimming semi-colons..."
    $currentPath = $currentPath.TrimStart(';').TrimEnd(';')

    # Set new PATH
    Write-Host "Updating PATH..."
    Write-Host "Old PATH: $([Environment]::GetEnvironmentVariable("PATH", "Machine"))"
    Write-Host "New PATH: $currentPath"
    [Environment]::SetEnvironmentVariable("PATH", $currentPath, "Machine")

} catch {
    Write-Host "Error occurred: $_"
    Read-Host "Push Enter to exit..."
    exit 1
}

Write-Host "Installation and PATH setup completed."
Read-Host "Push Enter to exit..."