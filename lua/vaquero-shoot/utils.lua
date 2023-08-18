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

local function execute(str)
	vim.cmd(vim.api.nvim_replace_termcodes(str, true, true, true))
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
	local lineNumber = vim.fn.line(".")
	vim.fn.cursor(lineNumber, touple[1] + 1)
	execute("normal<Esc>v")
	vim.fn.cursor(lineNumber, touple[2] - 1)
end

return M
