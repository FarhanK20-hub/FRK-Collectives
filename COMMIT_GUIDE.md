# Commit Guide

This document outlines the standards for committing code to the FRK Collectives repository. Adhering to these guidelines ensures a clean, readable, and secure git history.

## What NEVER to Commit

Under no circumstances should the following files be staged or committed:
- **`.env` files**: These contain your local database passwords and secret keys. Committing them exposes your infrastructure.
- **`target/` directory**: Compiled `.class`, `.war`, or `.jar` files bloat the repository and cause merge conflicts. Build artifacts should be generated locally or by CI/CD.
- **IDE configuration files** (`.idea/`, `.vscode/`, `*.iml`): These are specific to your local machine and will override other developers' preferences.

## Commit Message Format

We use the [Conventional Commits](https://www.conventionalcommits.org/) standard. This makes the project history highly readable and allows for automated changelog generation.

**Format:**
```
<type>[optional scope]: <description>

[optional body]
```

### Allowed Types
- **`feat`**: A new feature (e.g., adding a wishlist).
- **`fix`**: A bug fix (e.g., resolving a GSAP animation glitch).
- **`docs`**: Documentation only changes (e.g., updating the README).
- **`style`**: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons).
- **`refactor`**: A code change that neither fixes a bug nor adds a feature.
- **`test`**: Adding missing tests or correcting existing tests.
- **`chore`**: Changes to the build process or auxiliary tools (e.g., updating Maven dependencies).

### Examples

**Good:**
> `feat(auth): implement session-based login`
> `fix(ui): remove GSAP opacity conflict causing invisible elements`
> `docs: update setup instructions for MySQL 8.0`

**Bad:**
> `fixed the bug`
> `updates`
> `WIP`

## Pre-Commit Checklist

Before running `git commit`, verify the following:

- [ ] **No secrets staged**: Run `git status` and ensure `.env` is not in the "Changes to be committed" list.
- [ ] **No binary bloat**: Ensure no `target/` files, `.jar`, or large media files (unless explicitly approved) are staged.
- [ ] **`.env.example` updated**: If you added a new environment variable to your local `.env`, did you add a placeholder for it in `.env.example`?
- [ ] **Dependencies updated**: If you added a new Java library, is it properly documented in `pom.xml`?
- [ ] **Documentation matches**: If your change affects how to set up or run the project, update `README.md`.
- [ ] **No debug code**: Remove all `System.out.println()` or `console.log()` statements used for temporary debugging.
- [ ] **Builds successfully**: Run `mvn clean compile` to ensure no syntax errors were left behind.
