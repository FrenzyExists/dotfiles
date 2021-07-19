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

" Colorizer for hex
Plug 'norcalli/nvim-colorizer.lua'

" Icons for File Tree
Plug 'kyazdani42/nvim-web-devicons'

" Errors
Plug 'folke/trouble.nvim'

" Automatic lspinstall
Plug 'kabouzeid/nvim-lspinstall'

" File Tree
Plug 'kyazdani42/nvim-tree.lua'

" Tab thingy
Plug 'akinsho/nvim-bufferline.lua'

" Multiple Cursors
"Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" Toggle Comments or something
Plug 'terrortylor/nvim-comment'

" Fancy startup screen
Plug 'glepnir/dashboard-nvim'

" Java autocompletion
"Plug 'artur-shaik/vim-javacomplete2'

" My own colorscheme
Plug 'frenzyexists/aquarium-vim'

" Mappings to easily delete, change or add surroundings
Plug 'tpope/vim-surround'

" Icons
Plug 'ryanoasis/vim-devicons'

" Color highlighter
Plug 'norcalli/nvim-colorizer.lua'

" Generates comment frames
Plug 'cometsong/CommentFrame.vim'

" Auto close tags, useful for html
Plug 'alvan/vim-closetag'

" Identations
Plug 'Yggdroot/indentLine'

" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Markdown syntax
Plug 'plasticboy/vim-markdown'

" LaTeX syntax/
" Plug 'lervag/vimtex'

" A Vim Plugin for Lively Previewing LaTeX PDF Output
"Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
"Plug 'neoclide/coc-snippets'

" Controlling Git
Plug 'tpope/vim-fugitive'

" All the lua functions you write twice.
Plug 'nvim-lua/plenary.nvim'

" Search Thingy
Plug 'liuchengxu/vim-clap'

" Autoclose
Plug 'townk/vim-autoclose'

" LSP
Plug 'neovim/nvim-lspconfig'

Plug 'hrsh7th/nvim-compe'

call plug#end()

" ---| Configuring everything |---

" Spell Check
" set spell "NOPE

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

" No Search Highlight when unneded
set nohlsearch
set noerrorbells



" Gui Cursor!
:set guicursor=n-v-c:underline,i-ci-ve:ver25,r-cr:hor20,o:hor50
		  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
		  \,sm:block-blinkwait175-blinkoff150-blinkon175

" Abandon buffer when unloaded
set hidden

" Who needs gui background when your terminal has the same theme?
highlight Normal guibg=none

" No Backup!
set nobackup
" Rebind for tab movement
nnoremap <C-w> :tabprevious<CR>
nnoremap <C-e> :tabnext<CR>
nnoremap <C-n> :tabnew<CR>
nnoremap <c-m> :tabclose<CR>

" Save
nnoremap <C-s> :w<CR>
map <C-S-s> :wq<CR>

" In case you have probs, look this:
" https://www.reddit.com/r/neovim/comments/mbj8m5/how_to_setup_ctrlshiftkey_mappings_in_neovim_and/

" Split faster (fast as fuc boi)
nnoremap <leader>\ :vs<CR>
nnoremap <leader>- :sp<CR>

" Move between each split Faster
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" More natural window resize 
map <A-k> :resize+5<CR>
map <A-j> :resize-5<CR>
map <A-h> :vertical resize-5<CR>
map <A-l> :vertical resize+5<CR>

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

set mouse=a

" Remap for next snippet
"let g:coc_snippet_next = '<tab>'

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

augroup COMPILER
    autocmd!
    let s:args = ' "%" -o "%:r" && ./"%:r" && rm "%:r"'
    let s:java_args = ' "%" && java "%:r" && rm "%:r".class'
    let s:hs_args = ' "%" -o "%:r" && ./"%:r" && rm "%:r" "%:r".o "%:r".hi'
    let s:latex_args = ' "%" && rm "%:r".aux "%:r".log && evince "%:r".pdf && rm "%:r".pdf'
    autocmd FileType cpp,cc let &makeprg = 'clang++'.s:args
    autocmd FileType c let &makeprg = 'clang'.s:args
    autocmd FileType rust let &makeprg = 'rustc'.s:args
    autocmd FileType javascript let &makeprg = 'node "%"'
    autocmd FileType java let &makeprg = 'javac'.s:java_args
    autocmd FileType python let &makeprg = 'python3 "%"'
    autocmd FileType haskell let &makeprg = 'ghc'.s:hs_args
    autocmd FileType tex let &makeprg = 'pdflatex'.s:latex_args
    autocmd FileType cpp,cc,c,rust,javascript,java,python,haskell,tex nnoremap CT :make<cr>
    autocmd FileType rust nnoremap ct :!cargo run<cr>
    autocmd FileType rust nnoremap RF :RustFmt<cr>
augroup END

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
            color = "#ffcf85",
            name = "js"
        },
        ts = {
            icon = "",
            color = "#ffcf85",
            name = "ts"
        },
        kt = {
            icon = "󱈙",
            color = "#b8dceb",
            name = "kt"
        },
        png = {
            icon = "",
            color = "#ebb9b9",
            name = "png"
        },
        jpg = {
            icon = "",
            color = "#ebb9b9",
            name = "jpg"
        },
        jpeg = {
            icon = "",
            color = "#ebb9b9",
            name = "jpeg"
        },
        mp3 = {
            icon = "",
            color = "#C8CCD4",
            name = "mp3"
        },
        mp4 = {
            icon = "",
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
            icon = "",
            color = "#ebb9b9",
            name = "rb"
        },
        vue = {
            icon = "﵂",
            color = "#8fc587",
            name = "vue"
        },
        py = {
            icon = "",
            color = "#cddbf9",
            name = "py"
        },
        toml = {
            icon = "",
            color = "#3b3b4d",
            name = "toml"
        },
        lock = {
            icon = "",
            color = "#ebb9b9",
            name = "lock"
        },
        zip = {
            icon = "遲",
            color = "#ffcf85",
            name = "zip"
        },
        xz = {
            icon = "遲",
            color = "#ffcf85",
            name = "xz"
        },
        deb = {
            icon = "",
            color = "#076678",
            name = "deb"
        },
        rpm = {
            icon = "",
            color = "#fca2aa",
            name = "rpm"
        },
        vim = {
            icon = "",
            color = "#8fc587",
            name = "vim"
            },
        md = {
            icon = "",
            color = "#cddbf9",
            name = "md"
            },
        lua = {
            icon = "",
            color = "#076678",
            name = "lua"
            },
        pdf = {
            icon = "",
            color = "#d95e59",
            name = "pdf"
            }
    }
}
EOF

" Source Lua bar
luafile ~/.config/nvim/lua/cfg/aquariumline.lua

" Source Lua tab bar
luafile ~/.config/nvim/lua/cfg/aquariumbufferline.lua

" LSP Lua
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys 
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    require'completion'.on_attach(client)

    --Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

-- RUST STUFF
-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "pyright", "rust_analyzer", "tsserver" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end

require'lspconfig'.rust_analyzer.setup{}


-- Colorizer
require'colorizer'.setup()

vim.o.completeopt = "menuone,noselect"

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
  };
}

-- ERROR Thing
require("trouble").setup {}

-- lspinstall
require'lspinstall'.setup() -- important

require'lspconfig'.beancount.setup{}

local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  require'lspconfig'[server].setup{}
end

-- Dashboard


local g = vim.g

g.dashboard_custom_header = {
            ' ', 
            '⠸⣷⣦⠤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⠀⠀⠀ ',
            '⠀⠙⣿⡄⠈⠑⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠔⠊⠉⣿⡿⠁⠀⠀⠀ ',
            '⠀⠀⠈⠣⡀⠀⠀⠑⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠊⠁⠀⠀⣰⠟⠀⠀⠀⣀⣀ ',
            '⠀⠀⠀⠀⠈⠢⣄⠀⡈⠒⠊⠉⠁⠀⠈⠉⠑⠚⠀⠀⣀⠔⢊⣠⠤⠒⠊⠉⠀⡜ ',
            '⠀⠀⠀⠀⠀⠀⠀⡽⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠩⡔⠊⠁⠀⠀⠀⠀⠀⠀⠇ ',
            '⠀⠀⠀⠀⠀⠀⠀⡇⢠⡤⢄⠀⠀⠀⠀⠀⡠⢤⣄⠀⡇⠀⠀⠀⠀⠀⠀⠀⢰⠀ ',
            '⠀⠀⠀⠀⠀⠀⢀⠇⠹⠿⠟⠀⠀⠤⠀⠀⠻⠿⠟⠀⣇⠀⠀⡀⠠⠄⠒⠊⠁⠀ ',
            '⠀⠀⠀⠀⠀⠀⢸⣿⣿⡆⠀⠰⠤⠖⠦⠴⠀⢀⣶⣿⣿⠀⠙⢄⠀⠀⠀⠀⠀⠀ ',
            '⠀⠀⠀⠀⠀⠀⠀⢻⣿⠃⠀⠀⠀⠀⠀⠀⠀⠈⠿⡿⠛⢄⠀⠀⠱⣄⠀⠀⠀⠀ ',
            '⠀⠀⠀⠀⠀⠀⠀⢸⠈⠓⠦⠀⣀⣀⣀⠀⡠⠴⠊⠹⡞⣁⠤⠒⠉⠀⠀⠀⠀⠀ ',
            '⠀⠀⠀⠀⠀⠀⣠⠃⠀⠀⠀⠀⡌⠉⠉⡤⠀⠀⠀⠀⢻⠿⠆⠀⠀⠀⠀⠀⠀⠀ ',
            '⠀⠀⠀⠀⠀⠰⠁⡀⠀⠀⠀⠀⢸⠀⢰⠃⠀⠀⠀⢠⠀⢣⠀⠀⠀⠀⠀⠀⠀⠀ ',
            '⠀⠀⠀⢶⣗⠧⡀⢳⠀⠀⠀⠀⢸⣀⣸⠀⠀⠀⢀⡜⠀⣸⢤⣶⠀⠀⠀⠀⠀⠀ ',
            '⠀⠀⠀⠈⠻⣿⣦⣈⣧⡀⠀⠀⢸⣿⣿⠀⠀⢀⣼⡀⣨⣿⡿⠁⠀⠀⠀⠀⠀⠀ ',
            '⠀⠀⠀⠀⠀⠈⠻⠿⠿⠓⠄⠤⠘⠉⠙⠤⢀⠾⠿⣿⠟⠋         '
}

--g.dashboard_custom_section = {
--    a = {description = {"  Find File                 SPC f f"}, command = "Telescope find_files"},
--    b = {description = {"  Recents                   SPC f o"}, command = "Telescope oldfiles"},
--    d = {description = {"洛 New File                  SPC f n"}, command = "DashboardNewFile"},
--    f = {description = {"  Load Last Session         SPC s l"}, command = "SessionLoad"}
--}



g.dashboard_custom_footer = {
    "PikaVim v0.1"
}

vim.api.nvim_exec(
    [[
   au BufEnter,BufWinEnter,WinEnter,CmdwinEnter * if bufname('%') == "NvimTree" | set laststatus=0 | else | set laststatus=2 | endif
]],
    false
)

local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= "o" then
        scopes["o"][key] = value
    end
end

opt("o", "ruler", false)


EOF

nnoremap <C-a> :NvimTreeToggle<CR>

nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

" a list of groups can be found at `:help nvim_tree_highlight`
"highlight NvimTreeFolderIcon guibg=blue


" Markdown
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0
    \ }


" hi! StatusLineNC gui=underline guifg=#somecolor
"

