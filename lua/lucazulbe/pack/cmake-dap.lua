local funcs = require("lucazulbe.functions")
local rmap = funcs.rmap

require("cmake-tools").setup {
    cmake_dap_configuration = {
        name = "cpp",
        type = "codelldb",
        request = "launch",
        stopOnEntry = false,
        runInTerminal = true,
        console = "integratedTerminal",
        program = function()
            local cmake = require("cmake-tools")
            local target = cmake.get_launch_target()
            local model = cmake.get_model_info()
            return cmake.get_launch_path(target) .. model[target].nameOnDisk
        end,
        cwd = "${workspaceFolder}",
    },
}

local dap = require("dap")
local cmake = require("cmake-tools")

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = "codelldb",
        args = { "--port", "${port}" },
    },
}

local function cmake_target_program()
    local target = cmake.get_launch_target()
    if not target then
        vim.notify("No CMake launch target selected. Run :CMakeSelectLaunchTarget", vim.log.levels.ERROR)
        return nil
    end

    local model = cmake.get_model_info()
    local filename = model[target].nameOnDisk
    local path = cmake.get_launch_path(target)

    return path .. filename
end

dap.configurations.cpp = {
    {
        name = "CMake target",
        type = "codelldb",
        request = "launch",
        program = cmake_target_program,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
        runInTerminal = true,
    },
}

dap.configurations.c = dap.configurations.cpp

require("nvim-dap-virtual-text").setup()
require("dapui").setup()

rmap('n', '<leader>gd', ":DapNew<CR>", "[DAP] New Debug session")
rmap('n', '<leader>gq', ":DapTerminate<CR>", "[DAP] Terminate Debug session")
rmap('n', '<leader>gc', ":DapContinue<CR>", "[DAP] Continue execution")
rmap('n', '<leader>gp', ":DapPause<CR>", "[DAP] Pause execution")
rmap('n', '<leader>gt', ":DapToggleBreakpoint<CR>", "[DAP] Toggle Breakpoint on current line")
rmap('n', '<leader>gn', ":DapStepOver<CR>", "[DAP] Step over")
rmap('n', '<leader>gi', ":DapStepInto<CR>", "[DAP] Step into")
rmap('n', '<leader>go', ":DapStepOut<CR>", "[DAP] Step out")
rmap('n', '<leader>gui', function() require("dapui").toggle() end, "[DAP] Open UI")
