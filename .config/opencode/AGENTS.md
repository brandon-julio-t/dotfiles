---
title: OpenCode Agent Guidelines
description: Guidelines for OpenCode agents prioritizing modern and optimized tools
version: 1.0.0
last_updated: 2024-01-04
---

# OpenCode Agent Guidelines

## Core Principle: Modern Tool First

OpenCode agents MUST prioritize modern, optimized tools over traditional Unix utilities. This document establishes the guidelines, tool recommendations, and decision-making framework for agent behavior.

**Why Modern Tools Matter:**
- Performance improvements of 10-100x for common operations
- Better ergonomics and user experience
- Improved safety and correctness
- Active maintenance and security updates
- Better integration with modern development workflows

---

## Tool Selection Hierarchy

When performing any task, agents MUST follow this hierarchy:

1. **Check for modern tool availability** (via `which` or `command -v`)
2. **Use modern tool if available**
3. **If unavailable, negotiate installation with user**
4. **Fall back to traditional tool only if installation is declined**

### Never Use (Unless User Explicitly Requests)
- `grep` → Use `ripgrep (rg)` instead
- `find` → Use `fd` instead  
- `cat` → Use `bat` instead
- `ls` → Use `exa` or `eza` instead
- `top` → Use `btm` (bottom) or `htop` instead
- `ps` → Use `procs` instead
- `df` → Use `duf` instead
- `man` → Use `tldr` or `cheat.sh` for quick reference

### Always Prefer
- `rg` (ripgrep) for text search
- `fd` for file finding
- `bat` for file viewing
- `eza` or `exa` for directory listing
- `zoxide` for smart directory jumping
- `fzf` for fuzzy finding
- `mise` for tool management

---

## Mandatory Tool Installation Negotiation

When a required modern tool is not installed, agents MUST:

### Step 1: Detect Missing Tool
```bash
# Check availability
command -v <tool_name> >/dev/null 2>&1 || echo "Not found"
```

### Step 2: Present the Case to User

**Required Information:**
1. **Tool Name and Purpose** - What it does and why it matters
2. **Performance Benefit** - Specific metrics if available
3. **Installation Method** - Simple command via mise
4. **Alternative** - What you'll use if they decline
5. **User Choice** - Explicit permission to proceed

**Negotiation Script Template:**
```
I notice that [<tool>] is not installed on your system. 

[<tool>] is a modern replacement for [<traditional_tool>] that offers:
- [Specific benefit 1, e.g., "10-50x faster search performance"]
- [Specific benefit 2, e.g., "Better default output formatting"]
- [Specific benefit 3, e.g., "Active maintenance and security updates"]

I can install it using mise with:
    mise use -g <tool>@latest

This will only take a moment and doesn't affect other tools.

Would you like me to install [<tool>]? If not, I'll use [<traditional_tool>] as a fallback.
```

### Step 3: Proceed Based on User Response

- **User approves**: Install and use the modern tool
- **User declines**: Use traditional tool with a note: "Using [traditional_tool] as requested. Consider installing [modern_tool] for better performance."
- **User asks for details**: Provide additional information about the tool
- **No response after 2 attempts**: Proceed with traditional tool and document the recommendation

---

## Tool Reference Guide

### Text Search: ripgrep (rg)

**Replaces:** `grep`, `egrep`, `fgrep`

**Why ripgrep:**
- Written in Rust for maximum performance
- 5-10x faster than grep on typical codebases
- Default recursive search (no `-r` needed)
- Better regex support and performance
- Intelligent file filtering (.gitignore aware)

**Installation:**
```bash
mise use -g ripgrep@latest
```

**Usage Comparison:**
```bash
# Traditional grep
grep -r "pattern" --include="*.js" .

# Modern ripgrep
rg "pattern" -t js
```

**Key Flags:**
- `-t <type>`: Filter by file type (equivalent to `--include`)
- `-g <glob>`: Glob patterns
- `-i`: Case insensitive
- `-w`: Match whole words
- `-C <n>`: Context lines
- `--no-ignore`: Ignore .gitignore

---

### File Finding: fd

**Replaces:** `find`

**Why fd:**
- Rust-based, significantly faster
- User-friendly default output
- Colorized results
- Regular expression support
- Unicode-aware matching
- Smart case matching

**Installation:**
```bash
mise use -g fd@latest
```

**Usage Comparison:**
```bash
# Traditional find
find . -name "*.py" -type f

# Modern fd
fd -e py
```

**Key Flags:**
- `-e <ext>`: Search by extension
- `-t <type>`: Type filter (f=file, d=directory)
- `-H`: Search hidden files
- `-I`: Don't respect .gitignore
- `--exec`: Execute command on results

---

### File Viewing: bat

**Replaces:** `cat`

**Why bat:**
- Syntax highlighting for hundreds of languages
- Git integration (shows modified lines)
- Page styling with line numbers
- Automatic paging in terminals
- Show non-printing characters option

**Installation:**
```bash
mise use -g bat@latest
```

**Usage Comparison:**
```bash
# Traditional cat
cat file.txt

# Modern bat (with style)
bat --style=plain file.txt
```

**Key Flags:**
- `--style`: Customize output (full, plain, changes, header)
- `--theme`: Syntax highlighting theme
- `--language`: Force language detection
- `--wrap`: Text wrapping mode
- `-p`: Plain output (like cat but better)

---

### Directory Listing: eza

**Replaces:** `ls`

**Why eza:**
- More detailed and readable output
- Git status integration
- Icons in terminals that support them
- Better default formatting
- Extended attributes support

**Installation:**
```bash
mise use -g eza@latest
```

**Usage Comparison:**
```bash
# Traditional ls
ls -la

# Modern eza
eza -la --icons
```

**Key Flags:**
- `-l`: Long format
- `-a`: Show hidden files
- `--icons`: Add file type icons
- `--git`: Show git status
- `--tree`: Tree view
- `--sort`: Custom sorting

---

### Smart Directory Jumping: zoxide

**Replaces:** Manual `cd` navigation

**Why zoxide:**
- Learns your most-used directories
- Frecent scoring (frequent + recent)
- Fuzzy matching
- Integrates with all shells
- Drastically reduces typing

**Installation:**
```bash
mise use -g zoxide@latest
```

**Setup:**
```bash
# Add to shell rc file
eval "$(zoxide init zsh)"
```

**Usage:**
```bash
# Traditional
cd ~/projects/opencode/src/agents

# With zoxide
z agents    # Auto-jumps to best match
```

---

### Fuzzy Finding: fzf

**Replaces:** Manual file/command searching

**Why fzf:**
- Blazing fast fuzzy search
- Works with any input (files, git branches, processes)
- Preview window support
- Multi-select capability
- Extensive customization

**Installation:**
```bash
mise use -g fzf@latest
```

**Common Uses:**
```bash
# File finder
fzf

# Git branch switcher
git branch | fzf | xargs git checkout

# Process killer
ps aux | fzf | awk '{print $2}' | xargs kill

# With ripgrep
rg --color=always --line-number --no-heading --smart-case "" \
  | fzf --preview 'bat --style=changes --wrap=never --color=always {1}' \
  | cut -d: -f1
```

---

### Tool Management: mise

**Why mise:**
- Universal tool version manager
- Replaces nvm, pyenv, goenv, etc.
- Single config file (.mise.toml)
- Supports 300+ tools
- Cross-platform consistent

**Installation:**
```bash
# macOS
brew install mise

# Or via mise itself (once installed)
mise use -g mise@latest
```

**Usage:**
```bash
# Install tool globally
mise use -g ripgrep@latest

# Install tool for project
mise use ripgrep@latest

# List installed tools
mise ls

# Run tool without installation
mise x ripgrep -- rg "pattern"

# Upgrade all tools
mise upgrade
```

**Project Configuration (.mise.toml):**
```toml[tools]
node = "20"
python = "3.12"
ripgrep = "latest"
eza = "latest"
fd = "latest"
bat = "latest"
```

---

## Workflow Examples

### Example 1: Searching for Code Pattern

**Task:** Find all occurrences of a function call across the codebase

**Traditional Approach (WRONG):**
```bash
grep -r "function_name" --include="*.ts" .
```

**Modern Approach (CORRECT):**
```bash
# Check for ripgrep
command -v rg >/dev/null 2>&1 && rg "function_name" -t ts || {
    echo "ripgrep not found. Installing with mise..."
    mise use -g ripgrep@latest && rg "function_name" -t ts
}
```

**With User Negotiation:**
```
I need to search for function calls in TypeScript files. ripgrep (rg) is 10x faster than grep and has better default settings for code search.

Would you like me to install ripgrep via mise? It only takes a moment.

Or if you prefer, I can use the traditional grep command instead.
```

---

### Example 2: Finding Configuration Files

**Task:** Find all JSON config files in the project

**Traditional Approach (WRONG):**
```bash
find . -name "*.json" -type f
```

**Modern Approach (CORRECT):**
```bash
command -v fd >/dev/null 2>&1 && fd -e json -t f || {
    echo "fd not found. Installing with mise..."
    mise use -g fd@latest && fd -e json -t f
}
```

---

### Example 3: Viewing File with Syntax Highlighting

**Task:** Read a source code file

**Traditional Approach (WRONG):**
```bash
cat src/main.py
```

**Modern Approach (CORRECT):**
```bash
command -v bat >/dev/null 2>&1 && bat --style=plain src/main.py || cat src/main.py
```

---

### Example 4: Setting Up Development Environment

**Task:** Install all recommended modern tools

**Approach:**
```bash
# Check and install recommended tools
for tool in ripgrep fd bat eza zoxide fzf; do
    if ! command -v $tool >/dev/null 2>&1; then
        echo "Installing $tool..."
        mise use -g $tool@latest
    else
        echo "$tool is already installed: $(which $tool)"
    fi
done
```

---

## Error Handling and Fallbacks

### When Modern Tool Fails

**Scenario:** Modern tool installed but crashes or behaves unexpectedly

**Approach:**
1. Try with default flags first
2. If fails, attempt with minimal flags
3. If still failing, fall back to traditional tool
4. Report the issue to user with details

**Example:**
```bash
# Try ripgrep with defaults
if ! rg "pattern" >/dev/null 2>&1; then
    # Try with minimal flags
    if ! rg -N "pattern" >/dev/null 2>&1; then
        echo "ripgrep failed, using grep as fallback"
        grep -r "pattern" .
    fi
fi
```

### When Installation Fails

**Scenario:** mise installation fails due to permissions or network

**Approach:**
1. Try with sudo if appropriate
2. Try homebrew installation as alternative
3. Report failure with specific error
4. Proceed with traditional tool and document

---

## Performance Expectations

### Typical Performance Improvements

| Task | Traditional | Modern | Improvement |
|------|-------------|--------|-------------|
| Search 1000 files | grep: ~2.5s | ripgrep: ~0.1s | 25x faster |
| Find 500 files | find: ~1.2s | fd: ~0.08s | 15x faster |
| View file | cat: instant | bat: instant | Same speed, better UX |
| List directory | ls: instant | eza: instant | Same speed, better UX |

### When to Report Performance Issues

If a modern tool is significantly slower than expected:
1. Check if correct tool is being used (not fallback)
2. Verify tool version is recent
3. Report to user with timing data
4. Check for known issues in tool's issue tracker

---

## Configuration Recommendations

### Per-Project Configuration (.mise.toml)

```toml[tools]
# Search and file operations
ripgrep = "latest"
fd = "latest"
bat = "latest"

# Development tools
node = "20"
python = "3.12"
typescript = "latest"

# DevOps tools
docker-compose = "latest"
kubectl = "latest"
terraform = "latest"
```

### Global Configuration (~/.config/mise/config.toml)

```toml[settings]
# Enable verbose output
verbose = true

# Auto-swap for tools
partial_strict = false

# Enable plugin activation
plugin = true
```

---

## Tool Version Compatibility

### Minimum Recommended Versions

| Tool | Minimum Version | Reason |
|------|-----------------|--------|
| ripgrep | 13.0.0 | PCRE2 support, performance fixes |
| fd | 8.0.0 | Unicode improvements, stability |
| bat | 0.18.0 | Theme system, integration |
| eza | 0.11.0 | Feature completeness |
| zoxide | 0.9.0 | Shell integration improvements |
| fzf | 0.42.0 | Preview improvements |
| mise | 2024.1.0 | Tool management features |

### Version Checking

```bash
# Check all recommended tools
for tool in ripgrep fd bat eza zoxide fzf; do
    if command -v $tool >/dev/null 2>&1; then
        echo "$tool: $($tool --version 2>&1 | head -1)"
    else
        echo "$tool: not installed"
    fi
done
```

---

## User Communication Guidelines

### Proactive Recommendations

When you notice a user could benefit from a modern tool:

1. **Identify the pattern**: "I see you're using [traditional_tool] frequently"
2. **Present the benefit**: "[Modern_tool] would be X times faster for this"
3. **Make it easy**: "I can install it with one command: `mise use -g [tool]@latest`"
4. **Respect autonomy**: "Let me know if you'd like me to install it"

### After Modern Tool Installation

When a user asks why you recommended a tool:

- **Be specific**: Cite performance benchmarks or features
- **Be honest**: Acknowledge when traditional tools are sufficient
- **Be helpful**: Offer to configure or customize the tool
- **Be patient**: Some users may prefer traditional workflows

### Handling Tool Refusals

If a user declines to install a modern tool:

1. **Acknowledge**: "No problem, I'll use [traditional_tool]"
2. **Document**: Make a note in project context if relevant
3. **Don't push**: Respect their choice
4. **Offer alternatives**: Suggest other optimizations
5. **Revisit later**: Maybe in a different context they'll be interested

---

## Integration with Other Agents

### When Delegating to Other Agents

When spawning subagents or delegating tasks:

1. **Include tool context**: "Use ripgrep (rg) instead of grep for searching"
2. **Specify modern tools**: "Prefer fd for file finding, bat for viewing"
3. **Share installation info**: Provide mise commands if tools might be missing
4. **Set expectations**: "Modern tools should be 10-20x faster"

### Agent Communication Template

```
[Task requirements]
- Use ripgrep (rg) for all text search operations
- Use fd for file finding operations  
- Use bat for file viewing operations
- Install missing tools via: mise use -g <tool>@latest

[Expected performance]
- Search should complete in <1 second for typical codebases
- File finding should complete in <0.5 seconds
```

---

## Testing and Verification

### Pre-Flight Checks

Before starting any substantial task:

```bash
# Verify key tools are available
echo "Checking modern tool availability..."
for tool in rg fd bat; do
    if command -v $tool >/dev/null 2>&1; then
        echo "✓ $tool is available"
    else
        echo "✗ $tool is not installed"
    fi
done
```

### Performance Baseline

When optimizing tasks:

1. **Measure traditional approach** (for comparison)
2. **Apply modern tool approach**
3. **Report improvement**: "[Modern_tool] completed in X seconds vs [traditional_tool] in Y seconds"

---

## Troubleshooting Common Issues

### ripgrep Not Finding Expected Results

**Issue:** ripgrep returns no results where grep finds matches

**Solution:**
```bash
# Check if file is ignored
rg --no-ignore "pattern" <file>

# Check encoding issues
rg -a "pattern" <file>

# Check literal vs regex
rg -F "pattern" <file>  # Literal matching
```

### fd Not Finding Files

**Issue:** fd misses files that find discovers

**Solution:**
```bash
# Search hidden files
fd -H "pattern"

# Don't respect .gitignore  
fd -I "pattern"

# Search full path
fd "pattern" /full/path
```

### bat Showing Wrong Highlighting

**Issue:** Syntax highlighting doesn't match file type

**Solution:**
```bash
# Force language detection
bat --language=typescript <file>

# List detected language
bat --diagnostics <file>

# Choose different theme
bat --theme=Monokai <file>
```

---

## Future Tool Recommendations

### Tools Under Evaluation

The following tools are being evaluated for future inclusion:

| Tool | Purpose | Status |
|------|---------|--------|
| procs | Modern ps replacement | Testing |
| duf | Modern df replacement | Evaluating |
| hyperfine | Benchmarking tool | Recommended |
| mprocs | Modern parallel processing | Testing |
| yazi | Terminal file manager | Monitoring |

### Deprecated Tool Removal

Tools that may be removed from recommendations:

- `exa` → Replaced by `eza` (exa is unmaintained)
- `lsd` → Replaced by `eza` (eza has more features)

---

## Summary

OpenCode agents are **required** to:

1. ✅ Prioritize modern, optimized tools over traditional utilities
2. ✅ Use `ripgrep (rg)` instead of `grep`
3. ✅ Use `fd` instead of `find`
4. ✅ Use `bat` instead of `cat`
5. ✅ Use `eza` instead of `ls`
6. ✅ Use `mise` for tool management
7. ✅ Negotiate installation when tools are missing
8. ✅ Fall back gracefully if installation is declined
9. ✅ Communicate performance benefits to users
10. ✅ Document tool recommendations in project context

OpenCode agents should **never**:

1. ❌ Use traditional tools when modern alternatives are available
2. ❌ Skip installation negotiation for missing tools
3. ❌ Proceed without user permission for system changes
4. ❌ Ignore performance issues with recommended tools
5. ❌ Use deprecated or unmaintained tools

---

## Quick Reference Card

```bash
# Installation (one-time setup)
brew install mise

# Install all recommended tools
mise use -g ripgrep fd bat eza zoxide fzf

# Verify installation
mise ls

# Upgrade tools
mise upgrade

# Daily commands
rg "pattern" -t ts        # Search TypeScript
fd -e py                  # Find Python files  
bat file.txt              # View file with highlighting
eza -la --icons           # List files with icons
z projects                # Jump to projects directory
fzf                       # Fuzzy find anything
```

---

*Last updated: 2024-01-04*
*Version: 1.0.0*
*Maintainers: OpenCode Team*
