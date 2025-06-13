# PowerShell setup script for git-cm-lite

# Check if running in PowerShell
if ($PSVersionTable.PSEdition -eq 'Desktop' -or $PSVersionTable.PSVersion.Major -ge 5) {
    Write-Host "PowerShell environment detected"
} else {
    Write-Error "This script requires PowerShell"
    exit 1
}

# Check if git is installed
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git is not installed or not in PATH"
    exit 1
}

# Check if running in a Git repository
$isGitRepo = git rev-parse --is-inside-work-tree 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Error "Not in a git repository. Please run this script from within a Git repository."
    exit 1
}

# Check if git-cm-lite.sh exists
if (!(Test-Path "./git-cm-lite.sh")) {
    Write-Error "git-cm-lite.sh not found in the current directory."
    Write-Error "Please make sure you run this script from the directory containing git-cm-lite.sh."
    exit 1
}

# Set up the Git alias with proper path escaping for Windows
$scriptPath = (Resolve-Path "./git-cm-lite.sh").Path
# Convert Windows path to Git Bash style path
$scriptPath = $scriptPath -replace '^([A-Za-z]):', '/$1' -replace '\\', '/'
git config --local alias.cm "!sh `"$scriptPath`""

Write-Host "`nGit alias 'cm' has been set up successfully!"
Write-Host "You can now use 'git cm' to create conventional commits."
