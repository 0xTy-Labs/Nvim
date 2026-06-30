# 0xTyLabs Nvim IDE — Setup Guide

## 1. System dependencies (Arch)

### Core (required for everyone)
```bash
sudo pacman -S neovim git curl gcc make ripgrep fd nodejs npm python python-pip
# Nerd Font for icons — pick one:
yay -S ttf-jetbrains-mono-nerd   # recommended
```

### ML / Python
```bash
sudo pacman -S python-black python-ruff
pip install pyright --break-system-packages
# Debug adapter
pip install debugpy --break-system-packages
```

### Backend / Linux
```bash
sudo pacman -S bash-language-server shfmt docker
# yaml/json/prettier
npm install -g prettier yaml-language-server dockerfile-language-server-nodejs
```

### Android / Kotlin
```bash
sudo pacman -S jdk17-openjdk kotlin
# ktlint (formatter)
curl -sSLO https://github.com/pinterest/ktlint/releases/latest/download/ktlint
chmod +x ktlint && sudo mv ktlint /usr/local/bin/
# kotlin-language-server is installed by Mason automatically
# jdtls (Java LSP) is installed by Mason automatically
```

### Kernel / C / C++ / CUDA
```bash
sudo pacman -S clang lldb
# If using CUDA:
yay -S cuda   # or install from nvidia directly
# clangd is installed by Mason automatically
# For kernel work — point clangd at your kernel build dir:
# compile_commands.json generation:
# python3 scripts/clang-tools/gen_compile_commands.py (in kernel source)
```

### Git TUI (optional but wired to <leader>gg)
```bash
sudo pacman -S lazygit
```

### Rust (bonus)
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

---

## 2. Deploy the config

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak

# Copy new config (or symlink from your dotfiles repo)
cp -r /path/to/this/nvim-rice ~/.config/nvim
# OR if using your dotfiles repo:
ln -s ~/dotfiles/nvim ~/.config/nvim
```

---

## 3. First launch

```bash
nvim
# vim-plug will auto-install on first run (bootstrap in init.lua)
# If it doesn't trigger automatically:
:PlugInstall
```

After PlugInstall completes, restart nvim:
```bash
:q
nvim
```

---

## 4. Install LSP servers, formatters, debug adapters

```vim
:Mason
```

Mason will auto-install everything in `ensure_installed`. You can also
manually install anything from the Mason UI with `i`.

Verify LSP is running on a file:
```vim
:LspInfo
:checkhealth
```

---

## 5. Install Treesitter parsers

```vim
:TSInstall all
" or selectively:
:TSInstall python c cpp cuda kotlin java lua bash rust
```

---

## 6. Compile Kanagawa theme cache (faster startup)

```vim
:KanagawaCompile
```

---

## Key bindings reference

| Key | Action |
|-----|--------|
| `<Space>ff` | Find files |
| `<Space>fg` | Live grep |
| `<Space>fb` | Buffers |
| `<Space>e`  | File explorer toggle |
| `<C-\>`     | Floating terminal |
| `<Space>gg` | Lazygit |
| `<Space>tp` | Python REPL |
| `<Space>ta` | ADB shell |
| `<Space>or` | Run task (Overseer) |
| `<Space>ob` | Smart build (auto-detects Make/Gradle/CMake/Cargo) |
| `<Space>m`  | Mason (LSP manager) |
| `<Space>lo` | Symbol outline |
| `<Space>lf` | LSP finder |
| `<Space>xx` | Diagnostics panel |
| `<Space>hs` | Stage git hunk |
| `gd`        | Go to definition |
| `K`         | Hover docs |
| `<Space>rn` | Rename symbol |
| `<Space>ca` | Code action |
| `<Space>F`  | Format buffer |
| `s`         | Leap jump (2-char) |
| `<S-h/l>`   | Prev/next buffer |
| `[d` / `]d` | Prev/next diagnostic |

---

## Android-specific notes

For Android projects, jdtls needs a per-project config. Create
`~/.config/nvim/ftplugin/java.lua` pointing at your SDK:

```lua
-- ftplugin/java.lua
local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then return end

local home = os.getenv("HOME")
local workspace = home .. "/.local/share/eclipse/" ..
  vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

jdtls.start_or_attach({
  cmd = {
    "jdtls",
    "-data", workspace,
  },
  root_dir = require("jdtls.setup").find_root({ "gradlew", ".git", "mvnw" }),
  settings = {
    java = {
      configuration = {
        runtimes = {
          { name = "JavaSE-17", path = "/usr/lib/jvm/java-17-openjdk/" },
        },
      },
    },
  },
})
```

## CUDA notes

clangd handles `.cu`/`.cuh` files natively. For CUDA projects, generate
`compile_commands.json` with CMake:

```bash
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -B build
ln -s build/compile_commands.json .
```

clangd will pick it up automatically.

## Kernel notes

Generate `compile_commands.json` from your kernel source:
```bash
cd /path/to/linux
make defconfig
python3 scripts/clang-tools/gen_compile_commands.py
```
Then open files in nvim from the kernel root — clangd will find the JSON.
