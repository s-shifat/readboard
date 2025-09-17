# Readboard

Readboard is a tool that uses Hyprland’s `hyprshot` as a screenshot backend and applies OCR (via Tesseract and Python) to extract text from screenshots. The recognized text is printed to the terminal and copied to the clipboard.

---

## Features

* Capture a region of the screen with `hyprshot`.
* Extract text from the screenshot using Tesseract OCR.
* Copy extracted text to the clipboard automatically.

---

## Requirements

### When using Nix (flakes)

No manual setup is required. All dependencies are bundled into the flake.
### When not using Nix

You must ensure the following are installed on your system:

* [hyprshot](https://github.com/Gustash/Hyprshot.git)
* [tesseract](https://tesseract-ocr.github.io/tessdoc/Installation.html)
* [wl-clipboard](https://github.com/bugaevc/wl-clipboard.git)
* [uv](https://docs.astral.sh/uv/#installation)

---

## Enable flakes in Nix (Skip it if you have it!)

If flakes are not yet enabled on your system, add the following line to your Nix configuration (usually `/etc/nix/nix.conf` for system-wide or `~/.config/nix/nix.conf` for user):

```
experimental-features = nix-command flakes
```

After editing the file, restart the Nix daemon:

```bash
sudo systemctl restart nix-daemon.service
```

or log out and log back in if running in single-user mode.

---

## Setup with Nix (flakes)

The project provides a flake that builds both the runtime application and a development environment.

### Run temporarily

```bash
nix run github:s-shifat/readboard
```

### Install system-wide (per user)

```bash
nix profile add github:s-shifat/readboard?ref=main
```

This makes the `readboard` command available globally for your user.

### Upgrade to the latest version

```bash
nix profile upgrade readboard
```

### Remove from your profile

```bash
nix profile remove <index>
```

Use `nix profile list` to check the index number for `readboard`.

### Enter a development shell

```bash
nix develop github:s-shifat/readboard
```

From there you can run:

```bash
python main.py
```

or invoke `readboard`.

---

## Developer workflow (with flakes)

Clone the repository and run locally:

```bash
git clone https://github.com/s-shifat/readboard
cd readboard
nix run .
```

To enter a shell with dependencies available:

```bash
nix develop
```

Edits to `main.py` are picked up the next time you run `nix run .`

---

## Setup with uv (non-flake users)

For users or developers who prefer not to use Nix flakes, the project can be managed with [`uv`](https://github.com/astral-sh/uv).

### Create the environment

```bash
git clone https://github.com/s-shifat/readboard
cd readboard
uv sync

# If you need a virtual environment as well:
uv venv
```

### Run the app

```bash
uv run main.py
```

---

