local M = {}

function M.GetScript()
	local files = {}
	local tmpfile = "/tmp/stmp.txt"

	os.execute("ls -1 > " .. tmpfile)

	local f = io.open(tmpfile)
	if not f then return files end

	local script

	for line in f:lines() do
		if line == "run" then
			script = "./run"
		elseif line == "run.sh" then
			script = "./run.sh"
		elseif line == "Makefile" then
			script = "make test"
		else
			-- TODO: disable plugin if script not found
			script = ""
		end
	end

	f:close()
	return script
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
