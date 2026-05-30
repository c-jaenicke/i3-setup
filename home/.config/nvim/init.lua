-- ################################################################################################## 
-- Neovim Text Editor
-- ################################################################################################## 
-- ########################################################################
-- Cheat Sheet / Keybindings Reference
-- ########################################################################
--
-- LEADER KEY: ',' (comma)
--
-- === GLOBAL HOTKEYS =====================================================
--
-- === Telescope (Fuzzy Finding) ===
-- <leader>ff   : Find files
-- <leader>fg   : Find text / live grep
-- <leader>fb   : Find buffers
--
-- === Neo-tree (File Explorer) ===
-- :Neotree toggle : Open/Close the file explorer sidebar
--
-- === Window & Split Management ===
-- :vsp / :sp   : Create a Vertical / Horizontal split (Command)
-- <C-w>v / <C-w>s : Create a Vertical / Horizontal split (Hotkey)
-- :q           : Close the current split (Command)
-- <C-w>q / <C-w>c : Close the current split (Hotkey)
-- <C-h/j/k/l>  : Move cursor to left/lower/upper/right split (Smart-Splits)
-- <C-\>        : Move cursor to previous split (Smart-Splits)
-- <A-h/j/k/l>  : Resize split left/down/up/right (Smart-Splits)
-- <leader><leader>h/j/k/l : Swap current buffer with left/lower/upper/right split
--
-- === Trouble (Diagnostics & Symbols UI) ===
-- <leader>xx   : Toggle Diagnostics list
-- <leader>xX   : Toggle Buffer Diagnostics
-- <leader>cs   : Toggle Symbols list
-- <leader>cl   : Toggle LSP Definitions/References
-- <leader>xL   : Toggle Location List
-- <leader>xQ   : Toggle Quickfix List
--
-- === Neogit & Diffview (Git UI) ===
-- <leader>gg   : Show Neogit UI
-- :DiffviewOpen: Open diff interface (Command only)
--
-- === General UI & LSP Navigation ===
-- K            : Hover documentation / Type signatures (Neovim LSP default)
-- gl           : Show line diagnostics in a floating window (Manual shortcut)
-- gd           : Go to definition (Neovim LSP default)
-- gr           : Go to references (Neovim LSP default)
-- [d / ]d      : Go to previous/next diagnostic (Neovim LSP default)
-- <F5>         : Toggle invisible characters (whitespace, tabs, eol)
--
-- === Formatting, Linting & Tools ===
-- <leader>fo   : Format code (normal mode or visual selection)
-- :Format      : Formats the whole file or current visual selection
-- :Lint        : Manually run linters for the current file
-- :ShowError   : Show diagnostic error at the current cursor position
-- :Mason       : Open UI to manage LSPs, formatters, and linters
-- :Lazy        : Open UI to manage Neovim plugins
--
-- === Autocomplete & Snippets (blink.cmp) ===
-- <Tab>        : Accept current completion (super-tab preset)
-- <C-space>    : Open autocomplete menu or documentation
-- <C-n> / <C-p>: Select next / previous item (Up / Down arrows also work)
-- <C-e>        : Hide autocomplete menu
-- <C-k>        : Toggle signature help
--
-- === Custom Commands ===
-- :SpellDE     : Enable German spellchecker
-- :SpellEN     : Enable English spellchecker
-- :MDNexImage  : Instantly insert a Markdown image template `![Bild](/preview)`
--
-- === PLUGIN UI DEFAULTS (Only work inside the plugin's window) ========
--
-- --- Neo-tree Sidebar ---
-- <CR> / o     : Open file or toggle directory open/closed
-- s            : Open file in a vertical split
-- a            : Add (create) a new file or directory
-- d            : Delete file or directory
-- r            : Rename file or directory
-- c / p        : Copy / Paste
-- q            : Close Neo-tree window
--
-- --- Telescope Popup ---
-- <Esc>        : Close Telescope window
-- <C-n> / <C-p>: Move selection down/up
-- <CR>         : Open selected file
-- <C-v>        : Open selected file in a vertical split
-- <C-x>        : Open selected file in a horizontal split
--
-- --- Neogit ---
-- <Tab>        : Toggle diff view for the item under cursor
-- s            : Stage item under cursor
-- u            : Unstage item under cursor
-- c            : Open commit popup
--
-- --- Trouble UI ---
-- <CR>         : Jump to the selected error/item
-- q            : Close the Trouble window
--
-- === Essential Vim Defaults ===
-- h, j, k, l   : Move left, down, up, right
-- i / I        : Insert mode before cursor / at beginning of line
-- a / A        : Append mode after cursor / at end of line
-- o / O        : Open new line below / above and enter insert mode
-- v / V / <C-v>: Visual mode (character) / Line mode / Block mode
-- y / p        : Yank (copy) / Put (paste) -> NOTE: Linked to system clipboard!
-- d / dd / dw  : Delete (cut) selection / entire line / word
-- u / <C-r>    : Undo / Redo
-- / or ?       : Search forward / backward (press 'n' for next match, 'N' for prev)
-- :w           : Save (write)
-- :wq or :x    : Save and Quit
-- ########################################################################

vim.scriptencoding = 'utf8'

-- map leader to ,
vim.g.mapleader = ','

-- system clipboard (requires +clipboard)
vim.opt.clipboard:append('unnamed,unnamedplus') -- set clipboard+=
-- enable vim mode lines
vim.opt.modeline = true
-- highlight search items
vim.opt.hlsearch = true
-- searches are performed as you type
vim.opt.incsearch = true
-- enable line numbers
vim.opt.number = true
-- Enable relative line numbering
vim.opt.relativenumber = true
-- ask confirmation like save before quit.
vim.opt.confirm = true
-- Tab completion menu when using command mode
vim.opt.wildmenu = true
-- Tab key inserts spaces not tabs
vim.opt.expandtab = true
-- spaces to enter for each tab
vim.opt.softtabstop = 4
-- amount of spaces for indentation
vim.opt.shiftwidth = 4
-- Hide or shorten certain messages
vim.opt.shortmess:append('aAcIws')
-- Show current mode vim is in
vim.opt.showmode = true
-- set line length too 100 chars
vim.opt.textwidth = 100
-- display red line as marker for text width + 1 chars
vim.opt.colorcolumn = '+1'
-- set background to dark
vim.opt.background = 'dark'
-- enable custom status line
vim.opt.laststatus = 2
-- show commands/keys as they are being typed in
vim.opt.showcmd = true
-- enable mouse awareness
vim.opt.mouse = 'a'
-- Set hover time to 300ms
vim.o.updatetime = 300

-- enable file type specific plugins
vim.cmd('filetype plugin on')
-- enable syntax highlighting
vim.cmd('syntax enable')

-- #########################################################################
-- Spellchecker and highlighting
-- #########################################################################
-- enable spellcheck for language DE or EN
vim.api.nvim_create_user_command('SpellDE', function()
    vim.wo.spell = true
    vim.bo.spelllang = 'de'
end, {
    desc = 'Enable German spellcheck for current buffer'
})

vim.api.nvim_create_user_command('SpellEN', function()
    vim.wo.spell = true
    vim.bo.spelllang = 'en'
end, {
    desc = 'Enable English spellcheck for current buffer'
})

vim.api.nvim_set_hl(0, 'SpellBad', { undercurl = true, sp = 'red' })
vim.api.nvim_set_hl(0, 'SpellCap', { undercurl = true, sp = 'yellow' })
vim.api.nvim_set_hl(0, 'SpellRare', { undercurl = true, sp = 'green' })
vim.api.nvim_set_hl(0, 'SpellLocal', { undercurl = true, sp = 'gray' })

vim.api.nvim_set_hl(0, 'SpellBad', {
    cterm = {
        underline = true
    },
    ctermfg = 'red'
})
vim.api.nvim_set_hl(0, 'SpellCap', {
    cterm = {
        underline = true
    },
    ctermfg = 'yellow'
})
vim.api.nvim_set_hl(0, 'SpellRare', {
    cterm = {
        underline = true
    },
    ctermfg = 'green'
})
vim.api.nvim_set_hl(0, 'SpellLocal', {
    cterm = {
        underline = true
    },
    ctermfg = 'grey'
})

-- #########################################################################
-- Plugins
-- #########################################################################
-- Enable and load lazy.nvim
-- https://lazy.folke.io/installation
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({"git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath})
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({{"Failed to clone lazy.nvim:\n", "ErrorMsg"}, {out, "WarningMsg"},
                           {"\nPress any key to exit..."}}, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    spec = {{
        -- https://github.com/mason-org/mason.nvim
        "mason-org/mason.nvim",
        config = function()
            require("mason").setup()
        end
    }, {
        -- https://github.com/mason-org/mason-lspconfig.nvim
        "mason-org/mason-lspconfig.nvim",
        dependencies = {"mason-org/mason.nvim"},
        config = function()
            require("mason-lspconfig").setup({
                -- Tell Mason to ensure these LSPs are always installed
                -- Note: We use 'ts_ls' and 'bashls' as the correct standard names
                ensure_installed = {"lua_ls", "ruff", "ty", "ts_ls", "clangd", "bashls"},
                automatic_installation = false
            })
        end
    }, {
        -- Auto-installs your command-line formatters and linters
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = {"mason-org/mason.nvim"},
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    "prettier",
                    "stylelua",
                    "shfmt",
                    "eslint_d",
                    "markdownlint"
                },
                auto_update = false,
                run_on_start = false
            })
        end
    }, {
        -- https://github.com/nvim-lualine/lualine.nvim
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            local custom_readonly = function()
                if vim.bo.readonly then
                    return "[RO]"
                end
                return ""
            end

            local custom_modified = function()
                if vim.bo.modified then
                    return "[+]"
                end
                return ""
            end

            local custom_col = function()
                return "Pos:" .. vim.fn.col(".")
            end

            local custom_line = function()
                return "Line:" .. vim.fn.line(".") .. "/" .. vim.fn.line("$")
            end

            local custom_enc = function()
                return "[Enc:" .. (vim.o.fenc or vim.o.enc) .. "]"
            end

            local custom_ff = function()
                return "[Frmt:" .. vim.o.ff .. "]"
            end

            require("lualine").setup({
                options = {
                    theme = "auto",
                    icons_enabled = true,
                    component_separators = {
                        left = ' ',
                        right = ' '
                    },
                    section_separators = {
                        left = '--',
                        right = '--'
                    }
                },

                sections = {
                    lualine_a = {custom_readonly},
                    lualine_b = {custom_modified},
                    lualine_c = {{
                        'filename',
                        path = 3
                    }},

                    lualine_x = {'diagnostics', custom_enc, custom_ff},
                    lualine_y = {custom_col},
                    lualine_z = {custom_line}
                },

                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {{
                        'filename',
                        path = 3
                    }},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {}
                }
            })
        end
    }, {
        -- https://github.com/saghen/blink.cmp
        'saghen/blink.cmp',
        dependencies = {'rafamadriz/friendly-snippets'},
        version = '1.*',
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = {
                -- preset = 'default'
                preset = 'super-tab'
            },
            appearance = {
                nerd_font_variant = 'mono'
            },
            completion = {
                documentation = {
                    auto_show = false
                }
            },
            -- Default list of enabled providers defined so that you can extend it elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = {'lsp', 'path', 'snippets', 'buffer'},
                per_filetype = {
                    codecompanion = {"codecompanion"}
                }

            },

            fuzzy = {
                implementation = "prefer_rust_with_warning"
            }
        },
        opts_extend = {"sources.default"}
    }, {
        -- https://github.com/L3MON4D3/LuaS
        "L3MON4D3/LuaSnip",
        dependencies = {"rafamadriz/friendly-snippets"},
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end
    }, {
        "neovim/nvim-lspconfig",
        -- Add mason-lspconfig as a dependency so it loads first
        dependencies = {"saghen/blink.cmp", "williamboman/mason-lspconfig.nvim"},
        config = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            -- Updated list with correct names ('ts_ls' and 'bashls')
            local servers_to_enable = {"lua_ls", "ruff", "ty", "ts_ls", "clangd", "bashls"}

            for _, server_name in ipairs(servers_to_enable) do
                vim.lsp.config(server_name, {
                    capabilities = capabilities
                })
                vim.lsp.enable(server_name)
            end
        end
    }, {
        -- https://github.com/bluz71/vim-moonfly-colors
        "bluz71/vim-moonfly-colors",
        name = "moonfly",
        lazy = false,
        priority = 1000
    }, {
        -- https://github.com/windwp/nvim-autopairs
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    }, {
        -- https://github.com/nvim-treesitter/nvim-treesitter
        -- "nvim-treesitter/nvim-treesitter",
        -- branch = "main", -- Point to the new branch
        -- build = ":TSUpdate",
        -- config = function()
        --     -- The main branch no longer uses 'nvim-treesitter.configs'
        --      -- You now enable treesitter natively per-buffer or globally via Neovim's built-in API
        --      vim.api.nvim_create_autocmd("FileType", {
        --          callback = function(args)
        --              -- Check if a parser is installed before trying to start
        --              local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        --             if lang and vim.treesitter.query.get(lang, "highlights") then
        --                  vim.treesitter.start(args.buf)
        --              end
        --          end,
        --      })
        -- end
        -- https://github.com/romus204/tree-sitter-manager.nvim
        "romus204/tree-sitter-manager.nvim",
        dependencies = {}, -- tree-sitter CLI must be installed system-wide
        config = function()
            require("tree-sitter-manager").setup({
                ensure_installed = {},
                auto_install = true,
                highlight = true,
                languages = {}
            })
        end
    }, {
        -- https://github.com/mfussenegger/nvim-lint
        "mfussenegger/nvim-lint",
        event = "VeryLazy",
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                -- Uncomment ruff here to fix duplicate error messages
                -- python = {"ruff"},
                javascript = {"eslint_d"},
                typescript = {"eslint_d"},
                javascriptreact = {"eslint_d"},
                typescriptreact = {"eslint_d"},
                bash = {"shellcheck"},
                sh = {"shellcheck"}
                -- markdown = {"markdownlint"}
                -- Add more filetypes and linters here
            }
            -- This autocommand will run the linters on specific events.
            vim.api.nvim_create_autocmd({"BufWritePost", "BufEnter", "InsertLeave"}, {
                group = vim.api.nvim_create_augroup("nvim-lint", {
                    clear = true
                }),
                callback = function()
                    -- This `try_lint` function is the main command.
                    lint.try_lint()
                end
            })
        end
    }, {
        -- https://github.com/stevearc/conform.nvim
        "stevearc/conform.nvim",
        event = "VeryLazy",
        opts = {
            formatters_by_ft = {
                -- User asked for Prettier:
                javascript = {"prettier"},
                typescript = {"prettier"},
                javascriptreact = {"prettier"},
                typescriptreact = {"prettier"},
                css = {"prettier"},
                html = {"prettier"},
                json = {"prettier"},
                yaml = {"prettier"},
                markdown = {"prettier"},
                lua = {"stylelua"},
                -- python = {"black"},
                python = {"ruff_fix", "ruff_format"},
                bash = {"shfmt"},
                sh = {"shfmt"}
                -- Add more filetypes and formatters here
            }
            -- format_on_save = {
            --  timeout_ms = 500,
            --  lsp_fallback = true,
            -- },

        }
    }, {
        -- https://github.com/nvim-telescope/telescope.nvim
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = {{"nvim-lua/plenary.nvim"}},
        keys = {{
            "<leader>ff",
            "<cmd>Telescope find_files<cr>",
            desc = "Find files"
        }, {
            "<leader>fg",
            "<cmd>Telescope live_grep<cr>",
            desc = "Find text (grep)"
        }, {
            "<leader>fb",
            "<cmd>Telescope buffers<cr>",
            desc = "Find buffers"
        }},

        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            -- Close telescope on <esc>
                            ["<esc>"] = actions.close
                        }
                    }
                }
            })
        end
    }, {
        "NeogitOrg/neogit",
        lazy = true,
        dependencies = {"nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "m00qek/baleia.nvim",
                        "nvim-telescope/telescope.nvim"},
        cmd = "Neogit",
        keys = {{
            "<leader>gg",
            "<cmd>Neogit<cr>",
            desc = "Show Neogit UI"
        }}
    }, {
        "sindrets/diffview.nvim",
        lazy = true,
        cmd = "DiffviewOpen"

    }, {
        "nvim-pack/nvim-spectre",
        lazy = true,
        cmd = "Spectre"
    }, {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {{
            "<leader>xx",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)"
        }, {
            "<leader>xX",
            "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
            desc = "Buffer Diagnostics (Trouble)"
        }, {
            "<leader>cs",
            "<cmd>Trouble symbols toggle focus=false<cr>",
            desc = "Symbols (Trouble)"
        }, {
            "<leader>cl",
            "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
            desc = "LSP Definitions / references / ... (Trouble)"
        }, {
            "<leader>xL",
            "<cmd>Trouble loclist toggle<cr>",
            desc = "Location List (Trouble)"
        }, {
            "<leader>xQ",
            "<cmd>Trouble qflist toggle<cr>",
            desc = "Quickfix List (Trouble)"
        }}
    }, {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {"nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "nvim-tree/nvim-web-devicons" -- optional, but recommended
        },
        lazy = false, -- neo-tree will lazily load itself
        ---@module 'neo-tree'
        ---@type neotree.Config
        opts = {
            -- options go here
        }
    }, {
        'mrjones2014/smart-splits.nvim',
        config = function()
            require('smart-splits').setup({
                -- Ignored buffer types (only while resizing)
                ignored_buftypes = {'nofile', 'quickfix', 'prompt'},
                -- Ignored filetypes (only while resizing)
                ignored_filetypes = {'NvimTree'},
                -- the default number of lines/columns to resize by at a time
                default_amount = 3,
                -- Desired behavior when your cursor is at an edge and you
                -- are moving towards that same edge:
                -- 'wrap' => Wrap to opposite side
                -- 'split' => Create a new split in the desired direction
                -- 'stop' => Do nothing
                -- function => You handle the behavior yourself
                at_edge = 'wrap',
                -- Desired behavior when the current window is floating:
                -- 'previous' => Focus previous Vim window and perform action
                -- 'mux' => Always forward action to multiplexer
                float_win_behavior = 'previous',
                -- when moving cursor between splits left or right,
                -- place the cursor on the same row of the *screen*
                -- regardless of line numbers. False by default.
                move_cursor_same_row = false,
                -- whether the cursor should follow the buffer when swapping
                -- buffers by default; it can also be controlled by passing
                -- `{ move_cursor = true }` or `{ move_cursor = false }`
                -- when calling the Lua function.
                cursor_follows_swapped_bufs = false,
                -- ignore these autocmd events (via :h eventignore) while processing
                -- smart-splits.nvim computations, which involve visiting different
                -- buffers and windows. These events will be ignored during processing,
                -- and un-ignored on completed. This only applies to resize events,
                -- not cursor movement events.
                ignored_events = {'BufEnter', 'WinEnter'},
                -- enable or disable a multiplexer integration;
                -- automatically determined, unless explicitly disabled or set,
                -- by checking the $TERM_PROGRAM environment variable,
                -- and the $KITTY_LISTEN_ON environment variable for Kitty.
                multiplexer_integration = nil,
                -- disable multiplexer navigation if current multiplexer pane is zoomed
                disable_multiplexer_nav_when_zoomed = true,
                -- Supply a Kitty remote control password if needed
                kitty_password = nil,
                -- In Zellij, set this to true if you would like to move to the next *tab*
                -- when the current pane is at the edge of the zellij tab/window
                zellij_move_focus_or_tab = false,
                -- default logging level, one of: 'trace'|'debug'|'info'|'warn'|'error'|'fatal'
                log_level = 'info'
            })
        end
    } -- ADD PLUGINS HERE
    },
    install = {
        colorscheme = {"moonfly"}
    },
    -- automatically check for plugin updates
    checker = {
        enabled = false,
        notify = false
    }
})

-- #########################################################################
-- Custom alias and hotkeys
-- #########################################################################
-- show whitespaces, toggle using F5
vim.opt.listchars = 'eol:$,space:_,tab:>#,trail:~'
vim.keymap.set('n', '<F5>', ':set list! list?<CR>', {
    noremap = true,
    silent = false,
    desc = 'Toggle invisible characters'
})

-- insert ![Bild](/preview) at current line, used for embedding images in markdown
vim.api.nvim_create_user_command('MDNexImage', 'normal i![Bild](/preview)', {
    desc = 'Insert Markdown image template'
})

-- Show linting messags on hover, "requires vim.o.updatetime = ..."
vim.api.nvim_create_autocmd("CursorHold", {
    group = vim.api.nvim_create_augroup("diagnostics-hover", {
        clear = true
    }),
    callback = function()
        vim.diagnostic.open_float(nil, {
            focusable = false,
            scope = "cursor"
        })
    end
})

-- Lint file using Lint command
vim.api.nvim_create_user_command('Lint', function()
    require("lint").try_lint()
end, {
    desc = "Run linters"
})

-- Show diagnostics using <leader>k or ShowError command
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, {
    desc = "Show line diagnostics"
})

-- Show diagnostic error at cursor
vim.api.nvim_create_user_command('ShowError', function()
    vim.diagnostic.open_float(nil, {
        scope = "cursor"
    })
end, {
    desc = "Show diagnostic error at cursor"
})

-- Format file using <leader>f to format visual selection or whole file
vim.keymap.set({"n", "v"}, "<leader>fo", function()
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    local range = nil

    if start_line > 0 and end_line > 0 then
        local end_line_content = vim.api.nvim_buf_get_lines(0, end_line - 1, end_line, true)[1]
        range = {
            start = {start_line, 0},
            ["end"] = {end_line, end_line_content:len()}
        }
    end

    require("conform").format({
        async = true,
        lsp_format = "fallback",
        range = range
    })
end, {
    desc = "Format code (or visual selection)"
})

-- Add 'Format' command to format visual selection or whole file
vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = {args.line1, 0},
            ["end"] = {args.line2, end_line:len()}
        }
    end
    require("conform").format({
        async = true,
        lsp_format = "fallback",
        range = range
    })
end, {
    range = true
})

-- recommended mappings
-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
-- moving between splits
vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous)
-- swapping buffers between windows
vim.keymap.set('n', '<leader><leader>h', require('smart-splits').swap_buf_left)
vim.keymap.set('n', '<leader><leader>j', require('smart-splits').swap_buf_down)
vim.keymap.set('n', '<leader><leader>k', require('smart-splits').swap_buf_up)
vim.keymap.set('n', '<leader><leader>l', require('smart-splits').swap_buf_right)

-- #########################################################################
-- Compatibility
-- #########################################################################
-- Use the following to use old vim settings
vim.cmd([[ ]])

-- #########################################################################
-- Corlorscheme
-- #########################################################################
-- Set the colorscheme, keep this at the very bottom
vim.cmd [[colorscheme moonfly]]
