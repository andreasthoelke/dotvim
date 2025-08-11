
vim.keymap.set("n", "<leader>tn", function() require("neotest").run.run() end) -- nearest test
vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end) -- file
vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end) -- summary window

-- ~/.config/nvim/plugged/neotest-vitest/lua/neotest-vitest/init.lua
-- plugged/neotest-vitest
-- plugged/neotest/
-- lua require("neotest").jump.next()

-- lua require("neotest").summary.jumpto()

require("neotest").setup({
  adapters = {
    require("neotest-vitest") {
      -- Filter directories when searching for test files. Useful in large projects (see Filter directories notes).
      filter_dir = function(name, rel_path, root)
        return name ~= "node_modules"
          and name ~= "plugged"
      end,
    },
  },

  benchmark = {
    enabled = true
  },
  consumers = {},
  default_strategy = "integrated",
  diagnostic = {
    enabled = true,
    severity = 1
  },
  discovery = {
    concurrent = 0,
    enabled = true
  },
  floating = {
    max_height = 0.6,
    max_width = 0.6,
    options = {}
  },
  highlights = {
    adapter_name = "NeotestAdapterName",
    border = "NeotestBorder",
    dir = "NeotestDir",
    expand_marker = "NeotestExpandMarker",
    failed = "NeotestFailed",
    file = "NeotestFile",
    focused = "NeotestFocused",
    indent = "NeotestIndent",
    marked = "NeotestMarked",
    namespace = "NeotestNamespace",
    passed = "NeotestPassed",
    running = "NeotestRunning",
    select_win = "NeotestWinSelect",
    skipped = "NeotestSkipped",
    target = "NeotestTarget",
    test = "NeotestTest",
    unknown = "NeotestUnknown",
    watching = "NeotestWatching"
  },
  icons = {
    child_indent = "│",
    child_prefix = "├",
    collapsed = "─",
    expanded = "╮",
    failed = "x",
    final_child_indent = " ",
    final_child_prefix = "╰",
    non_collapsible = "─",
    notify = "",
    passed = "•",
    running = "",
    running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
    skipped = ".",
    unknown = "╴",
    watching = ""
  },
  jump = {
    enabled = true
  },
  log_level = 3,
  output = {
    enabled = true,
    open_on_run = "short"
  },
  output_panel = {
    enabled = true,
    open = "botright split | resize 15"
  },
  projects = {},
  quickfix = {
    enabled = true,
    open = false
  },
  run = {
    enabled = true
  },
  running = {
    concurrent = true
  },
  state = {
    enabled = true
  },
  status = {
    enabled = true,
    signs = true,
    virtual_text = false
  },
  strategies = {
    integrated = {
      height = 40,
      width = 120
    }
  },
  summary = {
    animated = true,
    count = true,
    enabled = true,
    expand_errors = true,
    follow = true,
    mappings = {
      attach = "a",
      clear_marked = "M",
      clear_target = "T",
      debug = "d",
      debug_marked = "D",
      expand = { "i", "<CR>", "<2-LeftMouse>" },
      expand_all = "e",
      help = "?",
      jumpto = "p",
      mark = "m",
      next_failed = "<leader>J",
      output = "o",
      prev_failed = "K",
      run = "r",
      run_marked = "R",
      short = "O",
      stop = "u",
      target = "t",
      watch = "<leader>w"
    },
    open = "botright vsplit | vertical resize 50"
  },

})
