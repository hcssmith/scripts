# Agent Guidelines for /src/scripts

This repository contains shell scripts for system utilities and desktop management.

## Build/Install/Test Commands

### Installation
```bash
make install
```
Installs all scripts to `${HOME}/.local/bin/`

### Individual Script Testing
Run scripts directly to test:
```bash
./script-name.sh
```

### Linting/Validation
Check for syntax errors:
```bash
bash -n script-name.sh
shellcheck script-name.sh  # if available
```

## Code Style Guidelines

### Shebang
- Use `#!/bin/bash` for bash scripts (preferred)
- Use `#!/bin/sh` for POSIX-compliant scripts
- Use `#!/usr/bin/env bash` for portability

### Error Handling
- Start scripts with `set -euo pipefail` for robust error handling
- Handle dmenu cancellation: `dmenu ... || exit 0`
- Use `|| exit` when cd'ing: `cd "$dir" || exit`
- Check required variables: `[ -z "$var" ] && exit`

### Variable Naming
- Constants: `UPPER_CASE`
- Variables: `lower_case`
- Functions: `lower_case_with_underscores`

### Function Definitions
```bash
function_name() {
    # body
}
```

### Indentation
- Use 2 spaces (not tabs)

### String Quoting
- Quote all variable expansions: `"$var"`, `"$@"`
- Use double quotes for strings, single quotes for literal strings
- Nerd font icons don't need quoting in menu strings
- Quote file paths with spaces: `"$path with spaces/file.txt"`

### Conditionals & Tests
- Use `[[ ]]` for bash-specific tests with regex matching: `[[ "$var" =~ pattern ]]`
- Use `[ ]` for POSIX-compatible tests
- Test for empty strings: `[ -z "$var" ]` or `[[ -z "$var" ]]`
- Test for non-empty strings: `[ -n "$var" ]` or `[[ -n "$var" ]]`
- File existence: `[ -f "$file" ]` for files, `[ -d "$dir" ]` for directories

### Command Substitution
- Modern syntax: `$(command)` (preferred)
- Backticks: `` `command` `` (legacy, avoid)
- Nested: `$(outer "$(inner)")`

### Arrays (bash only)
```bash
PROVIDERS=("item1" "item2" "item3")
echo "${PROVIDERS[0]}"              # First element
echo "${#PROVIDERS[@]}"             # Length
for item in "${PROVIDERS[@]}"; do   # Iterate
    echo "$item"
done
```

### Patterns & Conventions

#### Dmenu Menus
```bash
menu="Option 1\nOption 2\nOption 3"
opt=$(echo -e "$menu" | dmenu "$@" -i -l 3 -p "Prompt:")
```
- Always pass `"$@"` to preserve dmenu arguments
- Use `-i` for case-insensitive search
- Use `-l` for line count

#### Notifications
```bash
notify-send -u critical "Title" "Message"  # important
notify-send "Title" "Message"                # normal
```

#### Case Statements
```bash
case "$opt" in
    "Option 1")
        command
        ;;
    "Option 2")
        command
        ;;
esac
```

#### Backgrounding
Use `&` for background processes, especially GUI applications

#### Common Tools
- `dmenu`: Interactive menus
- `nmcli`: Network management
- `notify-send`: Desktop notifications
- `mpc`: Music Player Daemon control
- `feh`: Wallpaper setting
- `xdotool`: Simulating keyboard input

## File Organization
- Scripts are self-contained utilities
- Keep scripts focused on single purpose
- Use descriptive names: `wifi.sh`, `system.sh`, `app-launcher.sh`

## Script Structure
1. Shebang line
2. Optional: `set -euo pipefail` for error handling
3. Variable declarations (constants first)
4. Function definitions
5. Main logic

## Best Practices
- Use local variables in functions: `local var="$1"`
- Avoid global state when possible
- Exit on errors early
- Provide feedback via notifications for long operations
- Use descriptive variable and function names
- Comment complex logic (sparingly)
- Keep lines under 100 characters
- Background GUI applications: `command &`
- Foreground terminal apps: `command` (without &)

## When Adding Scripts
1. Add to Makefile install target
2. Make executable: `chmod +x script-name.sh`
3. Follow existing patterns for consistency
4. Add shebang and error handling
