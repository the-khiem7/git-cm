# Git Commitizen Lite

A lightweight, dependency-free implementation of Commitizen-like interactive commit flow using only Bash/Shell script.

## Features

- Interactive conventional commit message creation
- No external dependencies, works with built-in Git and shell tools
- Cross-platform (Windows, macOS, Linux)
- Fully customizable commit types via `.git-cm-config`
- Smart commit message creation:
  - Type selection (feat, fix, docs, etc.)
  - Optional scope (e.g., auth, ui)
  - Required summary
  - Optional multiline description
  - Breaking change handling
  - Issue references with validation
  - Preview and edit support using your preferred editor
- Uses your configured Git editor for message editing
- Validates staged changes before committing

## Setup

### Unix/Linux/Git Bash

1. Run the setup script:
   ```
   sh .git-cm-setup.sh
   ```

2. The script will:
   - Make `git-cm-lite.sh` executable
   - Set up a Git alias `cm` for the current repository

### Windows/PowerShell (Visual Studio)

1. Run the PowerShell setup script:
   ```powershell
   .\powershell-setup.ps1
   ```

2. The script will:
   - Set up a Git alias `cm` with proper path escaping for Windows
   - Configure it to work in the Visual Studio Developer PowerShell

## Usage

After setup, simply run:

```
git cm
```

The script will:

1. Check if there are staged changes
2. Guide you through creating your commit message:
   - Select a commit type from the list
   - Optionally add a scope
   - Enter a short summary
   - Optionally add a detailed description
   - Indicate if there are breaking changes
   - Reference related issues
3. Show you the complete commit message
4. Allow you to preview and edit the message in your preferred editor
5. Confirm and create the commit

The editor used for preview/edit is determined by your Git configuration:
- First checks `$VISUAL`
- Then `$EDITOR`
- Falls back to `vi` if neither is set

You can configure your preferred editor in Git:
```bash
git config --global core.editor "code --wait"  # For VS Code
git config --global core.editor "nano"         # For nano
git config --global core.editor "vim"          # For vim
```

## Manual Setup

If you prefer to set up the alias manually:

### Git Bash / Linux / macOS
```
chmod +x git-cm-lite.sh
git config --local alias.cm '!sh ./git-cm-lite.sh'
```

### Windows PowerShell
```powershell
git config --local alias.cm "!sh \"$PWD/git-cm-lite.sh\""
```

## Global Setup

To use this tool globally across all repositories, use:

### Git Bash / Linux / macOS
```
git config --global alias.cm '!sh /path/to/git-cm-lite.sh'
```

### Windows PowerShell
```powershell
git config --global alias.cm "!sh \"C:/path/to/git-cm-lite.sh\""
```

Make sure the script remains accessible at the specified path.

## Configuration

### Commit Types

You can customize the available commit types by creating a `.git-cm-config` file in your repository root. The format is:

```
type:Description of the type
```

For example:
```
feat:A new feature
fix:A bug fix
docs:Documentation only changes
style:Changes that do not affect the meaning of the code
refactor:Code change that neither fixes a bug nor adds a feature
perf:Code change that improves performance
test:Adding missing tests
chore:Changes to build process or auxiliary tools
ci:Changes to CI configuration
```

If no config file is found, the script will use these default types.

## Contributing

Feel free to contribute to this project by:
- Suggesting features
- Reporting bugs
- Improving the code

To contribute:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request