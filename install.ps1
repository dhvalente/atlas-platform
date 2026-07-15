$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Define destination directory in user profile (avoids permission issues)
$BIN_DIR = "$env:USERPROFILE\atlas-bin"
$ATLAS_SERVICES_DIR = "$env:USERPROFILE\.atlas\services\docker"
$EXE_NAME = "atlas.exe"

Write-Host "Starting Atlas project..." -ForegroundColor Cyan
Write-Host @'
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⢀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣾⠟⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⡇⠀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⡷⠛⠛⠛⠛⢀⠀⠠⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⢢⣶⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣶⣤⣤⠀⠀⠀⢈⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⡇⠀⠀⣸⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣶⣶⡿⠟⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠛⠛⢉⣉⠁⣶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⡆⢈⣉⣁⣰⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⡇⠈⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣯⣤⣤⣤⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡙⠛⠛⠛⢹⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢀⡶⣤⣤⣽⣿⡆⠀⣼⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠐⠊⠀⠀⠉⠙⠛⠃⠐⠛⠛⠒⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
'@ -ForegroundColor DarkCyan
go build -o $EXE_NAME

# Create directory if it does not exist
if (!(Test-Path -Path $BIN_DIR)) {
    Write-Host "Creating directory $BIN_DIR..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $BIN_DIR | Out-Null
}

Write-Host "Moving executable to $BIN_DIR..." -ForegroundColor Cyan
Move-Item -Path ".\$EXE_NAME" -Destination "$BIN_DIR\$EXE_NAME" -Force

Write-Host "Installing Docker services catalog at $ATLAS_SERVICES_DIR..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $ATLAS_SERVICES_DIR -Force | Out-Null
Copy-Item -Path ".\services\docker\docker-compose.yml" -Destination "$ATLAS_SERVICES_DIR\docker-compose.yml" -Force

# Ensure user PATH contains atlas bin directory
$USER_PATH = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($USER_PATH -notmatch [regex]::Escape($BIN_DIR)) {
    Write-Host "Adding $BIN_DIR to user PATH..." -ForegroundColor Cyan
    $NEW_PATH = "$USER_PATH;$BIN_DIR"
    [Environment]::SetEnvironmentVariable("PATH", $NEW_PATH, "User")
    Write-Host "PATH updated. Open a NEW terminal to use atlas." -ForegroundColor Yellow
} else {
    Write-Host "Directory is already in PATH." -ForegroundColor Green
}

Write-Host "Install complete. Open a NEW terminal and run: atlas services configure" -ForegroundColor Green