#!/bin/sh
# .git-cm-setup.sh - Setup script for git-cm-lite
# This script creates a Git alias for the Commitizen-like CLI

# Check if the script is running in a Git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "Error: Not in a git repository. Please run this script from within a Git repository."
  exit 1
fi

# Check if git-cm-lite.sh exists
if [ ! -f "./git-cm-lite.sh" ]; then
  echo "Error: git-cm-lite.sh not found in the current directory."
  echo "Please make sure you run this script from the directory containing git-cm-lite.sh."
  exit 1
fi

# Detect OS for cross-platform compatibility
case "$(uname -s)" in
  Linux*|Darwin*|CYGWIN*|MINGW*|MSYS*)
    # Make the script executable on Unix-like systems
    chmod +x ./git-cm-lite.sh
    echo "Made script executable for Unix-like environment"
    ;;
  *)
    # On Windows/PowerShell we don't need chmod
    echo "Windows environment detected, skipping chmod"
    ;;
esac

# Set up the Git alias - using sh explicitly for cross-platform compatibility
git config --local alias.cm '!sh ./git-cm-lite.sh'

echo "Git alias 'cm' has been set up successfully!"
echo "You can now use 'git cm' to create conventional commits."
echo ""
echo "To use globally (not just in this repository), run:"
echo "git config --global alias.cm '!sh /path/to/git-cm-lite.sh'"
echo "But remember, the script must be accessible from that path on your system."

# Additional note for Windows users
case "$(uname -s)" in
  MINGW*|MSYS*)
    echo ""
    echo "NOTE FOR WINDOWS USERS:"
    echo "When using in Visual Studio with PowerShell, you might need to use:"
    echo "git config --local alias.cm '!sh \"$PWD/git-cm-lite.sh\"'"
    echo "to ensure the script path is properly escaped."
    ;;
esac
