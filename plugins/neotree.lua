local notify = require("astronvim.utils").notify

function check_is_kotlin_module(dir)
  local path = require("plenary.path")
  local p = path:new(dir .. "/build.gradle.kts")
  local is_exists = p:exists()

  return is_exists
end

function config_icons(config, node, state)
  local hightlights = require("neo-tree.ui.highlights")

  local icon = config.default or " "
  local padding = config.padding or " "
  local highlight = config.highlight or " "

  if node.type == "directory" then
    highlight = hightlights.DIRECTORY_ICON
    if node:is_expanded() then
      icon = config.folder_open or "-"
    else
      icon = config.folder_closed or "+"
    end


    if check_is_kotlin_module(node.path) then
      icon = ""
    end
  elseif node.type == "file" then
    local success, web_devicons = pcall(require, "nvim-web-devicons")
    if success then
      local devicon, hl = web_devicons.get_icon(node.name, node.ext)
      icon = devicon or icon
      highlight = hl or highlight
    end
  end

  return {
    text = icon .. padding,
    highlight = highlight
  }
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    opts.window.width = 50
    opts.filesystem.components = {
      icon = config_icons
    }

    opts.filesystem.filtered_items = {
      hide_dotfiles = false,
      hide_by_name = {
        ".git",
        ".idea",
        ".run",
        "node_modules"
      },
      always_show = {
        ".dev",
        ".env"
      }
    }
    -- opts.filesystem.group_empty_dirs = true
    -- notify("Some message", 3)
  end
}
