-- ─   Project Notes Utilities ──
-- Utilities for managing project-specific notes

local M = {}

-- Extract project ID from current working directory
-- The project ID is the last component of the path
local function extractProjectId()
  local cwd = vim.fn.getcwd()
  local projectId = vim.fn.fnamemodify(cwd, ":t")
  return projectId
end

-- Get the notes directory for current project
local function getNotesDir()
  local home = vim.fn.expand("~")
  local projectId = extractProjectId()
  return home .. "/Documents/Notes/proj/" .. projectId
end

local function getNotesProjDir()
  local home = vim.fn.expand("~")
  return home .. "/Documents/Notes/proj/"
end

-- Ensure notes folder and general.md exist
-- If project has local notes folder, moves it to global location
local function ensureNotesFolder()
  local cwd = vim.fn.getcwd()
  local notesDir = getNotesDir()
  local generalMd = notesDir .. "/general.md"
  local projectId = extractProjectId()
  local localNotesDir = cwd .. "/notes"

  -- Check if notes directory exists in global location
  if vim.fn.isdirectory(notesDir) == 0 then
    -- Check if there's a local notes folder in the project
    if vim.fn.isdirectory(localNotesDir) == 1 then
      -- Move local notes folder to global location
      local parent = vim.fn.expand("~/Documents/Notes/proj")
      vim.fn.mkdir(parent, "p")
      local result = vim.fn.system("mv '" .. localNotesDir .. "' '" .. notesDir .. "'")
      if vim.v.shell_error == 0 then
        print("Moved local notes folder to: " .. notesDir)
      else
        print("Failed to move local notes folder: " .. result)
        return nil
      end
    else
      -- Create notes directory
      vim.fn.mkdir(notesDir, "p")
      print("Created notes directory: " .. notesDir)
    end
  end

  -- Create general.md if it doesn't exist
  if vim.fn.filereadable(generalMd) == 0 then
    local lines = { "# " .. projectId, "" }
    vim.fn.writefile(lines, generalMd)
    print("Created general.md for project: " .. projectId)
  end

  return notesDir, generalMd
end

-- Open project notes in a split
function M.openNotes()
  local notesDir, generalMd = ensureNotesFolder()

  -- Open in vertical split
  vim.cmd("vsplit " .. generalMd)
end

-- Open project notes in a new tab
function M.openNotesTab()
  local notesDir, generalMd = ensureNotesFolder()

  -- Open in new tab
  vim.cmd("tabnew " .. generalMd)
end

-- Open project notes directory in netrw
function M.openNotesDir()
  local notesDir = ensureNotesFolder()
  vim.cmd("vsplit " .. notesDir)
end

function M.openNotesProjDir()
  local notesDir = getNotesProjDir()
  vim.cmd("vsplit " .. notesDir)
end

-- Create a new note file in project notes directory
function M.createNote()
  local notesDir = ensureNotesFolder()

  -- Prompt for filename
  local filename = vim.fn.input("Note filename: ")
  if filename == "" then
    return
  end

  -- Add .md extension if not present
  if not filename:match("%.md$") then
    filename = filename .. ".md"
  end

  local notePath = notesDir .. "/" .. filename
  vim.cmd("edit " .. notePath)
end

-- List all notes for current project using telescope
function M.findNotes()
  local notesDir = getNotesProjDir()

  -- Use telescope if available, otherwise use native find
  local has_telescope, telescope = pcall(require, "telescope.builtin")
  if has_telescope then
    telescope.find_files({
      prompt_title = "Project Notes",
      cwd = notesDir,
      hidden = false,
    })
  else
    vim.cmd("edit " .. notesDir)
  end
end

function M.browseNotes()
  local notesDir = getNotesProjDir()

  require('utils.general').Search_file_browser(notesDir, '')

end


return M
