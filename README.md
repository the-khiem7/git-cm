# Git Commitizen Lite

A lightweight, dependency-free implementation of Commitizen-like interactive commit flow using only Bash/Shell script.

## Features

- Interactive conventional commit message creation
- No external dependencies, works with built-in Git and shell tools
- Cross-platform (Windows, macOS, Linux)
- Supports conventional commit format with:
  - Type selection (feat, fix, docs, etc.)
  - Optional scope
  - Required summary
  - Optional multiline description
  - Breaking change handling
  - Issue references

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

Follow the interactive prompts to create a properly formatted commit message.

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

## 📚 README: Commitizen Lite for Git via Bash

### 🚀 Overview

This is a lightweight, **Commitizen-like CLI tool** designed to help automate standardized commit messages in any Git repository. It's entirely written in **Bash**, requiring no Node.js or external dependencies. Use this tool for a simple, consistent commit process, even if you're using a non-Node.js tech stack.

---

### 🛠️ Features

- **Type** your commit (e.g., `feat`, `fix`, `docs`).
- Optionally add a **scope** (e.g., `auth`, `api`).
- Provide a **short description** for the commit.
- Add an optional **long description** (multi-line).
- Specify if your commit includes **breaking changes**.
- Link issues that are **closed** by the commit (e.g., `#123`).
- Fully POSIX-compliant, **works on Linux/macOS** with no external dependencies.

---

### 🧰 Setup

#### 1. Clone the repository (or navigate to your existing project):
```bash
git clone <repo-url>
cd <your-repo>
```

#### 2. Set up the Git alias to use the `git-cm-lite.sh` script:
Run the setup script to automatically configure the alias in your Git repo.

```bash
sh .git-cm-setup.sh
```

This will add the following Git alias to your repository:
```bash
git config alias.cm '!sh ./git-cm-lite.sh'
```

---

### 🚀 Usage

#### 1. **Stage your changes**:
```bash
git add .
```

#### 2. **Run `git cm`** to trigger the interactive commit process:
```bash
git cm
```

You'll be prompted to:
- Choose a commit **type** (e.g., `feat`, `fix`).
- Optionally provide a **scope** (e.g., `auth`, `login`).
- Enter a **short description** (required).
- Optionally provide a **long description** (multi-line).
- Specify if there are **breaking changes**.
- Optionally link **issue numbers** (e.g., `#123, #456`).

The resulting commit message will follow the **conventional commit format**:
```bash
<type>(<scope>): <short description>
<long description>
BREAKING CHANGE: <description>
Closes <issue #>
```

Example output:
```bash
feat(auth): add token validation

Added JWT parsing and validation for user authentication.

BREAKING CHANGE: The token format has changed.

Closes #123
```

---

### ⚙️ Scripts

#### **`git-cm-lite.sh`**
The main Bash script that runs the commit flow. It will:
- Prompt the user for necessary commit details.
- Format the commit message according to the **Conventional Commits** standard.
- Run `git commit` with multiple `-m` options for proper formatting.

#### **`.git-cm-setup.sh`**
This script configures the Git alias to easily run `git cm` in your repository:
```bash
git config alias.cm '!sh ./git-cm-lite.sh'
```

---

### ⚠️ Notes

- This solution is **cross-platform** and should work on Linux/macOS.
- **No Node.js** or additional tools are required to run this script.
- Ensure that you are using **Git Bash** or **Windows Subsystem for Linux (WSL)** for full compatibility on Windows.
- For PowerShell on Windows, you can use the `bash` command to run the script (e.g., `bash ./git-cm-lite.sh`).

---

### 🎉 Contributions

Feel free to contribute to this project by:
- Suggesting features.
- Reporting bugs.
- Improving the code.

To contribute, please fork the repo, make changes, and submit a pull request.

---

### 📄 License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

---

### 💬 Contact

For any questions or feature requests, feel free to open an issue or contact the project maintainers.

---

This README should cover all the essential setup, usage, and structure for your **Commitizen-like** tool. You can add it to your project and get users up and running quickly!