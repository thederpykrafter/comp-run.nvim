local M = {}

function M.GetScript()
   local files = {}
   local tmpfile = "/tmp/stmp.txt"

   os.execute("ls -1 > " .. tmpfile)

   local f = io.open(tmpfile)
   if not f then
      return files
   end

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

   vim.api.nvim_create_autocmd("TermClose", {
      callback = function()
         vim.cmd("close")
      end,
   })

   vim.keymap.set("n", "<leader>R", function()
      if M.GetScript() ~= nil then
         vim.cmd("vsplit term://" .. M.GetScript())
         vim.cmd("startinsert")
      end
   end, { desc = "Comp-[R]un" })
end

return M
