
-- vim.ui.input( { prompt="please: " }, function(inp) return vim.print( inp ) end )

-- vim.fs.dirname( vim.fn.getcwd() )
-- vim.fs.find( 'functional.lua' )
-- vim.fs.find( '*.lua' )

-- vim.fs.find( "build.sbt", { path=vim.uv.os_homedir() .. "/Documents/Proj" } )
-- vim.fs.find( { "api", "db" }, { limit=20, type='directory', path=vim.uv.os_homedir() .. "/Documents/Proj" } )
-- -- get all files ending with .cpp or .hpp inside lib/
-- vim.fs.find(function(name, path) return name:match('.*%.lua$') and path:match('[/\\\\]lua$') end, {limit = 20, type = 'file'})
-- vim.fs.parents(vim.api.nvim_buf_get_name(0))

function _G.GetRootDir()
  for dir in vim.fs.parents(vim.api.nvim_buf_get_name(0)) do
    if vim.fn.isdirectory(dir .. "/.git") == 1 then
      return dir
    end
  end
end
-- GetRootDir()





