$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

function Setup-Windows {
    Write-Host "Setting up Windows dotfiles..." -ForegroundColor Green

    $files = Get-ChildItem -Path "$ScriptDir\windows" -File | Where-Object { $_.Name -ne 'setup.ps1' }

    foreach ($file in $files) {
        $targetPath = Join-Path $HOME $file.Name
        $sourcePath = $file.FullName

        if (Test-Path $targetPath) {
            $overwrite = Read-Host "  $($file.Name) already exists. Overwrite? (y/n)"
            if ($overwrite -ne 'y') {
                Write-Host "  Skipping $($file.Name)" -ForegroundColor Yellow
                continue
            }
        }

        try {
            Copy-Item -Path $sourcePath -Destination $targetPath -Force
            Write-Host "  Copied: $($file.Name) -> $targetPath" -ForegroundColor Green
        } catch {
            Write-Host "  ERROR: Failed to copy $($file.Name): $_" -ForegroundColor Red
        }
    }

    Write-Host "`nSetup complete!" -ForegroundColor Green
}

function Test-Command {
    param([string]$Command)
    try {
        if (Get-Command $Command -ErrorAction Stop) {
            return $true
        }
    } catch {
        return $false
    }
}

function Check-Utils {
    Write-Host "Checking utilities..." -ForegroundColor Green

    $utils = @('git', 'vim', 'code')

    foreach ($util in $utils) {
        if (Test-Command $util) {
            Write-Host "  [OK] $util" -ForegroundColor Green
        } else {
            Write-Host "  [MISSING] Cannot find $util" -ForegroundColor Red
        }
    }
}

Write-Host "`nWindows Dotfiles Setup" -ForegroundColor Cyan
Write-Host "=====================" -ForegroundColor Cyan
Write-Host "1) Setup Windows dotfiles"
Write-Host "2) Check utilities"
Write-Host "3) Exit"
Write-Host ""

$choice = Read-Host "Select option (1-3)"

switch ($choice) {
    "1" {
        Setup-Windows
    }
    "2" {
        Check-Utils
    }
    "3" {
        Write-Host "Exiting..." -ForegroundColor Yellow
        exit
    }
    default {
        Write-Host "Invalid option. Exiting..." -ForegroundColor Red
        exit 1
    }
}
