function ColorMyPencils(color)
    color = color or "rose-pine-moon"
    vim.cmd.colorscheme(color)
end

return {
    "rose-pine/neovim",

    name = "rose-pine",

    config = function()
        require("rose-pine").setup({
            variant = "moon",
            dim_inactive_windows = true,
            extend_background_behind_borders = true,

            enable = {
                terminal = true,
                legacy_highlights = false,
                migrations = true, -- Handle deprecated options automatically
            },

            styles = {
                bold = true,
                italic = true,
                transparency = false,
            },

            groups = {
                border = "muted",
                link = "iris",
                panel = "surface",

                error = "love",
                hint = "iris",
                info = "foam",
                note = "pine",
                todo = "rose",
                warn = "gold",

                git_add = "foam",
                git_change = "rose",
                git_delete = "love",
                git_dirty = "rose",
                git_ignore = "muted",
                git_merge = "iris",
                git_rename = "pine",
                git_stage = "iris",
                git_text = "rose",
                git_untracked = "subtle",

                h1 = "iris",
                h2 = "foam",
                h3 = "rose",
                h4 = "gold",
                h5 = "pine",
                h6 = "foam",
            },
        })

        ColorMyPencils();
    end
}
