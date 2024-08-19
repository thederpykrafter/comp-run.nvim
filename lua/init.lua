local M = {}

function M.GetScript()
	local files = {}
	local tmpfile = "/tmp/stmp.txt"

	os.execute("ls -1 > " .. tmpfile)

	local f = io.open(tmpfile)
	if not f then return files end

	for line in f:lines() do
		if line == "run" then
			return "./run"
		elseif line == "run.sh" then
			return "./run.sh"
		elseif line == "Makefile" then
			return "make test"
		else
		end
	end

	f:close()
end

function M.setup(opts)
	opts = opts or {}

	-- vim.api.nvim_create_autocmd("TermClose", {
	-- 	callback = function()
	-- 		vim.cmd("close")
	-- 	end,
	-- })

	vim.keymap.set(
		"n",
		"<leader>RR",
		":vsplit term://" .. M.GetScript() .. "<cr>i",
		{ desc = "Comp-[R]un" }
	)

	vim.keymap.set("n", "<leader>Rr", function()
		local input, args

		local function getInput()
			vim.ui.input(
				{ prompt = "enter command args: " },
				function(str) input = str end
			)
			return input
		end

		input = getInput()

		if input == nil then return end

		if M.GetScript() == "make test" then
			args = "ARGS='-- " .. input .. "'"
		else
			args = input
		end

		vim.cmd(
			":vsplit term://" .. M.GetScript() .. " " .. args .. "\n"
		)
		--vim.cmd("sleep 1")
		vim.cmd("startinsert")
	end, { desc = "Comp-[R]un with a[r]gs" })
end

return M
