local actions = {
	"beginEnclosingSelection",
	"cycleEnclosingSelection",
	"enclosingSelection",
	"beginEnclosingSelectionBackwards",
	"cycleEnclosingSelectionBackwards",
	"enclosingSelectionBackwards",
	"beginQuotesSelection",
	"cycleQuotesSelection",
	"quotesSelection",
	"beginQuotesSelectionBackwards",
	"cycleQuotesSelectionBackwards",
	"quotesSelectionBackwards",
}

local function complete_vaquero_shoot(arglead)
	local matches = {}

	for _, action in ipairs(actions) do
		if action:find(arglead) == 1 then
			table.insert(matches, action)
		end
	end

	return matches
end

vim.api.nvim_create_user_command("VaqueroShoot", function(opts)
	local action = opts.args

	local vqs = require("vaquero-shoot")

	local fn = vqs[action]

	if not fn then
		print("VaqueroShoot: unknown action: " .. action)
		return
	end

	fn()
end, { nargs = 1, complete = complete_vaquero_shoot })
