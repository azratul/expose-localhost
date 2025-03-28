if vim.fn.has("nvim-0.7") == 0 then
  vim.notify("expose-localhost.nvim requires Neovim 0.7 or higher", vim.log.levels.ERROR)
  return
end

local expose = require("expose-localhost")

if vim.health then
  vim.health["expose-localhost"] = require("expose-localhost.health").check
end

vim.api.nvim_create_user_command("ExposeStart", function(opts)
  local args = vim.split(opts.args, " ")
  expose.expose(args[1], args[2])
end, {
  nargs = "+",
  desc = "Expose a local port using cloudflared or ngrok",
})

vim.api.nvim_create_user_command("ExposeStop", function()
  expose.stop()
end, {
  nargs = 0,
  desc = "Stop the currently running expose tunnel",
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if expose.tunnel_job then
      vim.fn.jobstop(expose.tunnel_job)
    end
  end,
})
