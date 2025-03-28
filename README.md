
# expose-localhost.nvim

> Expose your localhost to the internet from inside Neovim (for the truly lazy among us)

This is a *very* tiny Neovim plugin that lets you expose a local port using either [Cloudflared](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/) or [Ngrok](https://ngrok.com/) — without leaving Neovim.

Yes, you can already do this with a one-liner in your terminal. This plugin exists for people like me who prefer to run everything from within Neovim and can't be bothered to open another tab or terminal.

---

## ✨ Features

- Expose any local port via Cloudflare Tunnel or Ngrok
- Automatically copies the public URL to your clipboard
- Minimal API: just one function or one command
- Health check included

---

## ⚙ Requirements

- One of the following installed and available in `$PATH`:
  - `cloudflared`
  - `ngrok`

---

## 📦 Installation

**With `lazy.nvim`:**

```lua
{
  "azratul/expose-localhost.nvim",
}
```

**With `packer.nvim`:**

```lua
use {
  "azratul/expose-localhost.nvim",
}
```

---

## 🚀 Usage

### Command:

- Start exposing a local port, by default using Cloudflared:

```vim
:ExposeStart <port> [cloudflared|ngrok]
```

Examples:

```vim
:ExposeStart 3000
:ExposeStart 8080 ngrok
```

- Stop exposing the port:

```vim
:ExposeStop
```

---

### Lua API:

```lua
require("expose-localhost").expose(3000, "cloudflared")
```

---

## 🩺 Health Check

You can verify everything is working with:

```lua
:lua require("expose-localhost").health()
```

Or with Neovim's built-in health check:

```lua
:checkhealth expose-localhost
```
