return {
  recommended = {
    ft = "php",
    root = { "composer.json", ".phpactor.json", ".phpactor.yml", "artisan" },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    opts = { ensure_installed = { "php" } },
    dependencies = {
      {
        "folke/ts-comments.nvim",
        opts = {
          blade = "{{-- %s --}}",
        },
        event = "VeryLazy",
        enabled = vim.fn.has("nvim-0.10.0") == 1,
      },
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      event = "VeryLazy",
    },
  },
  opts = {
    ensure_installed = { "php", "blade" },
    auto_install = true,
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
  },
  config = function(_, opts)
    ---@class ParserInfo[]
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.blade = {
      install_info = {
        url = "https://github.com/EmranMR/tree-sitter-blade",
        files = {
          "src/parser.c",
        },
        branch = "main",
        generate_requires_npm = true,
        requires_generate_from_grammar = true,
      },
      filetype = "blade",
    }
    require("nvim-treesitter.configs").setup(opts)
  end,
}, {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      phpactor = {
        cmd = { "phpactor", "language-server" },
        filetypes = { "php", "blade" },
        root_dir = function(pattern)
          local util = require("lspconfig").util
          local cwd = vim.loop.cwd()
          local root = util.root_pattern("composer.json", ".git")(pattern)
          return (util.path.is_descendant(cwd, root) and cwd or root) or vim.env.HOME
        end,
      },
    },
  },
}, {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "pint",
      "tlint",
    },
  },
}, {
  "nvimtools/none-ls.nvim",
  optional = true,
  opts = function(_, opts)
    local nls = require("null-ls")
    opts.sources = opts.sources or {}
    table.insert(opts.sources, nls.builtins.formatting.pint)
    table.insert(opts.sources, nls.builtins.diagnostics.tlint)
  end,
}, {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters_by_ft = {
      php = { "tlint" },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        php = { "pint" },
      },
    },
  },
}
