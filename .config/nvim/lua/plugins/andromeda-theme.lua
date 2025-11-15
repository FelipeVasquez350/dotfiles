return {
    {
        "NvChad/base46",
        lazy = false,
        priority = 1000,
        config = function()
            -- Register the custom Andromeda theme using package.preload
            -- This ensures it's available when base46 tries to load it
            package.preload["base46.themes.andromeda"] = function()
                return require("custom.themes.andromeda")
            end
        end,
    },
}
