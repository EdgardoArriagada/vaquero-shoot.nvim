local M = {}

M.toupleArrayElement = function(t)
	local i = 0

	return function()
		i = i + 1
		if t[i] then
			return t[i][1], t[i][2]
		end
	end
end

M.getCol = function()
	return vim.api.nvim_win_get_cursor(0)[2] + 1
end

M.getMaxCol = function()
	return string.len(vim.api.nvim_get_current_line())
end

local function getLineNum()
	return vim.api.nvim_win_get_cursor(0)[1]
end

local function execute(str)
	vim.api.nvim_exec(vim.api.nvim_replace_termcodes(str, true, true, true), false)
end

M.getStartOfVisualSelection = function()
	return vim.fn.getpos("v")[3]
end

M.safePush = function(pile, element, i)
	if pile[element] then
		table.insert(pile[element], i)
	else
		pile[element] = { i }
	end
end

M.safePop = function(pile, element)
	if pile[element] then
		return table.remove(pile[element])
	end
	return nil
end

M.selectMoving = function(touple)
	local lineNumber = getLineNum()
	vim.api.nvim_win_set_cursor(0, { lineNumber, touple[1] })
	execute("normal<Esc>v")
	vim.api.nvim_win_set_cursor(0, { lineNumber, touple[2] - 2 })
end

return M
