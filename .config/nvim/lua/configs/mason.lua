local options = {
    -- Disable automatic installation of LSP servers
    -- since we're using Nix to manage them
    automatic_installation = false,

    -- Keep Mason for other tools if needed
    ensure_installed = {
        -- You can still use Mason for formatters/linters not in Nix
        -- "stylua", -- if not available in Nix
        -- "prettier", -- if not available in Nix
    },

    -- Don't check for updates automatically
    check_outdated_packages_on_open = false,

    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
}

return options
