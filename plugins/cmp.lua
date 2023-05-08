local notify = require("astronvim.utils").notify

-- Function that mark snippets as low priority kind
local lspkind_comparator = function(conf)
  local lsp_types = require('cmp.types').lsp
  return function(entry1, entry2)
    if entry1.source.name ~= 'nvim_lsp' then
      if entry2.source.name == 'nvim_lsp' then
        return false
      else
        return nil
      end
    end
    local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
    local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

    local priority1 = conf.kind_priority[kind1] or 0
    local priority2 = conf.kind_priority[kind2] or 0
    if priority1 == priority2 then
      return nil
    end
    return priority2 < priority1
  end
end

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
  },
  opts = function(_, opts)
    -- Setting up the colorizer for tailwind
    local format_kinds = opts.formatting.format

    opts.formatting.format = function(entry, item)
      format_kinds(entry, item)
      return require("tailwindcss-colorizer-cmp").formatter(entry, item)
    end

    -- Adding comparator for cmp (snippets - last)
    local cmp = require('cmp').config.compare
    cmp.lspkind_comparator = lspkind_comparator({
      kind_priority = {
        Snippet = 0
      }
    })

    opts.sorting = {
      comparators = {
        lspkind_comparator = lspkind_comparator({
          Snippet = 0
        })
      }
    }
  end
}
