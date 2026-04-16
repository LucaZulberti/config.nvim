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

require("mini.files").setup()
require("mini.extra").setup()
require("mini.icons").setup()
require("mini.trailspace").setup()

rmap("n", "<leader>f", function()
    -- Open the mini.files file explorer rooted at the current context.
    require("mini.files").open()
end, "[Mini.Files] Open")
