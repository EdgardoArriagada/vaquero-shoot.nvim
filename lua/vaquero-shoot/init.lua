local u = require("vaquero-shoot.utils")

local M = {}

local ENCLOSING = 1
local QUOTES = 2

local MIN_NEOVIM_COL = 1

local enclosingLeftTokens = {
	["("] = true,
	["["] = true,
	["{"] = true,
	["<"] = true,
}

local rightToLeftDictionary = {
	[")"] = "(",
	["]"] = "[",
	["}"] = "{",
	[">"] = "<",
}

local enclosingStruct = {
	tokens = {
		["("] = true,
		[")"] = true,
		["["] = true,
		["]"] = true,
		["{"] = true,
		["}"] = true,
		["<"] = true,
		[">"] = true,
	},
	loadToken = function(pairsHolder, pilesStorage, token, i)
		if enclosingLeftTokens[token] then
			u.safePush(pilesStorage, token, i)
			return
		end

		local leftIndex = u.safePop(pilesStorage, rightToLeftDictionary[token])

		if leftIndex then
			table.insert(pairsHolder, { leftIndex, i })
		end
	end,
}

local quotesStruct = {
	tokens = {
		["'"] = true,
		['"'] = true,
		["`"] = true,
	},
	loadToken = function(pairsHolder, pilesStorage, token, i)
		local leftIndex = u.safePop(pilesStorage, token)

		if leftIndex then
			table.insert(pairsHolder, { leftIndex, i })
			return
		end

		u.safePush(pilesStorage, token, i)
	end,
}

local function hasVqsSelection(selectionType)
	local currentLine = vim.api.nvim_get_current_line()
	local startVisualPos = u.getStartOfVisualSelection()

	local leftToken = currentLine:sub(startVisualPos - 1, startVisualPos - 1)
	local isQuoteSelection = selectionType == QUOTES

	-- if does not has left token
	if isQuoteSelection then
		if not quotesStruct.tokens[leftToken] then
			return false
		end
	else
		if not enclosingStruct.tokens[leftToken] then
			return false
		end
	end

	local endVisualPos = u.getCol()

	local rightToken = currentLine:sub(endVisualPos + 1, endVisualPos + 1)

	if isQuoteSelection then
		return leftToken == rightToken
	else -- encosing
		return rightToLeftDictionary[rightToken] == leftToken
	end
end

local function createPairsHolder(selectionType)
	local result = {} -- { {left1, rigth1}, {left2, rigth2}, ... }
	local pilesStorage = {} --  { [token] = { {left1, rigth1}, {left2, right2}, ... } }

	local currentStructure = selectionType == ENCLOSING and enclosingStruct or quotesStruct

	local tokens = currentStructure.tokens
	local loadToken = currentStructure.loadToken

	local i = 1
	for token in vim.api.nvim_get_current_line():gmatch(".") do
		if tokens[token] then
			loadToken(result, pilesStorage, token, i)
		end
		i = i + 1
	end

	-- unload
	pilesStorage = nil
	currentStructure = nil
	tokens = nil
	loadToken = nil

	return result
end

local function beginVqsSelection(selectionType, recycledPairsHolder, givenCol)
	local currCol = givenCol or u.getCol()
	local pairsHolder = recycledPairsHolder or createPairsHolder(selectionType)

	local closestPair = nil

	local function unload()
		pairsHolder = nil
		recycledPairsHolder = nil
		closestPair = nil
	end

	-- try to select between
	local minLeft = -1
	for left, right in u.toupleArrayElement(pairsHolder) do
		if left <= currCol and currCol <= right then
			if minLeft < left then
				minLeft = left
				closestPair = { left, right }
			end
		end
	end

	if closestPair then
		u.selectMoving(closestPair)
		unload()
		return
	end

	-- try to select forward
	closestPair = nil
	minLeft = 1 / 0 -- inf
	for left, right in u.toupleArrayElement(pairsHolder) do
		if currCol < left and currCol < right then
			if left < minLeft then
				minLeft = left
				closestPair = { left, right }
			end
		end
	end

	if closestPair then
		u.selectMoving(closestPair)
		unload()
		return
	end

	-- try to select backwards
	closestPair = nil
	local maxRight = -1
	for left, right in u.toupleArrayElement(pairsHolder) do
		if left < currCol and right < currCol then
			if maxRight < right then
				maxRight = right
				closestPair = { left, right }
			end
		end
	end

	if closestPair then
		u.selectMoving(closestPair)
	end

	unload()
end

local function beginReverseVqsSelection(selectionType, recycledPairsHolder, givenCol)
	local currCol = givenCol or u.getMaxCol()
	local pairsHolder = recycledPairsHolder or createPairsHolder(selectionType)

	local closestPair = nil

	local function unload()
		pairsHolder = nil
		recycledPairsHolder = nil
		closestPair = nil
	end

	-- try to select backwards
	closestPair = nil
	local maxLeft = -1
	for left, right in u.toupleArrayElement(pairsHolder) do
		if left < currCol and right < currCol then
			if maxLeft < left then
				maxLeft = left
				closestPair = { left, right }
			end
		end
	end

	if closestPair then
		u.selectMoving(closestPair)
		unload()
		return
	end

	-- try to select forward
	closestPair = nil
	minLeft = 1 / 0 -- inf
	for left, right in u.toupleArrayElement(pairsHolder) do
		if currCol < left and currCol < right then
			if left < minLeft then
				minLeft = left
				closestPair = { left, right }
			end
		end
	end

	if closestPair then
		u.selectMoving(closestPair)
	end

	unload()
end

local function findLeftIndex(currRight, pairsHolder)
	for left, right in u.toupleArrayElement(pairsHolder) do
		if currRight == right then
			return left
		end
	end
end

local function cycleVqsSelection(selectionType)
	local currRightCol = u.getCol() + 1

	local pairsHolder = createPairsHolder(selectionType)

	local currLeftCol = findLeftIndex(currRightCol, pairsHolder) or u.getStartOfVisualSelection()

	-- find next occurrence
	local nextPair = nil
	local minLeft = 1 / 0 -- inf
	for left, right in u.toupleArrayElement(pairsHolder) do
		if minLeft > left and left > currLeftCol then
			minLeft = left
			nextPair = { left, right }
		end
	end

	if nextPair then
		u.selectMoving(nextPair)

		-- unload
		pairsHolder = nil
		nextPair = nil
		return
	end

	beginVqsSelection(selectionType, pairsHolder, MIN_NEOVIM_COL)
end

local function cycleReverseVqsSelection(selectionType)
	local currRightCol = u.getCol() + 1

	local pairsHolder = createPairsHolder(selectionType)

	local currLeftCol = findLeftIndex(currRightCol, pairsHolder) or u.getStartOfVisualSelection()

	-- find previous occurrence
	local nextPair = nil
	local minLeft = -1
	for left, right in u.toupleArrayElement(pairsHolder) do
		if minLeft < left and left < currLeftCol then
			minLeft = left
			nextPair = { left, right }
		end
	end

	if nextPair then
		u.selectMoving(nextPair)

		-- unload
		pairsHolder = nil
		nextPair = nil
		return
	end

	beginReverseVqsSelection(selectionType, pairsHolder, u.getMaxCol() + 1)
end

M.beginEnclosingSelection = function()
	beginVqsSelection(ENCLOSING)
end

M.cycleEnclosingSelection = function()
	cycleVqsSelection(ENCLOSING)
end

M.enclosingSelection = function()
	if hasVqsSelection(ENCLOSING) then
		cycleVqsSelection(ENCLOSING)
	else
		beginVqsSelection(ENCLOSING)
	end
end

M.beginReverseEnclosingSelection = function()
	beginReverseVqsSelection(ENCLOSING)
end

M.cycleReverseEnclosingSelection = function()
	cycleReverseVqsSelection(ENCLOSING)
end

M.reverseEnclosingSelection = function()
	if hasVqsSelection(ENCLOSING) then
		cycleReverseVqsSelection(ENCLOSING)
	else
		beginReverseVqsSelection(ENCLOSING)
	end
end

M.beginQuotesSelection = function()
	beginVqsSelection(QUOTES)
end

M.cycleQuotesSelection = function()
	cycleVqsSelection(QUOTES)
end

M.quotesSelection = function()
	if hasVqsSelection(QUOTES) then
		cycleVqsSelection(QUOTES)
	else
		beginVqsSelection(QUOTES)
	end
end

M.beginReverseQuotesSelection = function()
	beginReverseVqsSelection(QUOTES)
end

M.cycleReverseQuotesSelection = function()
	cycleReverseVqsSelection(QUOTES)
end

M.reverseQuotesSelection = function()
	if hasVqsSelection(QUOTES) then
		cycleReverseVqsSelection(QUOTES)
	else
		beginReverseVqsSelection(QUOTES)
	end
end

-- Test string
-- () => ({foo} ({bar}))
-- ${zsb:='zsb'} # "$foo" ` 'ba' 'bi' " ` " '''
-- ${zsb:='zsb'} () {} < > [ ] ` ' " '

return M
