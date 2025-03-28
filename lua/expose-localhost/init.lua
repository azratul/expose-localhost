local M = {}

local tunnel_job = nil

local function handle_stdout(data, pattern)
  if not data then
    return
  end
  for _, line in ipairs(data) do
    if line and #line > 0 then
      local url = line:match(pattern)
      if url then
        vim.schedule(function()
          vim.fn.setreg("+", url)
          vim.notify("🔗 URL copied to clipboard: " .. url)
        end)
      end
    end
  end
end

local services = {
  cloudflared = {
    build_cmd = function(port)
      return { "cloudflared", "tunnel", "--url", "http://localhost:" .. port }
    end,
    stdout = function(job_id, data, event)
      handle_stdout(data, "https://[%w%-%.]+%.trycloudflare%.com")
    end,
    stderr = function(job_id, data, event)
      handle_stdout(data, "https://[%w%-%.]+%.trycloudflare%.com")
    end,
  },
  ngrok = {
    build_cmd = function(port)
      return { "ngrok", "http", tostring(port), "--log", "stdout" }
    end,
    stdout = function(job_id, data, event)
      handle_stdout(data, "url=(https://[%w%-%.]+)")
    end,
    stderr = function(job_id, data, event)
      if not data then
        return
      end
      for _, line in ipairs(data) do
        if line and #line > 0 then
          vim.schedule(function()
            vim.notify("Ngrok error: " .. line, vim.log.levels.ERROR)
          end)
        end
      end
    end,
  },
}

--- Expose a local port to the internet using the selected method
---@param port number|string
---@param method? "cloudflared"|"ngrok"
function M.expose(port, method)
  if tunnel_job then
    vim.notify("A tunnel is already active. Please stop it before starting a new one.", vim.log.levels.WARN)
    return
  end

  if not port then
    vim.notify("⚠️ You must provide a port. Example: :ExposeStart 3000", vim.log.levels.WARN)
    return
  end

  method = method or "cloudflared"

  local service = services[method]
  if not service then
    vim.notify("⚠️ Unsupported method: " .. method, vim.log.levels.WARN)
    return
  end

  local cmd = service.build_cmd(port)
  vim.notify("🚀 Exposing http://localhost:" .. port .. " using " .. method .. "...")
  tunnel_job = vim.fn.jobstart(cmd, {
    on_stdout = service.stdout,
    on_stderr = service.stderr,
  })

  if tunnel_job == -1 then
    vim.notify("Failed to start tunnel process for " .. method, vim.log.levels.ERROR)
  end
end

function M.stop()
  if tunnel_job then
    vim.fn.jobstop(tunnel_job)
    tunnel_job = nil
    vim.notify("🛑 Tunnel stopped.")
  else
    vim.notify("No active tunnel to stop.", vim.log.levels.INFO)
  end
end

return M
