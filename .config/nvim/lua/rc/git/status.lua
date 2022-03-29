local job = require "plenary.job"
local parser = require "rc.git.status_parser"

-- test
local opts = {
  status_refresh_interval = 3000,
}

local status_cache = {}
local state = {}
state.last_job = nil
state.on_cooldown = false

local function update_status_cache(out)
  status_cache = parser.parse(out)
  print(status_cache.branch, status_cache.remote_branch, status_cache.ahead_num, status_cache.behind_num)
  print(vim.inspect(status_cache.staged_changes))
  print(vim.inspect(status_cache.unstaged_changes))
  print(vim.inspect(status_cache.untracked_changes))
  print("is_dirty : " .. tostring(status_cache.is_dirty))
end

local on_git_status_exit = function(j, exit_code)
  if exit_code ~= 0 then
    print "git status failed"
    return
  end
  update_status_cache(j:result())
end

local make_git_status_job = function(cwd, env)
  return job:new {
    command = "git",
    args = { "status", "--porcelain", "--branch" },
    cwd = cwd or vim.loop.cwd(),
    env = env or {},
    on_exit = on_git_status_exit,
  }
end

local function check_dirty_cached(cwd)
  if state.last_job ~= nil and not state.last_job.is_shutdown then
    print "git status is running"
  elseif not state.on_cooldown then
    state.last_job = make_git_status_job(cwd)
    state.last_job:start()
    state.on_cooldown = true
    vim.defer_fn(function()
      state.on_cooldown = false
    end, opts.status_refresh_interval)
  else
    -- on cooldown
  end
  return status_cache.is_dirty
end

return {
  status_cache = status_cache,
  check_dirty_cached = check_dirty_cached,
  internal_state = state,
}