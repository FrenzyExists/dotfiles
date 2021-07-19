
local bl = require("bufferline")
local bfs = bl.setup

require "bufferline".setup {
    options = {
        close_command = "bdelete! %d",       -- can be a string | function, see "Mouse actions"
        right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
        left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
        middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
        offsets = {{filetype = "NvimTree", text = "Explorer"}},
        buffer_close_icon = " ",
        modified_icon = "●",
        close_icon = " ",
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
            guifg = "#caf6bb",
            guibg = "#2c2e3e"
        },
        background = {
            guifg = "#a0a8b6",
            guibg = "#2c2e3e"
        },
        -- buffer
        buffer_selected = {
            guifg = "#8791a3",
            guibg = "#1b1b23",
            gui = "italicbold"
        },
        buffer_visible = {
            guifg = "#ebe3b9",
            guibg = "#1b1b23"
        },
        -- tabs over right
        tab = {
            guifg = "#ebe3b9",
            guibg = "#1b1b23"
        },
        tab_selected = {
            guifg = "#caf6bb",
            guibg = "#2c2e3e"
        },
        tab_close = {
            guifg = "#ebb9b9",
            guibg = "#2c2e3e"
        },
        -- buffer separators
        separator = {
            guifg = "#1b1b23",
            guibg = "#1b1b23"
        },
        separator_selected = {
            guifg = "#2c2e3e",
            guibg = "#2c2e3e"
        },
        separator_visible = {
            guifg = "#2c2e3e",
            guibg = "#2c2e3e"
        },
        indicator_selected = {
            guifg = "#2c2e3e",
            guibg = "#cddbf9"
        },
        -- modified files (but not saved)
        modified_selected = {
            guifg = "#3b3b4d",
            guibg = "#1b1b23"
        },
        modified_visible = {
            guifg = "#8791a3",
            guibg = "#ebe3b9"
        }
    }
}

diagnostics_indicator = function(count, level, diagnostics_dict, context)
  local s = " "
  for e, n in pairs(diagnostics_dict) do
    local sym = e == "error" and " "
      or (e == "warning" and " " or "" )
    s = s .. n .. sym
  end
  return s
end



