-- If ensure_installed fails for a plugin, please install manually via mason

return {
  "nvim-lua/plenary.nvim",

  -- colourscheme
  {
    "rose-pine/neovim",
    enabled = false,
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "auto",
        dark_variant = "main",
        dim_inactive_windows = false,
        extend_background_behind_borders = true,
        styles = {
          bold = true,
          italic = false,
          transparency = true,
        },
        highlight_groups = {
          Comment = { italic = true },
          ["@comment"] = { italic = true },
          CmpBorder = { fg = "muted", bg = "none" },
          CmpPmenu = { bg = "none" },
        },
      })
      vim.cmd("colorscheme rose-pine")
    end,
  },

  {
    "ellisonleao/gruvbox.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    opts = {
      transparent_mode = true,
      overrides = {
        CursorLineNr = { fg = "#fabd2f", bg = "", bold = true },
        LineNr = { bg = "" },
      },
    },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      vim.cmd.colorscheme("gruvbox")
    end,
  },
  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = {
          "encoding",
          { "fileformat", symbols = { unix = "UNIX", dos = "DOS", mac = "MAC" } },
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- LSP signature
  {
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
    opts = {
      bind = true,
      hint_enable = false,
      floating_window = false,
      handler_opts = {
        border = "rounded",
      },
      max_width = 80,
    },
    config = function(_, opts)
      require("lsp_signature").setup(opts)
      vim.keymap.set({ "n" }, "<leader>ls", function()
        require("lsp_signature").toggle_float_win()
      end, { desc = "Toggle signature help" })
    end,
  },

  -- colorizer
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {},
  },

  -- LSP progress indicator
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    enabled = true,
    opts = {
      notification = {
        window = {
          winblend = 0, -- works with transparency
        },
      },
    },
  },

  {
    "nvim-tree/nvim-web-devicons",
    opts = {},
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│", highlight = "IblIndent" },
      scope = {
        char = "│",
        highlight = "IblScope",
        show_start = false,
        show_end = false,
      },
    },
    config = function(_, opts)
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require("ibl").setup(opts)
    end,
  },

  -- file managing , picker etc
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require("configs.nvimtree")
    end,
  },

  -- formatting, need to manually download formatters, mason will not
  -- i.e. :MasonInstall stylua prettierd google-java-format clang-format
  -- or with :Mason
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        java = { "google-java-format" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        rust = { "rustfmt" },
      },
      formatters = {
        stylua = {
          prepend_args = {
            "--column-width",
            "120",
            "--line-endings",
            "Unix",
            "--indent-type",
            "Spaces",
            "--indent-width",
            "2",
            "--quote-style",
            "AutoPreferDouble",
            "--call-parentheses",
            "Always",
          },
        },
        ["google-java-format"] = {
          prepend_args = { "--aosp" },
        },
        ["clang-format"] = {
          prepend_args = { "--style={IndentWidth: 4}" },
        },
      },
    },
  },

  -- git stuff
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
      return require("configs.gitsigns")
    end,
  },

  -- lsp stuff
  -- nvim-jdtls configures everything
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },

  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    opts = function()
      return require("configs.mason")
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("configs.lspconfig").defaults()
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    -- lazy = false,
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "ts_ls",
        "jdtls",
        "clangd",
        "rust_analyzer",
      },
      automatic_installation = true,
      automatic_enable = {
        exclude = {
          -- needs external plugin
          "jdtls",
        },
      },
      -- Remove old lsp handlers, use vim.lsp.enable to handle setup
    },

    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
    },
  },

  -- linter
  -- rustfmt and clippy need to be installed with rustup, not mason
  -- rustup component add rustfmt clippy
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      require("lint.linters.checkstyle").config_file = vim.fn.stdpath("config") .. "/linters/checkstyle/checkstyle.xml"

      lint.linters_by_ft = {
        -- add linters here
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        python = { "ruff" },
        java = { "checkstyle" },
        c = { "cpplint" },
        cpp = { "cpplint" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      -- keymapping to toggle linter
      vim.keymap.set("n", "<leader>ll", function()
        lint.try_lint()
      end, { desc = "Trigger linting for current file" })
    end,
  },

  -- automatically install via mason
  {
    "rshkarin/mason-nvim-lint",
    dependencies = { "mason.nvim", "nvim-lint" },
    -- lazy = false, -- annoying
    event = "VeryLazy",
    config = function()
      require("mason-nvim-lint").setup({
        ensure_installed = { "eslint_d", "ruff", "checkstyle", "cpplint" },
      })
    end,
  },

  -- debuggers
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      dapui.setup()

      -- Auto open/close dap-ui
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Keymaps
      vim.keymap.set("n", "<F5>", dap.continue)
      vim.keymap.set("n", "<F10>", dap.step_over)
      vim.keymap.set("n", "<F11>", dap.step_into)
      vim.keymap.set("n", "<F12>", dap.step_out)
      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
    end,
  },

  -- need to manually install debuggers through :Mason, ensure_installed not working?
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- lazy = false,
    event = "VeryLazy",
    dependencies = { "mason.nvim", "nvim-dap" },
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = { "bash" }, -- now works
        automatic_installation = true,
        handlers = {}, -- auto-configures adapters
      })
    end,
  },

  -- load luasnips + cmp related in insert mode only
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require("configs.luasnip")
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require("nvim-autopairs.completion.cmp")
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "https://codeberg.org/FelipeLema/cmp-async-path.git",
      },
    },
    config = function()
      return require("configs.cmp")
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    opts = function()
      return require("configs.telescope")
    end,
  },

  -- nvim-treesitter (main branch)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main", -- now main branch :)
      },
    },
    config = function()
      -- Just use nvim-treesitter defaults
      require("nvim-treesitter").setup({})

      -- Install parsers (no-op if already installed)
      local parsers = {
        "lua",
        "luadoc",
        "printf",
        "vim",
        "vimdoc",
        "python",
        "javascript",
        "typescript",
        "tsx",
        "java",
        "c",
        "cpp",
        "rust",
        "c_sharp",
        "json",
        "javadoc",
      }
      require("nvim-treesitter").install(parsers)

      -- Enable highlighting + indentation for installed parsers
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          -- try to start treesitter highlighting
          pcall(vim.treesitter.start, args.buf)

          -- enable treesitter-based indentation
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

          -- enable treesitter-based folding
          vim.wo[0][0].foldmethod = "expr"
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo[0][0].foldenable = false -- don't fold on open
        end,
      })

      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      -- Select keymaps
      local select = require("nvim-treesitter-textobjects.select").select_textobject
      vim.keymap.set({ "x", "o" }, "af", function()
        select("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "if", function()
        select("@function.inner", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ac", function()
        select("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ic", function()
        select("@class.inner", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "aa", function()
        select("@parameter.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ia", function()
        select("@parameter.inner", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "al", function()
        select("@loop.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "il", function()
        select("@loop.inner", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ai", function()
        select("@conditional.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ii", function()
        select("@conditional.inner", "textobjects")
      end)

      -- Move keymaps
      local move = require("nvim-treesitter-textobjects.move")
      vim.keymap.set({ "n", "x", "o" }, "]f", function()
        move.goto_next_start("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]c", function()
        move.goto_next_start("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]a", function()
        move.goto_next_start("@parameter.inner", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[f", function()
        move.goto_previous_start("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[c", function()
        move.goto_previous_start("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[a", function()
        move.goto_previous_start("@parameter.inner", "textobjects")
      end)

      -- Swap keymaps
      local swap = require("nvim-treesitter-textobjects.swap")
      vim.keymap.set("n", "<leader>sn", function()
        swap.swap_next("@parameter.inner")
      end)
      vim.keymap.set("n", "<leader>sp", function()
        swap.swap_previous("@parameter.inner")
      end)

      -- disable legacy vim motions (accidentally using)
      vim.keymap.set({ "n", "x", "o" }, "]]", "<Nop>")
      vim.keymap.set({ "n", "x", "o" }, "[[", "<Nop>")
      vim.keymap.set({ "n", "x", "o" }, "][", "<Nop>")
      vim.keymap.set({ "n", "x", "o" }, "[]", "<Nop>")
    end,
  },

  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
      return require("configs.comment")
    end,
  },

  -- alpha dashboard
  {
    "goolord/alpha-nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("configs.alpha")
    end,
  },

  -- sessions
  {
    "olimorris/persisted.nvim",
    -- lazy = false,
    event = "VeryLazy",
    opts = function()
      return require("configs.persisted")
    end,
    keys = {
      { "<leader>sl", "<cmd>Telescope persisted<CR>", desc = "List sessions" },
      { "<leader>ss", "<cmd>SessionSave<CR>", desc = "Save session" },
      { "<leader>sd", "<cmd>SessionDelete<CR>", desc = "Delete session" },
      { "<leader>sr", "<cmd>SessionLoad<CR>", desc = "Load session for cwd" },
    },
    config = function(_, opts)
      require("persisted").setup(opts)
      require("telescope").load_extension("persisted")
    end,
  },

  -- harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "mike-jl/harpoonEx", opts = { reload_on_dir_change = true } },
    },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup(require("configs.harpoon"))

      -- save cursor position on buffer leave
      vim.api.nvim_create_autocmd({ "BufLeave", "ExitPre" }, {
        pattern = "*",
        callback = function()
          local filename = vim.fn.expand("%:p:.")
          local list = harpoon:list()

          for _, item in ipairs(list.items) do
            if item.value == filename then
              local cursor = vim.api.nvim_win_get_cursor(0)
              item.context.row = cursor[1]
              item.context.col = cursor[2]
              break
            end
          end
        end,
      })
    end,
    keys = {
      {
        "<leader>a",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon add file",
      },
      {
        "<leader>;",
        function()
          require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
        end,
        desc = "Harpoon menu",
      },
      {
        "<A-1>",
        function()
          require("harpoon"):list():select(1)
        end,
        desc = "Harpoon file 1",
      },
      {
        "<A-2>",
        function()
          require("harpoon"):list():select(2)
        end,
        desc = "Harpoon file 2",
      },
      {
        "<A-3>",
        function()
          require("harpoon"):list():select(3)
        end,
        desc = "Harpoon file 3",
      },
      {
        "<A-4>",
        function()
          require("harpoon"):list():select(4)
        end,
        desc = "Harpoon file 4",
      },
      {
        "<A-5>",
        function()
          require("harpoon"):list():select(5)
        end,
        desc = "Harpoon file 5",
      },
      {
        "<S-A-p>",
        function()
          require("harpoon"):list():prev()
        end,
        desc = "Harpoon prev",
      },
      {
        "<S-A-n>",
        function()
          require("harpoon"):list():next()
        end,
        desc = "Harpoon next",
      },
    },
  },

  -- configure spring-boot LS
  {
    "JavaHello/spring-boot.nvim",
    ft = { "java", "yaml", "jproperties" },
    dependencies = {
      "mfussenegger/nvim-jdtls",
    },
    opts = {},
  },

  -- oil
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    lazy = false,
    keys = {
      { "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
      { "<leader>o", "<cmd>Oil --float<CR>", desc = "Open Oil (float)" },
    },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        columns = {
          "type",
          "icon",
          "permissions",
          "size",
          "mtime",
        },
        view_options = {
          show_hidden = true,
        },
        float = {
          padding = 2,
          max_width = 90,
          max_height = 30,
        },
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-v>"] = "actions.select_vsplit",
          ["<C-x>"] = "actions.select_split",
          ["<C-t>"] = "actions.select_tab",
          ["<C-p>"] = "actions.preview",
          ["q"] = "actions.close",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
          ["g\\"] = "actions.toggle_trash",
        },
      })

      -- Patch recursive_delete to use rm -rf for directories.
      -- this is a workaround for an open issue https://github.com/stevearc/oil.nvim/issues/719
      -- Avoids a libuv double-free on certain directories that crashes nvim via oil.
      -- this bypasses Oil's trash integration for directories, so g\ toggle_trash
      -- will only apply to file deletes — directories always get permanently removed.
      local oil_fs = require("oil.fs")
      local original_recursive_delete = oil_fs.recursive_delete

      oil_fs.recursive_delete = function(entry_type, path, cb)
        if entry_type == "directory" then
          vim.fn.jobstart({ "rm", "-rf", path }, {
            on_exit = function(_, code)
              if code == 0 then
                cb(nil)
              else
                cb("rm -rf failed on " .. path)
              end
            end,
          })
        else
          original_recursive_delete(entry_type, path, cb)
        end
      end

      -- On :w, oil runs try_write_changes() which parses diffs, builds actions,
      -- shows a confirmation dialog, then calls process_actions(). process_actions
      -- arms a progress popup after 100ms — if the action (e.g. delete) takes longer than that
      -- (e.g. large directories like node_modules), the loading popup will briefly show.

      -- the dumbest autocmd i've ever made
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "oil",
        callback = function()
          vim.keymap.set("v", "0", "V", { buffer = true })
          vim.keymap.set("v", "$", "V", { buffer = true })
        end,
      })
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- compile-mode (emacs-cope)
  {
    "ej-shafran/compile-mode.nvim",
    version = "^5.0.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = { "Compile", "Recompile", "NextError", "PrevError" },
    keys = {
      { "<leader>rc", "<cmd>Compile<cr>", desc = "Compile" },
      { "<leader>rr", "<cmd>Recompile<cr>", desc = "Recompile" },
      { "<leader>rn", "<cmd>NextError<cr>", desc = "Next error" },
      { "<leader>rp", "<cmd>PrevError<cr>", desc = "Prev error" },
    },
    config = function()
      vim.g.compile_mode = {
        default_command = "",
        bang_expansion = true,
        input_word_completion = true,
      }
    end,
  },

  -- tabout
  {
    "abecodes/tabout.nvim",
    event = "InsertEnter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",
    },
    opts = {
      tabkey = "", -- disabled, handled by cmp
      backwards_tabkey = "", -- disabled, handled by cmp
      act_as_tab = true,
      act_as_shift_tab = false,
      enable_backwards = true,
      completion = false, -- handled by cmp
      tabouts = {
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = "`", close = "`" },
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
        { open = "<", close = ">" },
      },
      ignore_beginning = true,
      exclude = {},
    },
  },

  -- flash.nvim
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        char = {
          jump_labels = true,
        },
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },

  -- surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    init = function()
      vim.g.nvim_surround_no_normal_mappings = true
      vim.g.nvim_surround_no_visual_mappings = true
    end,
    config = function()
      require("nvim-surround").setup()

      vim.keymap.set("n", "gz", "<Plug>(nvim-surround-normal)")
      vim.keymap.set("n", "gzz", "<Plug>(nvim-surround-normal-cur)")
      vim.keymap.set("n", "gzl", "<Plug>(nvim-surround-normal-line)")
      vim.keymap.set("n", "gzL", "<Plug>(nvim-surround-normal-cur-line)")
      vim.keymap.set("x", "gz", "<Plug>(nvim-surround-visual)")
      vim.keymap.set("n", "gzd", "<Plug>(nvim-surround-delete)")
      vim.keymap.set("n", "gzc", "<Plug>(nvim-surround-change)")
    end,
  },

  -- config + color structure here:
  -- https://github.com/sphamba/smear-cursor.nvim/blob/main/lua/smear_cursor/
  {
    "sphamba/smear-cursor.nvim",
    lazy = false,
    enabled = false,
    config = function()
      local smear = require("smear_cursor")
      smear.setup(require("configs.smear-cursor"))

      -- autocmds to suppress animation during formatting because of how formatting buffers moves
      -- cursor to position (1,1) before restoring it
      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
          smear.enabled = false
        end,
      })

      -- defer to next event loop cycle so any queued cursor events from formatting finish first
      vim.api.nvim_create_autocmd("BufWritePost", {
        callback = function()
          vim.defer_fn(function()
            smear.enabled = true
          end, 0)
        end,
      })

      -- don't question
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          if vim.api.nvim_buf_get_name(0):match("^oil://") then
            smear.enabled = false
            vim.defer_fn(function()
              smear.enabled = true
            end, 10)
          end
        end,
      })
    end,
  },

  -- can move from nvim to other panels now
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    config = function()
      require("smart-splits").setup({})
      -- navigation (also terminal mode in case)
      vim.keymap.set({ "n", "t" }, "<C-h>", require("smart-splits").move_cursor_left, { desc = "Navigate left" })
      vim.keymap.set({ "n", "t" }, "<C-j>", require("smart-splits").move_cursor_down, { desc = "Navigate down" })
      vim.keymap.set({ "n", "t" }, "<C-k>", require("smart-splits").move_cursor_up, { desc = "Navigate up" })
      vim.keymap.set({ "n", "t" }, "<C-l>", require("smart-splits").move_cursor_right, { desc = "Navigate right" })

      -- resizing
      vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left, { desc = "Resize left" })
      vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down, { desc = "Resize down" })
      vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up, { desc = "Resize up" })
      vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right, { desc = "Resize right" })
    end,
  },

  -- obsidian
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("obsidian").setup({
        workspaces = {
          {
            name = "Eternal-Garden",
            path = "/mnt/c/Users/nsing/Vaults/Eternal Garden",
          },
        },
        completion = {
          nvim_cmp = true,
          min_chars = 2,
        },
        new_notes_location = "current_dir",
        note_id_func = function(title)
          if title ~= nil then
            return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          end
          return tostring(os.time())
        end,
        mappings = {
          ["gf"] = {
            action = function()
              return require("obsidian").util.gf_passthrough()
            end,
            opts = { noremap = false, expr = true, buffer = true },
          },
          ["<leader>ch"] = {
            action = function()
              return require("obsidian").util.toggle_checkbox()
            end,
            opts = { buffer = true },
          },
        },
        ui = {
          enable = true,
          checkboxes = {
            [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
            ["x"] = { char = "", hl_group = "ObsidianDone" },
          },
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.opt_local.conceallevel = 2
        end,
      })
    end,
    keys = {
      { "<leader>on", "<cmd>ObsidianNew<CR>", desc = "New note" },
      { "<leader>oo", "<cmd>ObsidianSearch<CR>", desc = "Search notes" },
      { "<leader>oq", "<cmd>ObsidianQuickSwitch<CR>", desc = "Quick switch" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<CR>", desc = "Backlinks" },
      { "<leader>ot", "<cmd>ObsidianTags<CR>", desc = "Tags" },
      { "<leader>od", "<cmd>ObsidianToday<CR>", desc = "Today's daily note" },
      { "<leader>ol", "<cmd>ObsidianLinks<CR>", desc = "Links in note" },
      { "<leader>op", "<cmd>ObsidianPasteImg<CR>", desc = "Paste image" },
      { "<leader>or", "<cmd>ObsidianRename<CR>", desc = "Rename note" },
    },
  },

  -- git interface (magit-like)
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      { "<leader>gg", "<cmd>Neogit<CR>", desc = "Neogit status" },
      { "<leader>gc", "<cmd>Neogit commit<CR>", desc = "Neogit commit" },
      { "<leader>gp", "<cmd>Neogit push<CR>", desc = "Neogit push" },
      { "<leader>gl", "<cmd>Neogit pull<CR>", desc = "Neogit pull" },
      { "<leader>gb", "<cmd>Neogit branch<CR>", desc = "Neogit branch" },
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diffview open" },
      { "<leader>gD", "<cmd>DiffviewClose<CR>", desc = "Diffview close" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
    },
    opts = {
      integrations = {
        telescope = true,
        diffview = true,
      },
      signs = {
        hunk = { "", "" },
        item = { "", "" },
        section = { "", "" },
      },
      graph_style = "unicode",
    },
  },
}
