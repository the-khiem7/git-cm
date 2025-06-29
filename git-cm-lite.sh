#!/bin/sh
# git-cm-lite.sh - A Commitizen-like CLI for Git using only Bash
# Usage: git cm

# Colors for better readability
BOLD="\033[1m"
RESET="\033[0m"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"

# Check if running in Windows and adjust color output
if [ "$OS" = "Windows_NT" ]; then
    # Enable virtual terminal processing for Windows
    export TERM=xterm-256color
fi

# Function to prompt for required input
prompt_required() {
  local prompt_text="$1"
  local input=""
  
  while [ -z "$input" ]; do
    printf "%b" "$BOLD$prompt_text$RESET: "
    read -r input
    if [ -z "$input" ]; then
      echo "This field is required. Please try again."
    fi
  done
  
  echo "$input"
}

# Function to prompt for optional input
prompt_optional() {
  local prompt_text="$1"
  local input=""
  
  printf "%b" "$BOLD$prompt_text$RESET: "
  read -r input
  echo "$input"
}

# Function to prompt for multiline input
prompt_multiline() {
  local prompt_text="$1"
  local input=""
  local line=""
  
  echo "$BOLD$prompt_text$RESET (Press CTRL+D on a new line when done):"
  input=$(cat)
  echo "$input"
}

# Function to prompt for yes/no input
prompt_yesno() {
  local prompt_text="$1"
  local answer=""
  
  while true; do
    printf "%b" "$BOLD$prompt_text$RESET (y/n): "
    read -r answer
    case "$answer" in
      [Yy]* ) return 0 ;;
      [Nn]* ) return 1 ;;
      * ) echo "Please answer y or n." ;;
    esac
  done
}

# Function to validate issue numbers
validate_issue_number() {
    local issue="$1"
    # Remove '#' prefix if present
    issue="${issue#\#}"
    # Check if it's a valid number
    case "$issue" in
        ''|*[!0-9]*) return 1 ;;
        *) return 0 ;;
    esac
}

# Function to preview commit message in editor
preview_in_editor() {
    local message="$1"
    local temp_file
    temp_file=$(mktemp)
    echo "$message" > "$temp_file"
    
    # Use git editor or fallback to vi
    "${VISUAL:-${EDITOR:-vi}}" "$temp_file"
    
    # Read edited message
    cat "$temp_file"
    rm -f "$temp_file"
}

# Function to build commit message
build_commit_message() {
    local message="$commit_header"
    if [ -n "$description" ]; then
        message="$message"$'\n'"$description"
    fi
    if [ -n "$breaking_change" ]; then
        message="$message"$'\n'"BREAKING CHANGE: $breaking_change"
    fi
    if [ -n "$issues" ]; then
        # Format each issue reference
        echo "$issues" | tr ',' '\n' | while read -r issue; do
            issue=$(echo "$issue" | tr -d '[:space:]')
            if [ -n "$issue" ]; then
                if ! validate_issue_number "${issue#\#}"; then
                    echo "${RED}Warning: Invalid issue number format: $issue${RESET}" >&2
                    continue
                fi
                # Make sure the issue has a # prefix
                case "$issue" in
                    \#*) message="$message"$'\n'"Closes $issue" ;;
                    *) message="$message"$'\n'"Closes #$issue" ;;
                esac
            fi
        done
    fi
    echo "$message"
}

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "Error: Not in a git repository."
  exit 1
fi

# Get staged files count
staged_files=$(git diff --cached --name-only | wc -l | tr -d '[:space:]')
if [ "$staged_files" -eq 0 ]; then
  echo "Warning: No files are staged for commit."
  if ! prompt_yesno "Continue anyway?"; then
    echo "Commit aborted. Stage files with 'git add' and try again."
    exit 0
  fi
fi

# Load custom commit types if config exists
load_commit_types() {
    local config_file=".git-cm-config"
    if [ -f "$config_file" ]; then
        # Read commit types from config
        commit_types=$(cat "$config_file")
    else
        # Default commit types
        commit_types="feat:A new feature
fix:A bug fix
docs:Documentation only changes
style:Changes that do not affect code
refactor:Code change neither fixing nor adding
perf:Performance improvement
test:Adding or fixing tests
chore:Build process or tools
ci:CI configuration changes"
    fi
}

load_commit_types

echo "=== Commit Message Builder ==="

# 1. Select commit type
echo "${BOLD}Select commit type:${RESET}"
type_count=0
# Store types and descriptions in arrays
types=()
descriptions=()
echo "$commit_types" | while IFS=: read -r type description; do
    type_count=$((type_count + 1))
    types[$type_count]=$type
    descriptions[$type_count]=$description
    printf "%b" "${BOLD}$type_count)${RESET} $type: $description\n"
done

commit_type=""
while [ -z "$commit_type" ]; do
    printf "${BOLD}Enter type number (1-%d):${RESET} " "$type_count"
    read -r type_number
    
    if [ "$type_number" -ge 1 ] && [ "$type_number" -le "$type_count" ]; then
        commit_type="${types[$type_number]}"
    else
        echo "Invalid choice. Please enter a number between 1 and $type_count."
    fi
done

# 2. Prompt for scope (optional)
scope=$(prompt_optional "Enter scope (optional, e.g., auth, login)")

# 3. Prompt for short summary (required)
summary=$(prompt_required "Enter a short summary of the change")

# 4. Prompt for long description (optional, multiline)
description=$(prompt_multiline "Enter a longer description (optional)")

# 5. Check for breaking changes
breaking_change=""
if prompt_yesno "Does this commit include breaking changes?"; then
  breaking_change=$(prompt_required "Describe the breaking changes")
fi

# 6. Related issues
issues=$(prompt_optional "Related issue numbers (e.g., #123, #456, comma-separated)")

# Build the commit message
commit_header=""
if [ -n "$scope" ]; then
  commit_header="$commit_type($scope): $summary"
else
  commit_header="$commit_type: $summary"
fi

# Build and display the initial commit message
echo "$BOLD""Final commit message:$RESET"
echo "----------------------------------------"
commit_message=$(build_commit_message)
echo "$commit_message"
echo "----------------------------------------"

# Ask user if they want to preview/edit the commit message
if prompt_yesno "Would you like to preview/edit in your editor?"; then
    commit_message=$(preview_in_editor "$commit_message")
    echo "----------------------------------------"
    echo "${BOLD}Edited commit message:${RESET}"
    echo "$commit_message"
    echo "----------------------------------------"
fi

# Confirm commit
if prompt_yesno "Proceed with this commit?"; then
    # Build the Git commit command using the complete message
    git commit -m "$commit_message"
    echo "${GREEN}Commit successful!${RESET}"
else
    echo "${YELLOW}Commit aborted.${RESET}"
    exit 0
fi