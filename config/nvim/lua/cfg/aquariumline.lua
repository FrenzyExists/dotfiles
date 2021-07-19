
local gl = require("galaxyline")
local gls = gl.section

gl.short_line_list = {" "}

local colors = {
    bg = "#1b1b23",
    fg = "#abb2bf",
    green = "#8fc587",
    red = "#ebb9b9",
    lightbg = "#2c2e3e",
    lightbg2 = "#3b3b4d",
    blue = "#cddbf9",
    yellow = "#ffcf85",
    grey = "#8791a3",
    magenta = "#bf83b5"
}


local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
    return true
  end
  return false
end


gls.left[1] = {
    FirstyIcon = {
        provider = function()
            return ""
        end,
        highlight = {colors.bg, colors.blue},
        separator = "  ",
        separator_highlight = {colors.blue, colors.bg}
    }
}


gls.left[2] = {
    statusIcon = {
        provider = function()
            return "  "
        end,
        highlight = {colors.bg, colors.blue},
        separator = "  ",
        separator_highlight = {colors.blue, colors.lightbg}
    }
}

gls.left[3] = {
    FileIcon = {
        provider = "FileIcon",
        condition = buffer_not_empty,
        highlight = {colors.fg, colors.lightbg}
    }
}

gls.left[4] = {
    FileName = {
        provider = {"FileName"},
        condition = buffer_not_empty,
        highlight = {colors.fg, colors.lightbg},
        separator = " ",
        separator_highlight = {colors.lightbg, colors.lightbg2}
    }
}

gls.left[5] = {
    current_dir = {
        provider = function()
            local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            return "  " .. dir_name .. " "
        end,
        highlight = {colors.lightbg1, colors.lightbg2, 'italicbold'},
        separator = " ",
        separator_highlight = {colors.lightbg2, colors.bg}
    }
}

local checkwidth = function()
    local squeeze_width = vim.fn.winwidth(0) / 2
    if squeeze_width > 30 then
        return true
    end
    return false
end

gls.left[6] = {
    DiffAdd = {
        provider = "DiffAdd",
        condition = checkwidth,
        icon = "  ",
        highlight = {colors.fg, colors.bg}
    }
}

gls.left[7] = {
    DiffModified = {
        provider = "DiffModified",
        condition = checkwidth,
        icon = "   ",
        highlight = {colors.grey, colors.bg}
    }
}

gls.left[8] = {
    DiffRemove = {
        provider = "DiffRemove",
        condition = checkwidth,
        icon = "  ",
        highlight = {colors.grey, colors.bg}
    }
}

gls.left[9] = {
    DiagnosticError = {
        provider = "DiagnosticError",
        icon = "  ",
        highlight = {colors.red, colors.bg}
    }
}

gls.left[10] = {
    DiagnosticWarn = {
        provider = "DiagnosticWarn",
        icon = "  ",
        highlight = {colors.yellow, colors.bg}
    }
}

gls.right[1] = {
    GitIcon = {
        provider = function()
            return "   "
        end,
        condition = require("galaxyline.provider_vcs").check_git_workspace,
        highlight = {colors.grey, colors.lightbg},
        separator = "",
        separator_highlight = {colors.lightbg, colors.bg}
    }
}

gls.right[2] = {
    GitBranch = {
        provider = "GitBranch",
        condition = require("galaxyline.provider_vcs").check_git_workspace,
        highlight = {colors.grey, colors.lightbg}
    }
}

gls.right[3] = {
    viMode_icon = {
        provider = function()
            return "  "
        end,
        highlight = {colors.bg, colors.red},
        separator = " ",
        separator_highlight = {colors.red, colors.lightbg}
    }
}

gls.right[4] = {
  ViMode = {
    provider = function()
      local alias = {n = '  Normal ',i = '  Insert ',c= '  Command ',v= '  Visual ',V= '  Visual Line ', [''] = '  Visual Block '}
      return alias[vim.fn.mode()]
    end,
    separator_highlight = {colors.blue,function()
      if not buffer_not_empty() then
        return colors.blue
      end
      return colors.yellow
    end},
    highlight = {colors.red, colors.lightbg, 'italicbold'},
  },
}

gls.right[5] = {
    time_begin = {
        provider = function()
            return " "
        end,
        separator = "",
        separator_highlight = {colors.yellow, colors.lightbg},
        highlight = {colors.lightbg, colors.yellow}
    }
}

gls.right[6] = {
    time = {
        provider = function()
            return "  " .. os.date("%H:%M") .. "  "
        end,
    highlight = {colors.yellow, colors.lightbg, 'italicbold'}
    }
}

gls.right[7] = {
    time_end = {
        provider= function()
            return ""
        end,
        separator = "  ",
        separator_highlight = {colors.lightbg, colors.bg}
    }
}
