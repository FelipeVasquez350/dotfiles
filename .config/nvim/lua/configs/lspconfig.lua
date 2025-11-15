-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- Get NvChad defaults
local nvlsp = require "nvchad.configs.lspconfig"

-- Function to check if LSP server is available in PATH
local function lsp_available(name)
    return vim.fn.executable(name) == 1
end

-- LSP servers that should be available from Nix devshell
local nix_servers = {
    clangd = "clangd",
    lua_ls = "lua-language-server",
    nil_ls = "nil",
    ts_ls = "typescript-language-server",
    html = "vscode-html-language-server",
    cssls = "vscode-css-language-server",
    jsonls = "vscode-json-language-server",
    gopls = "gopls",
    rust_analyzer = "rust-analyzer",
}

-- Setup LSP servers from Nix environment
for lsp_name, executable in pairs(nix_servers) do
    if lsp_available(executable) then
        local config = {
            on_attach = nvlsp.on_attach,
            on_init = nvlsp.on_init,
            capabilities = nvlsp.capabilities,
        }

        -- Special configuration for specific LSP servers
        if lsp_name == "clangd" then
            config.cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--completion-style=detailed",
                "--header-insertion=never",
                "--log=verbose",
                "--pretty"
            }
            config.init_options = {
                clangdFileStatus = true,
                usePlaceholders = true,
                completeUnimported = true,
                semanticHighlighting = true,
            }
            config.root_dir = function(fname)
                return require("lspconfig.util").root_pattern(
                    ".clangd",
                    ".clang-tidy",
                    ".clang-format",
                    "compile_commands.json",
                    "compile_flags.txt",
                    "configure.ac",
                    ".git"
                )(fname) or vim.fn.getcwd()
            end
        elseif lsp_name == "lua_ls" then
            config.settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        library = {
                            vim.fn.expand("$VIMRUNTIME/lua"),
                            vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                            vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
                            vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                        },
                        maxPreload = 100000,
                        preloadFileSize = 10000,
                    },
                },
            }
        end

        lspconfig[lsp_name].setup(config)
        print("LSP configured: " .. lsp_name .. " (" .. executable .. ")")
    else
        print("LSP not available: " .. lsp_name .. " (" .. executable .. ")")
    end
end

-- Fallback servers (if you still want some from Mason)
local fallback_servers = { "phpactor" }

for _, lsp in ipairs(fallback_servers) do
    lspconfig[lsp].setup {
        on_attach = nvlsp.on_attach,
        on_init = nvlsp.on_init,
        capabilities = nvlsp.capabilities,
    }
end
