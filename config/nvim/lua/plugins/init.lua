-- If ensure_installed fails for a plugin, please install manually via mason

return {
  "nvim-lua/plenary.nvim",

  {
    "nvchad/base46",
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "nvchad/ui",
    lazy = false,
    config = function()
      require "nvchad"
    end,
  },

  "nvzone/volt",
  "nvzone/menu",
  { "nvzone/minty", cmd = { "Huefy", "Shades" } },

  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      dofile(vim.g.base46_cache .. "devicons")
      return { override = require "nvchad.icons.devicons" }
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User FilePost",
    opts = {
      indent = { char = "│", highlight = "IblChar" },
      scope = { char = "│", highlight = "IblScopeChar" },
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "blankline")

      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require("ibl").setup(opts)

      dofile(vim.g.base46_cache .. "blankline")
    end,
  },

  -- file managing , picker etc
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "configs.nvimtree"
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
    event = "User FilePost",
    opts = function()
      return require "configs.gitsigns"
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
      return require "configs.mason"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
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
      local lint = require "lint"

      require("lint.linters.checkstyle").config_file =
        vim.fn.expand "~/dotfiles/config/nvim/linters/checkstyle/checkstyle.xml"

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
      require("mason-nvim-lint").setup {
        ensure_installed = { "eslint_d", "ruff", "checkstyle", "cpplint" },
      }
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
      local dap, dapui = require "dap", require "dapui"

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
      require("mason-nvim-dap").setup {
        ensure_installed = { "bash" }, -- now works
        automatic_installation = true,
        handlers = {}, -- auto-configures adapters
      }
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
          require "configs.luasnip"
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
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
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
      return require "configs.cmp"
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    opts = function()
      return require "configs.telescope"
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
      -- NVChad base46 theming
      pcall(function()
        dofile(vim.g.base46_cache .. "syntax")
        dofile(vim.g.base46_cache .. "treesitter")
      end)

      -- Just use nvim-treesitter defaults
      require("nvim-treesitter").setup {}

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

      require("nvim-treesitter-textobjects").setup {
        select = { lookahead = true },
        move = { set_jumps = true },
      }

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
      local move = require "nvim-treesitter-textobjects.move"
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
      local swap = require "nvim-treesitter-textobjects.swap"
      vim.keymap.set("n", "<leader>sn", function()
        swap.swap_next "@parameter.inner"
      end)
      vim.keymap.set("n", "<leader>sp", function()
        swap.swap_previous "@parameter.inner"
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
    event = "User FilePost",
    opts = function()
      return require "configs.comment"
    end,
  },

  -- alpha dashboard
  {
    "goolord/alpha-nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require "configs.alpha"
    end,
  },

  -- sessions
  {
    "olimorris/persisted.nvim",
    -- lazy = false,
    event = "VeryLazy",
    opts = function()
      return require "configs.persisted"
    end,
    keys = {
      { "<leader>sl", "<cmd>Telescope persisted<CR>", desc = "List sessions" },
      { "<leader>ss", "<cmd>SessionSave<CR>", desc = "Save session" },
      { "<leader>sd", "<cmd>SessionDelete<CR>", desc = "Delete session" },
      { "<leader>sr", "<cmd>SessionLoad<CR>", desc = "Load session for cwd" },
    },
    config = function(_, opts)
      require("persisted").setup(opts)
      require("telescope").load_extension "persisted"
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
      local harpoon = require "harpoon"
      harpoon:setup(require "configs.harpoon")

      -- save cursor position on buffer leave
      vim.api.nvim_create_autocmd({ "BufLeave", "ExitPre" }, {
        pattern = "*",
        callback = function()
          local filename = vim.fn.expand "%:p:."
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
      require("oil").setup {
        default_file_explorer = true,
        columns = {
          "type",
          -- "icon",
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
      }

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

  -- code runner (anything else just use tmux)
  {
    "CRAG666/code_runner.nvim",
    cmd = { "RunCode", "RunFile", "RunProject" },
    keys = {
      { "<leader>rc", "<cmd>RunCode<cr>", desc = "Run Code" },
    },
    opts = {
      filetype = {
        python = "python3 -u",
        javascript = "node",
        typescript = "npx ts-node",
        java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
        c = "cd $dir && gcc $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
        cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
        rust = "cargo run",
        go = "go run .",
        lua = "lua",
        bash = "bash",
        sh = "sh",
      },
      project = {
        ["pom.xml"] = "mvn spring-boot:run",
        ["build.gradle"] = "gradle bootRun",
        ["package.json"] = "npm start",
        ["Cargo.toml"] = "cargo run",
        ["Makefile"] = "make run",
      },
      mode = "term",
      focus = true,
      startinsert = false,
    },
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
    opts = {
      keymaps = {
        normal = "gz",
        normal_cur = "gzz",
        normal_line = "gzl",
        normal_cur_line = "gzL",
        visual = "gz",
        delete = "gzd",
        change = "gzc",
      },
    },
  },

  -- config + color structure here:
  -- https://github.com/sphamba/smear-cursor.nvim/blob/main/lua/smear_cursor/
  {
    "sphamba/smear-cursor.nvim",
    lazy = false,
    config = function()
      local smear = require "smear_cursor"
      smear.setup(require "configs.smear-cursor")

      -- autocmds to suppress animation during formatting because of how formatting buffers movesS
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
    end,
  },
}
