local M = {}

function M.check()
  local health = vim.health or require("vim.health")
  health.start("expose-localhost.nvim checks")

  if vim.fn.executable("cloudflared") == 1 then
    health.ok("cloudflared found")
  else
    health.warn("cloudflared not found in PATH")
  end

  if vim.fn.executable("ngrok") == 1 then
    health.ok("ngrok found")
  else
    health.warn("ngrok not found in PATH")
  end
end

return M
