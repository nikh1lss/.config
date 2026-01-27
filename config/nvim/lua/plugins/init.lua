-- If ensure_installed fails for a plugin, please install manually via mason

return {
  "nvim-lua/plenary.nvim",

  -- These are some examples, uncomment them if you want to see them work!

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },

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

  {
    "folke/which-key.nvim",
    cmd = "WhichKey",
    lazy = false,
    opts = function()
      dofile(vim.g.base46_cache .. "whichkey")
      return {
        delay = 99999,
        triggers = {
          { "<leader>", mode = { "n", "v" } },
          { "<c-w>", mode = "n" },
          { '"', mode = "n" },
          { "'", mode = "n" },
          { "`", mode = "n" },
          { "g", mode = { "n", "v" } },
          { "c", mode = "n" },
        },
      }
    end,
  },

  -- formatting, need to manually download formatters, mason will not
  -- i.e. :MasonInstall stylua prettierd google-java-format clang-format
  -- or with :Mason
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
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
    lazy = false,
    opts = {
      ensure_installed = { "lua_ls", "pyright", "ts_ls", "jdtls", "clangd", "rust_analyzer" },
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
    lazy = false, -- annoying
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
    lazy = false,
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

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require "configs.treesitter"
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
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
    lazy = false,
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
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
      return require "configs.harpoon"
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
        "<leader>h",
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
}
