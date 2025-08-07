vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.termguicolors = true

vim.o.number = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.relativenumber = true
vim.o.cmdheight = 1
vim.o.laststatus = 3

vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 30
vim.o.confirm = true

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('CursorMoved', {
  desc = 'Clear command line messages when cursor moves',
  group = vim.api.nvim_create_augroup('clear-messages', { clear = true }),
  callback = function()
    if vim.fn.mode() == 'n' then
      vim.defer_fn(function()
        vim.cmd 'echon ""'
      end, 500)
    end
  end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup({
  'NMAC427/guess-indent.nvim',

  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  {
    'HiPhish/rainbow-delimiters.nvim',
    config = function()
      local rainbow_delimiters = require 'rainbow-delimiters'

      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        priority = {
          [''] = 110,
          lua = 210,
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      }
    end,
  },

  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'hrsh7th/nvim-cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = 'rounded',
        winhighlight = 'Normal:LspHover,FloatBorder:LspHoverBorder,CursorLine:LspHoverSel',
        max_width = 120,
        max_height = 30,
        focusable = true,
        close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
        wrap = true,
        silent = true,
      })

      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = 'rounded',
        winhighlight = 'Normal:LspSignatureHelp,FloatBorder:LspSignatureHelpBorder',
        max_width = 80,
        max_height = 15,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        clangd = {
          settings = {
            clangd = {
              arguments = {
                '--background-index',
                '--clang-tidy',
                '--header-insertion=iwyu',
                '--completion-style=detailed',
                '--function-arg-placeholders',
                '--fallback-style=llvm',
              },
              filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
            },
          },
        },
        jdtls = {
          settings = {
            java = {
              configuration = {
                updateBuildConfiguration = 'interactive',
              },
              completion = {
                favoriteStaticMembers = {
                  'org.hamcrest.MatcherAssert.assertThat',
                  'org.hamcrest.Matchers.*',
                  'org.hamcrest.CoreMatchers.*',
                  'org.junit.jupiter.api.Assertions.*',
                  'java.util.Objects.requireNonNull',
                  'java.util.Objects.requireNonNullElse',
                },
                importOrder = {
                  'java',
                  'javax',
                  'com',
                  'org',
                },
              },
              sources = {
                organizeImports = {
                  starThreshold = 9999,
                  staticStarThreshold = 9999,
                },
              },
              codeGeneration = {
                toString = {
                  template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
                },
                useBlocks = true,
              },
            },
          },
        },
        jedi_language_server = {
          settings = {
            jediLanguageServer = {
              completion = {
                disableSnippets = false,
                resolveEagerly = false,
              },
              diagnostics = {
                enable = true,
                didOpen = true,
                didChange = true,
                didSave = true,
              },
              hover = {
                enable = true,
                disable = {
                  keyword = false,
                },
              },
              workspace = {
                extraPaths = {},
              },
            },
          },
        },
        bashls = {
          settings = {
            bashIde = {
              globPattern = '**/*@(.sh|.inc|.bash|.command)',
              shellcheckPath = '',
              includeAllWorkspaceSymbols = false,
            },
          },
        },
        ast_grep = {},
        html = {
          settings = {
            html = {
              format = {
                templating = true,
                wrapLineLength = 120,
                wrapAttributes = 'auto',
              },
              hover = {
                documentation = true,
                references = true,
              },
            },
          },
        },

        texlab = {
          settings = {
            texlab = {
              build = {
                executable = 'latexmk',
                args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
                onSave = true,
                forwardSearchAfter = true,
              },
              forwardSearch = {
                executable = 'zathura',
                args = { '--synctex-forward', '%l:1:%f', '%p' },
              },
              lint = {
                onChange = true,
              },
              formatterLineLength = 120,
            },
          },
        },

        hyprls = {},
        gopls = {
          settings = {
            gopls = {
              completeUnimported = true,
              usePlaceholders = true,
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = 'workspace',
                useLibraryCodeForTypes = true,
                typeCheckingMode = 'basic',
              },
              linting = {
                enabled = true,
              },
            },
          },
        },

        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
              },
              diagnostics = {
                globals = { 'vim' },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
              completion = {
                callSnippet = 'Replace',
              },
              hint = {
                enable = true,
              },
            },
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
        'clang-format',
        'google-java-format',
        'black',
        'texlab',
        'beautysh',
        'prettierd',
        'flake8',
        'checkstyle',
        'cpplint',
        'eslint_d',
        'vale',
        'goimports',
        'golangci-lint',
        'ltex_plus',
        'tex-fmt',
        'bibtex-tidy',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'black' },
        bash = { 'beautysh' },
        java = { 'google-java-format' },
        c = { 'clang-format' },
        go = { 'goimports' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
      },
    },
  },

  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {},
        opts = {},
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'folke/lazydev.nvim',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        window = {
          completion = {
            border = 'rounded',
            winhighlight = 'Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel',
            scrollbar = false,
          },
          documentation = {
            border = 'rounded',
            winhighlight = 'Normal:CmpDoc',
          },
        },

        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, vim_item)
            local kind_icons = vim.g.have_nerd_font
                and {
                  Text = '󰉿',
                  Method = '󰆧',
                  Function = '󰊕',
                  Constructor = '',
                  Field = '󰜢',
                  Variable = '󰀫',
                  Class = '󰠱',
                  Interface = '',
                  Module = '',
                  Property = '󰜢',
                  Unit = '󰑭',
                  Value = '󰎠',
                  Enum = '',
                  Keyword = '󰌋',
                  Snippet = '',
                  Color = '󰏘',
                  File = '󰈙',
                  Reference = '󰈇',
                  Folder = '󰉋',
                  EnumMember = '',
                  Constant = '󰏿',
                  Struct = '󰙅',
                  Event = '',
                  Operator = '󰆕',
                  TypeParameter = '',
                }
              or {}

            local source_names = {
              nvim_lsp = '[LSP]',
              luasnip = '[Snippet]',
              path = '[Path]',
              lazydev = '[Lazy]',
            }

            vim_item.kind = (kind_icons[vim_item.kind] or '') .. ' ' .. vim_item.kind

            vim_item.menu = source_names[entry.source.name] or '[' .. entry.source.name .. ']'

            return vim_item
          end,
        },

        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          ['<C-y>'] = cmp.mapping.confirm { select = true },

          ['<C-Space>'] = cmp.mapping.complete {},

          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          {
            name = 'lazydev',
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  {
    'folke/tokyonight.nvim',
    priority = 1000,
  },

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha',
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          telescope = true,
          which_key = true,
        },
      }
      vim.cmd.colorscheme 'catppuccin'

      vim.api.nvim_set_hl(0, 'CmpPmenu', { bg = '#1e1e2e', fg = '#cdd6f4' })
      vim.api.nvim_set_hl(0, 'CmpSel', { bg = '#313244', fg = '#cdd6f4', bold = true })
      vim.api.nvim_set_hl(0, 'CmpDoc', { bg = '#181825', fg = '#cdd6f4' })

      vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { fg = '#b4befe' })
      vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { fg = '#b4befe' })
      vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { fg = '#f9e2af' })
      vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { fg = '#cba6f7' })
      vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { fg = '#89dceb' })
      vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { fg = '#a6e3a1' })

      vim.api.nvim_set_hl(0, 'LspHover', { bg = '#1e1e2e', fg = '#cdd6f4' })
      vim.api.nvim_set_hl(0, 'LspHoverBorder', { bg = '#1e1e2e', fg = '#89b4fa', bold = true })
      vim.api.nvim_set_hl(0, 'LspHoverSel', { bg = '#313244', fg = '#cdd6f4' })
      vim.api.nvim_set_hl(0, 'LspSignatureHelp', { bg = '#1e1e2e', fg = '#cdd6f4' })
      vim.api.nvim_set_hl(0, 'LspSignatureHelpBorder', { bg = '#1e1e2e', fg = '#a6e3a1', bold = true })
    end,
  },

  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = true },
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- Catppuccin Mocha color palette
      local colors = {
        rosewater = '#f5e0dc',
        flamingo = '#f2cdcd',
        pink = '#f5c2e7',
        mauve = '#cba6f7',
        red = '#f38ba8',
        maroon = '#eba0ac',
        peach = '#fab387',
        yellow = '#f9e2af',
        green = '#a6e3a1',
        teal = '#94e2d5',
        sky = '#89dceb',
        sapphire = '#74c7ec',
        blue = '#89b4fa',
        lavender = '#b4befe',
        text = '#cdd6f4',
        subtext1 = '#bac2de',
        subtext0 = '#a6adc8',
        overlay2 = '#9399b2',
        overlay1 = '#7f849c',
        overlay0 = '#6c7086',
        surface2 = '#585b70',
        surface1 = '#45475a',
        surface0 = '#313244',
        base = '#1e1e2e',
        mantle = '#181825',
        crust = '#11111b',
      }

      -- Custom theme with proper Catppuccin colors
      local catppuccin_theme = require 'lualine.themes.catppuccin'

      -- Enhance mode colors with proper Catppuccin Mocha palette
      catppuccin_theme.normal.a.bg = colors.blue
      catppuccin_theme.insert.a.bg = colors.green
      catppuccin_theme.visual.a.bg = colors.yellow
      catppuccin_theme.replace.a.bg = colors.red
      catppuccin_theme.command.a.bg = colors.mauve

      require('lualine').setup {
        options = {
          theme = catppuccin_theme,
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          globalstatus = true,
          refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
          },
        },
        sections = {
          lualine_a = {
            {
              'mode',
              fmt = function(str)
                local mode_map = {
                  ['NORMAL'] = '󰣪 NOR',
                  ['INSERT'] = ' INS',
                  ['VISUAL'] = '󰦪 VIS',
                  ['V-LINE'] = '󰦪 V-L',
                  ['V-BLOCK'] = '󰦪 V-B',
                  ['REPLACE'] = '󰦛 REP',
                  ['COMMAND'] = ' CMD',
                  ['TERMINAL'] = ' TER',
                }
                return mode_map[str] or str:sub(1, 3)
              end,
              separator = { right = '' },
            },
          },
          lualine_b = {
            {
              'branch',
              icon = '',
              color = { fg = colors.blue, gui = 'bold' },
              separator = { right = '' },
            },
            {
              'diff',
              symbols = { added = ' ', modified = ' ', removed = ' ' },
              diff_color = {
                added = { fg = colors.green },
                modified = { fg = colors.yellow },
                removed = { fg = colors.red },
              },
              separator = { right = '' },
            },
          },
          lualine_c = {
            {
              'filename',
              file_status = true,
              newfile_status = true,
              path = 1,
              symbols = {
                modified = ' ',
                readonly = ' ',
                unnamed = '󰡯 [No Name]',
                newfile = '󰎔 [New]',
              },
              color = function()
                if vim.bo.modified then
                  return { fg = colors.yellow, gui = 'bold,italic' }
                else
                  return { fg = colors.text }
                end
              end,
            },
            {
              function()
                local buffers = vim.fn.len(vim.fn.filter(range(1, vim.fn.bufnr '$'), 'buflisted(v:val)'))
                return '󰓩 ' .. buffers
              end,
              color = { fg = colors.sky },
              separator = { left = '' },
            },
          },
          lualine_x = {
            {
              'diagnostics',
              sources = { 'nvim_diagnostic' },
              symbols = { error = ' ', warn = ' ', info = ' ', hint = '󰌶 ' },
              diagnostics_color = {
                error = { fg = colors.red, gui = 'bold' },
                warn = { fg = colors.peach, gui = 'bold' },
                info = { fg = colors.sky, gui = 'bold' },
                hint = { fg = colors.teal, gui = 'bold' },
              },
              separator = { left = '' },
            },
            {
              function()
                local clients = vim.lsp.get_active_clients()
                if next(clients) == nil then
                  return '󰚌 No LSP'
                end
                local client_names = {}
                for _, client in pairs(clients) do
                  table.insert(client_names, client.name)
                end
                return '󰒋 ' .. table.concat(client_names, ', ')
              end,
              color = { fg = colors.green },
              separator = { left = '' },
            },
            {
              'encoding',
              fmt = function(str)
                return str == 'utf-8' and '󰉿 UTF-8' or '󰉿 ' .. str:upper()
              end,
              color = { fg = colors.mauve },
              separator = { left = '' },
            },
            {
              'fileformat',
              symbols = {
                unix = '󰌽 LF',
                dos = '󰍲 CRLF',
                mac = '󰍵 CR',
              },
              color = { fg = colors.pink },
              separator = { left = '' },
            },
            {
              'filetype',
              colored = true,
              icon = { align = 'right' },
              color = { fg = colors.peach, gui = 'bold' },
              separator = { left = '' },
            },
          },
          lualine_y = {
            {
              function()
                local line = vim.fn.line '.'
                local total = vim.fn.line '$'
                local percent = math.floor((line / total) * 100)
                return string.format('󰉶 %d%%%% %d/%d', percent, line, total)
              end,
              color = { fg = colors.blue, gui = 'bold' },
              separator = { left = '' },
            },
          },
          lualine_z = {
            {
              function()
                local line = vim.fn.line '.'
                local col = vim.fn.col '.'
                return string.format('󰕇 %d:%d', line, col)
              end,
              color = { fg = colors.base, bg = colors.blue, gui = 'bold' },
              separator = { left = '' },
            },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            {
              'filename',
              color = { fg = colors.overlay0 },
            },
          },
          lualine_x = {
            {
              'location',
              color = { fg = colors.overlay0 },
            },
          },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { 'lazy', 'mason', 'trouble', 'quickfix' },
      }
    end,
  },

  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
    end,
  },

  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      dashboard = {
        enabled = true,
        width = 60,
        row = nil, -- dashboard position. nil for center
        col = nil, -- dashboard position. nil for center
        pane_gap = 4, -- empty columns between vertical panes
        autokeys = '1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', -- autokey sequence
        -- These settings are used by some built-in sections
        preset = {
          -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
          pick = nil,
          -- Used by the `keys` section to show keymaps.
          -- Set your custom keymaps here.
          -- When using a function, the `items` are the default keymaps.
          keys = {
            { icon = '', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
            { icon = '', key = 'n', desc = 'New File', action = ':ene | startinsert' },
            { icon = '', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = '', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = '', key = 's', desc = 'Restore Session', section = 'session' },
            { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy' },
            { icon = '', key = 'q', desc = 'Quit', action = ':qa' },
          },
          -- Used by the `header` section
          header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        },
        sections = {
          { section = 'header' },
          { section = 'keys', gap = 1, padding = 1 },
        },
      },
      explorer = {
        enabled = true,
        width = 30,
        height = 0.8,
        position = 'float',
        style = 'minimal',
        border = 'rounded',
        title = 'Explorer',
        title_pos = 'center',
        zindex = 40,
        -- File operations
        actions = {
          files = {
            ['<cr>'] = 'open',
            ['l'] = 'open',
            ['h'] = 'close',
            ['<tab>'] = 'preview',
            ['P'] = 'parent',
            ['K'] = 'parent',
            ['gx'] = 'system_open',
            ['g.'] = 'toggle_hidden',
            ['>'] = 'resize +5',
            ['<'] = 'resize -5',
            ['q'] = 'close',
            ['?'] = 'help',
          },
          dirs = {
            ['<cr>'] = 'open',
            ['l'] = 'open',
            ['h'] = 'close',
            ['<tab>'] = 'preview',
          },
        },
        -- Appearance
        icons = {
          enabled = true,
          git = true,
          folder_closed = '󰉋',
          folder_open = '󰝰',
          folder_empty = '󰉖',
          default_file = '󰈙',
        },
        -- Git integration
        git = {
          enabled = true,
          show_ignored = false,
        },
        -- File filtering
        filter = {
          hidden = true,
          git_ignored = true,
        },
      },
    },
    keys = {
      {
        '<leader>e',
        function()
          require('snacks').explorer.open()
        end,
        desc = 'Open Explorer',
      },
      {
        '-',
        function()
          require('snacks').explorer.toggle()
        end,
        desc = 'Toggle Explorer',
      },
    },
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'bibtex' },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },

  require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.autopairs',

  { import = 'custom.plugins' },
  { import = 'custom.configs' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
