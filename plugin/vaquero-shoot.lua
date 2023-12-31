local actions = {
	"beginEnclosingSelection",
	"cycleEnclosingSelection",
	"enclosingSelection",
	"beginQuotesSelection",
	"cycleQuotesSelection",
	"quotesSelection",
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

	if action == "beginEnclosingSelection" then
		vqs.beginEnclosingSelection()
	elseif action == "cycleEnclosingSelection" then
		vqs.cycleEnclosingSelection()
	elseif action == "enclosingSelection" then
		vqs.enclosingSelection()
	elseif action == "beginQuotesSelection" then
		vqs.beginQuotesSelection()
	elseif action == "cycleQuotesSelection" then
		vqs.cycleQuotesSelection()
	elseif action == "quotesSelection" then
		vqs.quotesSelection()
	else
		print("VaqueroShoot: unknown action: " .. action)
		return
	end
end, { nargs = 1, complete = complete_vaquero_shoot })
