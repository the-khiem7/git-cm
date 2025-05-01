# PowerShell setup script for git-cm-lite
# This script creates a Git alias that works with PowerShell in Visual Studio

# Check if the script is running in a Git repository
try {
    git rev-parse --is-inside-work-tree | Out-Null
} catch {
    Write-Error "Error: Not in a git repository. Please run this script from within a Git repository."
    exit 1
}

# Check if git-cm-lite.sh exists
if (-not (Test-Path -Path ".\git-cm-lite.sh")) {
    Write-Error "Error: git-cm-lite.sh not found in the current directory."
    Write-Error "Please make sure you run this script from the directory containing git-cm-lite.sh."
    exit 1
}

# Get the absolute path to git-cm-lite.sh
$scriptPath = (Get-Item ".\git-cm-lite.sh").FullName

# Escape backslashes for Git config
$escapedPath = $scriptPath.Replace("\", "/")

# Set up the Git alias with proper quoting for PowerShell
git config --local alias.cm "!sh `"$escapedPath`""

Write-Host "Git alias 'cm' has been set up successfully!" -ForegroundColor Green
Write-Host "You can now use 'git cm' to create conventional commits."
Write-Host ""
Write-Host "To use globally (not just in this repository), run the following in PowerShell:"
Write-Host "git config --global alias.cm `"!sh \`"$escapedPath\`"`""
Write-Host "But remember, the script must remain accessible from that path on your system."
Write-Host ""
Write-Host "This setup is optimized for Windows/PowerShell environments like Visual Studio."