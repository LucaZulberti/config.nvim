local funcs = require("lucazulbe.functions")
local rmap = funcs.rmap

require("mini.ai").setup()
require("mini.operators").setup()
require("mini.surround").setup()
require("mini.snippets").setup()
require("mini.completion").setup()
require("mini.pairs").setup()
require("mini.move").setup()

-- Define custom highlight groups used by mini.hipatterns.
vim.api.nvim_set_hl(0, "MiniHipatternsAlert", { fg = "#232136", bg = "#ff5555", bold = true })
vim.api.nvim_set_hl(0, "MiniHipatternsInfo", { fg = "#232136", bg = "#5fd7ff", bold = true })
vim.api.nvim_set_hl(0, "MiniHipatternsDebug", { fg = "#232136", bg = "#afff87", bold = true })
vim.api.nvim_set_hl(0, "MiniHipatternsPerf", { fg = "#232136", bg = "#ff9e64", bold = true })
vim.api.nvim_set_hl(0, "MiniHipatternsTest", { fg = "#232136", bg = "#ff6842", bold = true })

require("mini.hipatterns").setup({
    highlighters = {
        -- Highlight structured maintenance keywords in source files.
        fixme     = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        hack      = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo      = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note      = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
        alert     = { pattern = "%f[%w]()ALERT()%f[%W]", group = "MiniHipatternsAlert" },
        info      = { pattern = "%f[%w]()INFO()%f[%W]", group = "MiniHipatternsInfo" },
        debug     = { pattern = "%f[%w]()DEBUG()%f[%W]", group = "MiniHipatternsDebug" },
        perf      = { pattern = "%f[%w]()PERF()%f[%W]", group = "MiniHipatternsPerf" },
        test      = { pattern = "%f[%w]()TEST()%f[%W]", group = "MiniHipatternsTest" },

        -- Highlight hex color literals using their own color value.
        hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
    },
})

require("mini.pick").setup()
require("mini.files").setup()
require("mini.extra").setup()
require("mini.icons").setup()
require("mini.trailspace").setup()

rmap("n", "<leader>pf", ":Pick files<CR>", "[Mini.Pick] Files")
rmap("n", "<leader>ph", ":Pick help<CR>", "[Mini.Pick] Help")
rmap("n", "<leader>pd", ":Pick diagnostic<CR>", "[Mini.Pick] Diagnostic")
rmap("n", "<leader>pe", ":Pick explorer<CR>", "[Mini.Pick] Explorer")
rmap("n", "<leader>ps", ":Pick grep_live<CR>", "[Mini.Pick] Grep Live")
rmap("n", "<leader>pa", ":Pick grep<CR>", "[Mini.Pick] Grep")
rmap("n", "<leader>pgf", ":Pick git_files<CR>", "[Mini.Pick] Git Files")
rmap("n", "<leader>pgl", ":Pick git_commits<CR>", "[Mini.Pick] Git Log")
rmap("n", "<leader>pgh", ":Pick git_hunks<CR>", "[Mini.Pick] Git Hunks")
rmap("n", "<leader>plq", ":Pick list scope='quickfix'<CR>", "[Mini.Pick] Quickfix List")
rmap("n", "<leader>pll", ":Pick list scope='location'<CR>", "[Mini.Pick] Location List")
rmap("n", "<leader>plj", ":Pick list scope='jump'<CR>", "[Mini.Pick] Jump List")
rmap("n", "<leader>plc", ":Pick list scope='change'<CR>", "[Mini.Pick] Change List")
rmap("n", "<leader>pm", ":Pick marks<CR>", "[Mini.Pick] Marks")
rmap("n", "<leader>pr", ":Pick registers<CR>", "[Mini.Pick] Registers")
rmap("n", "<leader>pk", ":Pick keymaps<CR>", "[Mini.Pick] Keymaps")

rmap("n", "<leader>f", function()
    -- Open the mini.files file explorer rooted at the current context.
    require("mini.files").open()
end, "[Mini.Files] Open")
