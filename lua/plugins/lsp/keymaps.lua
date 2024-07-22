local M = {}

---@type LazyKeysLspSpec[]|nil
M._keys = nil

---@alias LazyKeysLspSpec LazyKeysSpec|{has?:string|string[], cond?:fun():boolean}
---@alias LazyKeysLsp LazyKeys|{has?:string|string[], cond?:fun():boolean}

---@return LazyKeysLspSpec[]
function M.get()
  if M._keys then
    return M._keys
  end
  -- stylua: ignore
  M._keys = {
    { "gd",         vim.lsp.buf.definition,                                                                                                                                                           desc = "Goto Definition",            has = "definition" },
    { "gr",         vim.lsp.buf.references,                                                                                                                                                           desc = "References",                 nowait = true },
    { "gI",         vim.lsp.buf.implementation,                                                                                                                                                       desc = "Goto Implementation" },
    { "gt",         vim.lsp.buf.type_definition,                                                                                                                                                      desc = "Goto T[y]pe Definition" },
    { "gD",         ":vsplit | lua vim.lsp.buf.definition()<cr>",                                                                                                                                     desc = "Go to Definition in Split",  nowait = true,           remap = false },
    { "K",          vim.lsp.buf.hover,                                                                                                                                                                desc = "Hover" },
    { "gK",         vim.lsp.buf.signature_help,                                                                                                                                                       desc = "Signature Help",             has = "signatureHelp" },
    { "<c-k>",      vim.lsp.buf.signature_help,                                                                                                                                                       mode = "i",                          desc = "Signature Help", has = "signatureHelp" },
    { "ga",         LazyVim.lsp.action.source,                                                                                                                                                        desc = "Source Action",              has = "codeAction" },

    { "tR",         "<cmd>TSToolsRenameFile<CR>",                                                                                                                                                     desc = "Rename File", },
    { "tU",         "<cmd>TSToolsRemoveUnusedImports<CR>",                                                                                                                                            desc = "Remove Unused Import", },
    { "ta",         "<cmd>TSToolsAddMissingImports<CR>",                                                                                                                                              desc = "Add Missing Imports", },
    { "td",         "<cmd>TSToolsGoToSourceDefinition<CR>",                                                                                                                                           desc = "Go to Definition", },
    { "tf",         "<cmd>TSToolsFixAll<CR>",                                                                                                                                                         desc = "Fix All", },
    { "to",         "<cmd>TSToolsOrganizeImports<CR>",                                                                                                                                                desc = "Organize Imports", },
    { "tr",         "<cmd>TSToolsFileReferences<CR>",                                                                                                                                                 desc = "Find references", },
    { "tu",         "<cmd>TSToolsRemoveUnused<CR>",                                                                                                                                                   desc = "Remove Unused Statement", },

    { "<leader>o",  "<cmd>lua require('telescope.builtin').lsp_document_symbols({ symbol_width = 60, previewer = false, initial_mode = normal, layout_config = { width = 0.3, height = 0.2 } })<CR>", desc = "LSP Outline",                mode = { "n" } },
    { "<leader>d",  "<cmd>Telescope diagnostics bufnr=0<cr>",                                                                                                                                         desc = "Buffer Diagnostics" },
    { "<leader>lC", vim.lsp.codelens.refresh,                                                                                                                                                         desc = "Refresh & Display Codelens", mode = { "n" },          has = "codeLens" },
    { "<leader>lL", "<cmd>LspLog<cr>",                                                                                                                                                                desc = "Lsp Log",                    mode = { "n", "v" } },
    { "<leader>ln", "<cmd>ConformInfo<CR>",                                                                                                                                                           desc = "<cmd>NullLsInfo<cr>",        mode = { "n", "v" } },
    { "<leader>lR", LazyVim.lsp.rename_file,                                                                                                                                                          desc = "Rename File",                mode = { "n" },          has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
    { "<leader>la", vim.lsp.buf.code_action,                                                                                                                                                          desc = "Code Action",                mode = { "n", "v" },     has = "codeAction" },
    { "<leader>lc", vim.lsp.codelens.run,                                                                                                                                                             desc = "Run Codelens",               mode = { "n", "v" },     has = "codeLens" },
    { "<leader>ll", "<cmd>LspInfo<cr>",                                                                                                                                                               desc = "Lsp Info",                   mode = { "n", "v" } },
    { "<leader>lr", vim.lsp.buf.rename,                                                                                                                                                               desc = "Rename",                     has = "rename" },
    -- {
    --   "]]",
    --   function() LazyVim.lsp.words.jump(vim.v.count1) end,
    --   has = "documentHighlight",
    --   desc = "Next Reference",
    --   cond = function() return LazyVim.lsp.words.enabled end
    -- },
    -- {
    --   "[[",
    --   function() LazyVim.lsp.words.jump(-vim.v.count1) end,
    --   has = "documentHighlight",
    --   desc = "Prev Reference",
    --   cond = function() return LazyVim.lsp.words.enabled end
    -- },
    -- {
    --   "<a-n>",
    --   function() LazyVim.lsp.words.jump(vim.v.count1, true) end,
    --   has = "documentHighlight",
    --   desc = "Next Reference",
    --   cond = function() return LazyVim.lsp.words.enabled end
    -- },
    -- {
    --   "<a-p>",
    --   function() LazyVim.lsp.words.jump(-vim.v.count1, true) end,
    --   has = "documentHighlight",
    --   desc = "Prev Reference",
    --   cond = function() return LazyVim.lsp.words.enabled end
    -- },
  }

  return M._keys
end

---@param method string|string[]
function M.has(buffer, method)
  if type(method) == "table" then
    for _, m in ipairs(method) do
      if M.has(buffer, m) then
        return true
      end
    end
    return false
  end
  method = method:find("/") and method or "textDocument/" .. method
  local clients = LazyVim.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

---@return LazyKeysLsp[]
function M.resolve(buffer)
  local Keys = require("lazy.core.handler.keys")
  if not Keys.resolve then
    return {}
  end
  local spec = M.get()
  local opts = LazyVim.opts("nvim-lspconfig")
  local clients = LazyVim.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    vim.list_extend(spec, maps)
  end
  return Keys.resolve(spec)
end

function M.on_attach(_, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = M.resolve(buffer)

  for _, keys in pairs(keymaps) do
    local has = not keys.has or M.has(buffer, keys.has)
    local cond = not (keys.cond == false or ((type(keys.cond) == "function") and not keys.cond()))

    if has and cond then
      local opts = Keys.opts(keys)
      opts.cond = nil
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end
end

return M
