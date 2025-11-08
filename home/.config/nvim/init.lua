-- ################################################################################################## 
-- Neovim Text Editor
-- ################################################################################################## 
-- #########################################################################
-- Settings
-- #########################################################################
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
-- Custom Statusline
-- #########################################################################
local parts = {'--', ' %r', -- readonly
' %m', -- modified
' %F', -- full path
' --', '%=', -- separator
'%*', -- reset highlighting
'%=', -- separator
' --', ' Pos:%c', -- column
' Line:%l/%L', -- line/total lines
' --', ' [Enc:%{&fenc}]', -- encoding
' [Frmt:%{&ff}]', -- file format
' --'}
vim.opt.statusline = table.concat(parts, '')

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

vim.api.nvim_set_hl(0, 'SpellBad', {})
vim.api.nvim_set_hl(0, 'SpellCap', {})
vim.api.nvim_set_hl(0, 'SpellRare', {})
vim.api.nvim_set_hl(0, 'SpellLocal', {})

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
    spec = { -- https://github.com/nvim-lualine/lualine.nvim
    {
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
    }, -- https://github.com/saghen/blink.cmp
    {
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
                default = {'lsp', 'path', 'snippets', 'buffer'}
            },

            fuzzy = {
                implementation = "prefer_rust_with_warning"
            }
        },
        opts_extend = {"sources.default"}
    }, -- https://github.com/L3MON4D3/LuaSnip
    {
        "L3MON4D3/LuaSnip",
        dependencies = {"rafamadriz/friendly-snippets"},
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end
    }, -- https://github.com/neovim/nvim-lspconfig 
    {
        "neovim/nvim-lspconfig",
        dependencies = {"saghen/blink.cmp"},
        config = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            -- List of servers to enable
            local servers_to_enable = {"lua_ls", "pyright", "tsserver", "clangd", "shellcheck", "bash-language-server"}
            for _, server_name in ipairs(servers_to_enable) do
                vim.lsp.config(server_name, {
                    capabilities = capabilities
                })
                vim.lsp.enable(server_name)
            end
        end
    }, -- https://github.com/bluz71/vim-moonfly-colors 
    {
        "bluz71/vim-moonfly-colors",
        name = "moonfly",
        lazy = false,
        priority = 1000
    }, -- https://github.com/windwp/nvim-autopairs
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    }, -- https://github.com/nvim-treesitter/nvim-treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                -- :TSInstallInfo lists all available parsers
                -- Add more languages at the bottom
                ensure_installed = {"lua", "vim", "vimdoc", "python", "javascript", "typescript", "c", "cpp", "rust",
                                    "go", "bash", "markdown", "json", "yaml"},

                sync_install = false,
                -- Automatically install missing parsers
                auto_install = true,
                highlight = {
                    enable = true
                },
                indent = {
                    enable = true
                }
            })
        end
    }, -- https://github.com/mfussenegger/nvim-lint
    {
        "mfussenegger/nvim-lint",
        event = "VeryLazy",
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                python = {"flake8"},
                javascript = {"eslint_d"},
                typescript = {"eslint_d"},
                javascriptreact = {"eslint_d"},
                typescriptreact = {"eslint_d"},
                bash = {"shellcheck"},
                sh = {"shellcheck"},
                markdown = {"markdownlint"}
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
    }, -- https://github.com/stevearc/conform.nvim
    {
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
                lua = {"stylua"},
                python = {"black"},
                bash = {"shfmt"},
                sh = {"shfmt"}
                -- Add more filetypes and formatters here
            }
            -- format_on_save = {
            --  timeout_ms = 500,
            --  lsp_fallback = true,
            -- },

        }
    }, -- https://github.com/nvim-telescope/telescope.nvim
    {
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
    } -- ADD PLUGINS HERE
    },
    install = {
        colorscheme = {"moonfly"}
    },
    -- automatically check for plugin updates
    checker = {
        enabled = true
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
    lint.try_lint()
end, {
    desc = "Run linters"
})

-- Show diagnostics using <leader>k or ShowError command
vim.keymap.set('n', 'K', vim.diagnostic.open_float, {
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
