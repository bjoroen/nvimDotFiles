local M = {}

local isempty = function(s)
	return s == nil or s == ""
end

-- mode_map copied from:
-- https://github.com/nvim-lualine/lualine.nvim/blob/5113cdb32f9d9588a2b56de6d1df6e33b06a554a/lua/lualine/utils/mode.lua
-- Copyright (c) 2020-2021 hoob3rt
-- MIT license, see LICENSE for more details.
local mode_map = {
	["n"] = "NORMAL",
	["no"] = "O-PENDING",
	["nov"] = "O-PENDING",
	["noV"] = "O-PENDING",
	["no\22"] = "O-PENDING",
	["niI"] = "NORMAL",
	["niR"] = "NORMAL",
	["niV"] = "NORMAL",
	["nt"] = "NORMAL",
	["v"] = "VISUAL",
	["vs"] = "VISUAL",
	["V"] = "V-LINE",
	["Vs"] = "V-LINE",
	["\22"] = "V-BLOCK",
	["\22s"] = "V-BLOCK",
	["s"] = "SELECT",
	["S"] = "S-LINE",
	["\19"] = "S-BLOCK",
	["i"] = "INSERT",
	["ic"] = "INSERT",
	["ix"] = "INSERT",
	["R"] = "REPLACE",
	["Rc"] = "REPLACE",
	["Rx"] = "REPLACE",
	["Rv"] = "V-REPLACE",
	["Rvc"] = "V-REPLACE",
	["Rvx"] = "V-REPLACE",
	["c"] = "COMMAND",
	["cv"] = "EX",
	["ce"] = "EX",
	["r"] = "REPLACE",
	["rm"] = "MORE",
	["r?"] = "CONFIRM",
	["!"] = "SHELL",
	["t"] = "TERMINAL",
}

local is_current = function()
	local winid = vim.g.actual_curwin
	if isempty(winid) then
		return false
	else
		return winid == tostring(vim.api.nvim_get_current_win())
	end
end

M.get_mode = function()
	if not is_current() then
		--return "%#WinBarInactive# win #" .. vim.fn.winnr() .. " %*"
		return "%#WinBarInactive#  #" .. vim.fn.winnr() .. "  %*"
	end
	local mode_code = vim.api.nvim_get_mode().mode
	local mode = mode_map[mode_code] or string.upper(mode_code)
	return "%#Mode" .. mode:sub(1, 1) .. "# " .. mode .. " %*"
end

vim.cmd([[

  highlight ModeC guibg=#dddddd guifg=#101010 gui=bold " COMMAND 
  highlight ModeI guibg=#EBCB8B guifg=#353535 gui=bold " INSERT  
  highlight ModeT guibg=#A3BE8C guifg=#353535 gui=bold " TERMINAL
  highlight ModeN guibg=#87d7ff guifg=#353535 gui=bold " NORMAL  
  highlight ModeN guibg=#5E81AC guifg=#262626 gui=bold " NORMAL  
  highlight ModeV guibg=#B48EAD guifg=#353535 gui=bold " VISUAL  
  highlight ModeR guibg=#BF616A guifg=#353535 gui=bold " REPLACE 

  highlight StatusLine              guibg=#191D24 guifg=#999999
  highlight StatusLineGit  gui=bold guibg=#191D24 guifg=#FFFFFF
  highlight StatusLineChanges       guibg=#191D24 guifg=#FFFFFF
  highlight StatusLineFile gui=bold guibg=#1E222A guifg=#bbbbbb
  highlight StatusLineAllGood       guibg=#242933 guifg=#A3BE8C
  highlight StatusLineTransition1   guibg=#242933 guifg=#1E222A
  highlight StatusLineMod           guibg=#242933 guifg=#d7d787
  highlight StatusLineError         guibg=#242933 guifg=#BF616A
  highlight StatusLineInfo          guibg=#242933 guifg=#5E81AC
  highlight StatusLineHint          guibg=#242933 guifg=#A3BE8C
  highlight StatusLineWarn          guibg=#242933 guifg=#EBCB8B
  highlight StatusLineOutside       guibg=#3B4252 guifg=#999999
  highlight StatusLineTransition2   guibg=#3a3a3a guifg=#1c1c1c


  " highlight StatusLineCwd  gui=bold guibg=#191D24 guifg=#999999

  function! FindHeader()
    " We need to find the header, it will be the first line that has:
    " | columnName |
    " in it.
    " We will only look at the first 100 lines.
    let b:table_header = 1
    for i in range(1, 100)
      let line = getline(i)
      let header = matchstr(line, '|\s.*\s|')
      if !empty(header)
        let b:table_header = i
        return
      endif
    endfor
  endfunction

  augroup dbout
    autocmd!
    autocmd BufReadPost *.dbout call FindHeader()
  augroup END
]])

local make_two_char = function(symbol)
	if symbol:len() == 1 then
		return symbol .. " "
	else
		return symbol
	end
end

local sign_cache = {}
local get_sign = function(severity, icon_only)
	if icon_only then
		local defined = vim.fn.sign_getdefined("DiagnosticSign" .. severity)
		if defined and defined[1] then
			return " " .. defined[1].text
		else
			return " " .. severity[1]
		end
	end

	local cached = sign_cache[severity]
	if cached then
		return cached
	end

	local defined = vim.fn.sign_getdefined("DiagnosticSign" .. severity)
	local text, highlight
	defined = defined and defined[1]
	if defined and defined.text and defined.texthl then
		text = " " .. make_two_char(defined.text)
		highlight = defined.texthl
	else
		text = " " .. severity:sub(1, 1)
		highlight = "Diagnostic" .. severity
	end
	cached = "%#" .. highlight .. "#" .. text .. "%*"
	sign_cache[severity] = cached
	return cached
end

M.get_diag_counts = function()
	local d = vim.diagnostic.get(0)
	if #d == 0 then
		return "%#StatusLineAllGood# ✅   %*"
	end

	local grouped = {}
	for _, diag in ipairs(d) do
		local severity = diag.severity
		if not grouped[severity] then
			grouped[severity] = 0
		end
		grouped[severity] = grouped[severity] + 1
	end

	local result = ""
	local S = vim.diagnostic.severity
	if grouped[S.ERROR] then
		result = result .. "%#StatusLineError#" .. grouped[S.ERROR] .. get_sign("Error", true) .. "%*"
	end
	if grouped[S.WARN] then
		result = result .. "%#StatusLineWarn#" .. grouped[S.WARN] .. get_sign("Warn", true) .. "%*"
	end
	if grouped[S.INFO] then
		result = result .. "%#StatusLineInfo#" .. grouped[S.INFO] .. get_sign("Info", true) .. "%*"
	end
	if grouped[S.HINT] then
		result = result .. "%#StatusLineHint#" .. grouped[S.HINT] .. get_sign("Hint", true) .. "%*"
	end
	return result
end

M.get_git_branch = function()
	local branch = vim.b.git_branch
	if isempty(branch) then
		return ""
	else
		return "%#StatusLineGit#   " .. branch .. "  %*"
	end
end

M.get_git_changes = function()
	local changes = vim.b.gitsigns_status
	if isempty(changes) then
		return ""
	else
		return "%#StatusLineChanges#" .. changes .. "  %*"
	end
end

M.get_git_dirty = function()
	local dirty = vim.b.gitsigns_status
	if isempty(dirty) then
		return " "
	else
		return "%#WinBarGitDirty# %*"
	end
end

M.status_line = function()
	return table.concat({
		"%{%v:lua.status.get_mode()%}",
		"%{%v:lua.status.get_git_branch()%}",
		"%{%v:lua.status.get_git_changes()%}",
		"",
		"%#StatusLineFile#  %f   %*",
		"%#StatusLineTransition1#  %*",
		"%{%v:lua.status.get_diag_counts()%}",
		"%=",
		"%#StatusLineOutside# %3l/%L %3c %*",
	})
end

vim.cmd([[
  function! GitBranch()
    return trim(system("git -C " . getcwd() . " branch --show-current 2>/dev/null"))
  endfunction

  augroup GitBranchGroup
      autocmd!
      autocmd BufEnter * let b:git_branch = GitBranch()
  augroup END

  " [+] if only current modified, [+3] if 3 modified including current buffer.
  " [3] if 3 modified and current not, "" if none modified.
  function! IsBuffersModified()
      let cnt = len(filter(getbufinfo(), 'v:val.changed == 1'))
      return cnt == 0 ? "" : ( &modified ? "[+". (cnt>1?cnt:"") ."]" : "[".cnt."]" )
  endfunction
]])

_G.status = M
vim.o.statusline = "%{%v:lua.status.status_line()%}"

return M
