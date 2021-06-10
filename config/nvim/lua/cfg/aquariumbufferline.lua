
local bl = require("bufferline")
local bfs = bl.setup

require "bufferline".setup {
    options = {
        offsets = {{filetype = "NvimTree", text = "Explorer"}},
        buffer_close_icon = "",
        modified_icon = "",
        close_icon = " ",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 14,
        max_prefix_length = 13,
        tab_size = 20,
        show_tab_indicators = true,
        enforce_regular_tabs = false,
        view = "multiwindow",
        show_buffer_close_icons = true,
        separator_style = "thin",
        mappings = "true"
    },
    -- bar colors!!
    highlights = {
        fill = {
            guifg = "#fdf6e3",
            guibg = "#fdf6e3"
        },
        background = {
            guifg = bar_fg,
            guibg = "#fdf6e3"
        },
        -- buffer
        buffer_selected = {
            guifg = activeBuffer_fg,
            guibg = "#eee8d5",
            gui = "bold"
        },
        buffer_visible = {
            guifg = "#002b36",
            guibg = "#fdf6e3"
        },
        -- tabs over right
        tab = {
            guifg = "#002b36",
            guibg = "#fdf6e3"
        },
        tab_selected = {
            guifg = "#002b36",
            guibg = "#fdf6e3"
        },
        tab_close = {
            guifg = "#002b36",
            guibg = "#fdf6e3"
        },
        -- buffer separators
        separator = {
            guifg = "#fdf6e3",
            guibg = "#fdf6e3"
        },
        separator_selected = {
            guifg = "#fdf6e3",
            guibg = "#fdf6e3"
        },
        separator_visible = {
            guifg = "#fdf6e3",
            guibg = "#fdf6e3"
        },
        indicator_selected = {
            guifg = "#fdf6e3",
            guibg = "#fdf6e3"
        },
        -- modified files (but not saved)
        modified_selected = {
            guifg = "#A3BE8C",
            guibg = "#fdf6e3"
        },
        modified_visible = {
            guifg = "#BF616A",
            guibg = "#d8ccc4"
        }
    }
}


