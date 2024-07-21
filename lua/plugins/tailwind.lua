local tailwind_ft = {
  "aspnetcorerazor",
  "astro",
  "astro-markdown",
  "blade",
  "clojure",
  "django-html",
  "htmldjango",
  "edge",
  "eelixir",
  "elixir",
  "ejs",
  "erb",
  "eruby",
  "gohtml",
  "gohtmltmpl",
  "haml",
  "handlebars",
  "hbs",
  "html",
  "htmlangular",
  "html-eex",
  "heex",
  "jade",
  "leaf",
  "liquid",
  "markdown",
  "mdx",
  "mustache",
  "njk",
  "nunjucks",
  "php",
  "razor",
  "slim",
  "twig",
  "css",
  "less",
  "postcss",
  "sass",
  "scss",
  "stylus",
  "sugarss",
  "javascript",
  "javascriptreact",
  "reason",
  "rescript",
  "typescript",
  "typescriptreact",
  "vue",
  "svelte",
  "templ"
}

return {
  recommended = function()
    return LazyVim.extras.wants({
      root = {
        "tailwind.config.js",
        "tailwind.config.cjs",
        "tailwind.config.mjs",
        "tailwind.config.ts",
        "postcss.config.js",
        "postcss.config.cjs",
        "postcss.config.mjs",
        "postcss.config.ts",
      },
    })
  end,

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          -- exclude a filetype from the default_config
          filetypes_exclude = { "markdown" },
          -- add additional filetypes to the default_config
          filetypes_include = {},
          -- to fully override the default_config, change the below
          -- filetypes = {}
        },
      },
      setup = {
        tailwindcss = function(_, opts)
          local tw = require("lspconfig.server_configurations.tailwindcss")
          opts.filetypes = opts.filetypes or {}

          -- Add default filetypes
          vim.list_extend(opts.filetypes, tw.default_config.filetypes)

          -- Remove excluded filetypes
          --- @param ft string
          opts.filetypes = vim.tbl_filter(function(ft)
            return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
          end, opts.filetypes)

          -- Additional settings for Phoenix projects
          opts.settings = {
            tailwindCSS = {
              includeLanguages = {
                elixir = "html-eex",
                eelixir = "html-eex",
                heex = "html-eex",
              },
            },
          }

          -- Add additional filetypes
          vim.list_extend(opts.filetypes, opts.filetypes_include or {})
        end,
      },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "rustywind" } },
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "roobert/tailwindcss-colorizer-cmp.nvim", opts = {} },
    },
    opts = function(_, opts)
      -- original LazyVim kind icon formatter
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        format_kinds(entry, item) -- add icons
        return require("tailwindcss-colorizer-cmp").formatter(entry, item)
      end
    end,
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters.rustywind = {}
      for _, ft in ipairs(tailwind_ft) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], "rustywind")
      end
    end,
  },
}
