
require("nvim-surround").setup({
    surrounds = {
        ["T"] = { -- For triple backticks
            add = { "```", "```" }
        },
        ["D"] = { -- For triple double quotes
            add = { '"""', '"""' }
        },
        ["S"] = { -- For triple single quotes
            add = { "'''", "'''" }
        }
    }
})



