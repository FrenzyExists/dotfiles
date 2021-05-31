" A shameless rip from different dotfiles put together with FLEX TAPE

" ---| Some Notes Frenzy took while watching Luke "Bald Neonazi" Smith |---
" Force quit pressing ZQ while on normal mode, stop using :q!
" Quit and save pressing ZZ while on normal mode, no more :wq
" zz to center cursor at center
" zb to center at bottom
" zt to center at top
" While on normal mode, use  "{" or "}" to move through paragraphs
" Press Shift+a while on normal mode to enter Insert Mode at the end of the
" line
" Press Shift+i while on normal mode to enter Insert Mode at the beginning of
" the line
" Press s while on normal mode to delete one character to the left and enter
" normal mode
" While selecting on visual mode, do this -> :sort  This will sort whatever
" you have, super useful when dealing with list while coding n stuff
" while on normal mode, press d$ to delete everything that is after the
" cursor at the current line the cursor is
" The other way is just press shift+d
" The $ sign means "end of the line" its something bout regular expressions
" press c two times while on normal mode to delete line
"
" Something about splits
" Max out the height of the current split
" Ctrl + w _
"
" Max out the width of the current split
" Ctrl + w |
"
" Normalize all split sizes, which is very handy when resizing terminal
" Ctrl + w =
"
"Swap top/bottom or left/right split
" Ctrl+W R
"
" Break out current window into a new tabview
" Ctrl+W T
"
" Close every window in the current tabview but the current one
" Ctrl+W o


" ensure vim-plug is installed and then load it
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
	silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" For icons n stuff
set encoding=UTF-8

call plug#begin('~/.local/share/nvim/site/plugged')

" ---| Plug Moment |---

" The status bar thingy
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}

" Icons for File Tree
Plug 'kyazdani42/nvim-web-devicons'

" File Tree
Plug 'kyazdani42/nvim-tree.lua'

" Whatever is this
"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Multiple Cursors
"Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" Cpp Support
Plug 'bfrg/vim-cpp-modern'

" Fancy startup screen
Plug 'glepnir/dashboard-nvim'

" Java autocompletion
Plug 'artur-shaik/vim-javacomplete2'

" My own colorscheme
Plug 'frenzyexists/aquarium-vim'

" Mappings to easily delete, change or add surroundings
Plug 'tpope/vim-surround'

" Icons
Plug 'ryanoasis/vim-devicons'

" Snippets and text editing support
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}

" Color highlighter
Plug 'norcalli/nvim-colorizer.lua'

" Generates comment frames
Plug 'cometsong/CommentFrame.vim'

" Auto close tags, useful for html
Plug 'alvan/vim-closetag'

" Identations
Plug 'Yggdroot/indentLine'

" Controlling Git
Plug 'tpope/vim-fugitive'

" All the lua functions you write twice.
Plug 'nvim-lua/plenary.nvim'

" Remaps the Caps-Lock key for escape on nvim
Plug 'tpope/vim-capslock'

" Search Thingy
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " TODO: learn features

" Autoclose
Plug 'townk/vim-autoclose'

call plug#end()

" ---| Configuring everything |---

" Go Aquarium go!
colorscheme aquarium

" No Softwrapping
set nowrap
set textwidth=0
set wrapmargin=0

" Line numbers
set number
set numberwidth=6

" Something something
set showcmd
set undofile

" no Swap error file thing
set noswapfile

" Terminal Colors
set termguicolors

" set tabs to have 4 spaces
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set shiftround
set smartindent

" Rebind for tab movement
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>

" Split faster (fast as fuc boi)
nnoremap <leader>\ :vs<CR>
nnoremap <leader>- :sp<CR>

" Move between each split Faster
map <C-k> <C-w>k
map <C-j> <C-w>j
map <C-l> <C-w>l
map <C-h> <C-w>h

" More natural slit opening
set splitbelow
set splitright

"Open terminal on the bottom 
function! OpenTerminal()
  split term://zsh
  resize 10
endfunction
nnoremap <c-x> :call OpenTerminal()<CR>
nnoremap <c-b> :vnew term://zsh<CR>

" Highlight matching pairs of brackets. Use the '%' character to jump between them.
set matchpairs+=<:>

" Remap for next snippet
let g:coc_snippet_next = '<tab>'

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Change end of buffer color
"highlight EndOfBuffer ctermfg=black ctermbg=black
set fcs+=eob:\ 

" --| Dashboard Config |--

nmap <Leader>ss :<C-u>SessionSave<CR>
nmap <Leader>sl :<C-u>SessionLoad<CR>
nnoremap <silent> <Leader>fh :DashboardFindHistory<CR>
nnoremap <silent> <Leader>ff :DashboardFindFile<CR>
nnoremap <silent> <Leader>tc :DashboardChangeColorscheme<CR>
nnoremap <silent> <Leader>fa :DashboardFindWord<CR>
nnoremap <silent> <Leader>fb :DashboardJumpMark<CR>
nnoremap <silent> <Leader>cn :DashboardNewFile<CR>


" --| Indentline Config |--

let g:indentLine_color_term = 238

" Exclude IdentLine from a few thingies
let g:indentLine_fileTypeExclude = ['help', 'terminal', 'dashboard']


" --| Nvim Tree Config |--

" List of filenames that gets highlighted with NvimTreeSpecialFile
let g:nvim_tree_special_files = [ 'README.md', 'Makefile', 'MAKEFILE' ]

" ---| Lua Config for Tree, Icon |---

lua <<EOF

vim.g.nvim_tree_side = "left"

-- Tree width
vim.g.nvim_tree_width = 26
vim.g.nvim_tree_ignore = {".git", "node_modules", ".cache"}
vim.g.nvim_tree_auto_open = 0
vim.g.nvim_tree_auto_close = 0
vim.g.nvim_tree_quit_on_open = 0
vim.g.nvim_tree_follow = 1
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_hide_dotfiles = 1
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_root_folder_modifier = ":~"
vim.g.nvim_tree_allow_resize = 1

vim.g.nvim_tree_show_icons = {
    git = 1,
    folders = 1,
    files = 1
}

vim.g.nvim_tree_icons = {
    default = '',
    symlink = '',
    git  = {
      unstaged = "",
      staged = "✓",
      unmerged = "",
      renamed = "",
      untracked = "",
      deleted = "",
      ignored = ""
      },
    folder  = {
      default = "",
      open = "",
      empty = "",
      empty_open = "",
      symlink = "",
      symlink_open = "",
      },
      lsp  = {
        hint = "",
        info = "",
        warning = "",
        error = "",
        }
}

local get_lua_cb = function (cb_name)
  return string.format(":lua require'nvim-tree'.on_keypress('%s')<CR>", cb_name)
end

-- Set Nvim Tree bindings
vim.g.nvim_tree_bindings = {
  ["<CR>"]           = get_lua_cb("edit"),
  ["o"]              = get_lua_cb("edit"),
  ["<2-LeftMouse>"]  = get_lua_cb("edit"),
  ["<2-RightMouse>"] = get_lua_cb("cd"),
  ["<C-]>"]          = get_lua_cb("cd"),
  ["<C-v>"]          = get_lua_cb("vsplit"),
  ["<C-x>"]          = get_lua_cb("split"),
  ["<C-t>"]          = get_lua_cb("tabnew"),
  ["<BS>"]           = get_lua_cb("close_node"),
  ["<S-CR>"]         = get_lua_cb("close_node"),
  ["<Tab>"]          = get_lua_cb("preview"),
  ["I"]              = get_lua_cb("toggle_ignored"),
  ["H"]              = get_lua_cb("toggle_dotfiles"),
  ["R"]              = get_lua_cb("refresh"),
  ["a"]              = get_lua_cb("create"),
  ["d"]              = get_lua_cb("remove"),
  ["r"]              = get_lua_cb("rename"),
  ["<C-r>"]          = get_lua_cb("full_rename"),
  ["x"]              = get_lua_cb("cut"),
  ["c"]              = get_lua_cb("copy"),
  ["p"]              = get_lua_cb("paste"),
  ["[c"]             = get_lua_cb("prev_git_item"),
  ["]c"]             = get_lua_cb("next_git_item"),
  ["-"]              = get_lua_cb("dir_up"),
  ["q"]              = get_lua_cb("close"),
}


-- Set Icons
require "nvim-web-devicons".setup {
    override = {
        html = {
            icon = "",
            color = "#DE8C92",
            name = "html"
        },
        css = {
            icon = "",
            color = "#61afef",
            name = "css"
        },
        js = {
            icon = "",
            color = "#EBCB8B",
            name = "js"
        },
        ts = {
            icon = "ﯤ",
            color = "#519ABA",
            name = "ts"
        },
        kt = {
            icon = "󱈙",
            color = "#ffcb91",
            name = "kt"
        },
        png = {
            icon = " ",
            color = "#BD77DC",
            name = "png"
        },
        jpg = {
            icon = " ",
            color = "#BD77DC",
            name = "jpg"
        },
        jpeg = {
            icon = " ",
            color = "#BD77DC",
            name = "jpeg"
        },
        mp3 = {
            icon = "",
            color = "#C8CCD4",
            name = "mp3"
        },
        mp4 = {
            icon = "",
            color = "#C8CCD4",
            name = "mp4"
        },
        out = {
            icon = "",
            color = "#C8CCD4",
            name = "out"
        },
        Dockerfile = {
            icon = "",
            color = "#b8b5ff",
            name = "Dockerfile"
        },
        rb = {
            icon = "",
            color = "#ff75a0",
            name = "rb"
        },
        vue = {
            icon = "﵂",
            color = "#7eca9c",
            name = "vue"
        },
        py = {
            icon = "",
            color = "#a7c5eb",
            name = "py"
        },
        toml = {
            icon = "",
            color = "#61afef",
            name = "toml"
        },
        lock = {
            icon = "",
            color = "#DE6B74",
            name = "lock"
        },
        zip = {
            icon = "",
            color = "#EBCB8B",
            name = "zip"
        },
        xz = {
            icon = "",
            color = "#EBCB8B",
            name = "xz"
        },
        deb = {
            icon = "",
            color = "#a3b8ef",
            name = "deb"
        },
        rpm = {
            icon = "",
            color = "#fca2aa",
            name = "rpm"
        }
    }
}
EOF

" Source Lua bar
luafile ~/.config/nvim/lua/cfg/aquariumline.lua


nnoremap <C-a> :NvimTreeToggle<CR>

nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

" a list of groups can be found at `:help nvim_tree_highlight`
"highlight NvimTreeFolderIcon guibg=blue


