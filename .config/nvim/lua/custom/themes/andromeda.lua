-- Zed Legacy Andromeda theme for NvChad
-- Based on the official Zed Legacy Andromeda color scheme

local M = {}

M.base_30 = {
    white = "#f7f7f8",
    darker_black = "#1a1d23",
    black = "#1e2025", -- nvim bg
    black2 = "#21242b",
    one_bg = "#252931",
    one_bg2 = "#2a2f39",
    one_bg3 = "#2b2f38",
    grey = "#40434c",
    grey_fg = "#565960",
    grey_fg2 = "#6b6b73",
    light_grey = "#aca8ae",
    red = "#f82871",
    baby_pink = "#ff6bcb",
    pink = "#c74cec",
    line = "#252931", -- for lines like vertsplit
    green = "#96df71",
    vibrant_green = "#96df71",
    nord_blue = "#10a793",
    blue = "#10a793",
    yellow = "#fee56c",
    sun = "#f29c14",
    purple = "#c74cec",
    dark_purple = "#893ea6",
    teal = "#08e7c5",
    orange = "#f29c14",
    cyan = "#08e7c5",
    statusline_bg = "#262933",
    lightbg = "#21242b",
    pmenu_bg = "#10a793",
    folder_bg = "#10a793",
}

M.base_16 = {
    base00 = "#1e2025", -- Default background
    base01 = "#21242b", -- Lighter background (status bars)
    base02 = "#2a2f39", -- Selection background
    base03 = "#565960", -- Comments, invisibles, line highlighting
    base04 = "#aca8ae", -- Dark foreground (status bars)
    base05 = "#f7f7f8", -- Default foreground, caret, delimiters, operators
    base06 = "#f7f7f8", -- Light foreground (not often used)
    base07 = "#f7f7f8", -- Light background (not often used)
    base08 = "#f82871", -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 = "#f29c14", -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A = "#fee56c", -- Classes, Markup Bold, Search Text Background
    base0B = "#96df71", -- Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = "#08e7c5", -- Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = "#fee56c", -- Functions, Methods, Attribute IDs, Headings
    base0E = "#10a793", -- Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = "#c74cec", -- Deprecated, Opening/Closing Embedded Language Tags
}

M.polish_hl = {
    treesitter = {
        -- Comments
        ["@comment"] = { fg = M.base_30.light_grey },
        ["@comment.documentation"] = { fg = M.base_30.light_grey },

        -- Keywords and control flow
        ["@keyword"] = { fg = M.base_30.blue },
        ["@keyword.function"] = { fg = M.base_30.blue },
        ["@keyword.operator"] = { fg = M.base_30.blue },
        ["@keyword.return"] = { fg = M.base_30.blue },
        ["@keyword.conditional"] = { fg = M.base_30.blue },
        ["@keyword.repeat"] = { fg = M.base_30.blue },
        ["@keyword.storage"] = { fg = M.base_30.blue },
        ["@keyword.modifier"] = { fg = M.base_30.blue },
        ["@storageclass"] = { fg = M.base_30.blue },

        -- Functions
        ["@function"] = { fg = M.base_30.yellow },
        ["@function.builtin"] = { fg = M.base_30.yellow },
        ["@function.call"] = { fg = M.base_30.yellow },
        ["@method"] = { fg = M.base_30.yellow },
        ["@method.call"] = { fg = M.base_30.yellow },
        ["@constructor"] = { fg = M.base_30.blue },

        -- Variables and identifiers
        ["@variable"] = { fg = M.base_30.white },
        ["@variable.builtin"] = { fg = M.base_30.white },
        ["@parameter"] = { fg = M.base_30.white },

        -- Properties and fields
        ["@property"] = { fg = M.base_30.blue },
        ["@field"] = { fg = M.base_30.blue },
        ["@attribute"] = { fg = M.base_30.blue },

        -- Types
        ["@type"] = { fg = M.base_30.cyan },
        ["@type.builtin"] = { fg = M.base_30.cyan },
        ["@type.definition"] = { fg = M.base_30.cyan },
        ["@type.qualifier"] = { fg = M.base_30.cyan },

        -- Constants and literals
        ["@constant"] = { fg = M.base_30.green },
        ["@constant.builtin"] = { fg = M.base_30.green },
        ["@boolean"] = { fg = M.base_30.green },
        ["@number"] = { fg = M.base_30.green },

        -- Strings
        ["@string"] = { fg = M.base_30.orange },
        ["@string.regex"] = { fg = M.base_30.orange },
        ["@string.escape"] = { fg = M.base_30.light_grey },
        ["@string.special"] = { fg = M.base_30.orange },
        ["@string.special.path"] = { fg = M.base_30.orange },

        -- Operators and punctuation
        ["@operator"] = { fg = M.base_30.orange },
        ["@punctuation"] = { fg = "#d8d5db" },
        ["@punctuation.bracket"] = { fg = "#d8d5db" },
        ["@punctuation.delimiter"] = { fg = "#d8d5db" },
        ["@punctuation.special"] = { fg = "#d8d5db" },

        -- Namespace and scope resolution
        ["@namespace"] = { fg = M.base_30.cyan },
        ["@scope"] = { fg = "#d8d5db" },

        -- Preprocessor
        ["@preproc"] = { fg = M.base_30.blue },
        ["@include"] = { fg = M.base_30.blue },

        -- Tags and markup
        ["@tag"] = { fg = M.base_30.blue },
        ["@tag.attribute"] = { fg = M.base_30.blue },
        ["@tag.delimiter"] = { fg = "#d8d5db" },

        -- Enums and variants
        ["@enum"] = { fg = M.base_30.orange },
        ["@variant"] = { fg = M.base_30.blue },

        -- C++ specific highlighting
        ["@type.qualifier.cpp"] = { fg = M.base_30.blue },
        ["@keyword.modifier.cpp"] = { fg = M.base_30.blue },
        ["@storageclass.cpp"] = { fg = M.base_30.blue },
        ["@namespace.cpp"] = { fg = M.base_30.cyan },
        ["@scope.cpp"] = { fg = "#d8d5db" },
        ["@operator.cpp"] = { fg = M.base_30.orange },
        ["@punctuation.delimiter.cpp"] = { fg = "#d8d5db" },
        ["@punctuation.bracket.cpp"] = { fg = "#d8d5db" },
        ["@include.cpp"] = { fg = M.base_30.blue },
        ["@string.special.symbol.cpp"] = { fg = M.base_30.orange },
    },

    syntax = {
        Comment = { fg = M.base_30.light_grey },
        Constant = { fg = M.base_30.green },
        String = { fg = M.base_30.orange },
        Character = { fg = M.base_30.orange },
        Number = { fg = M.base_30.green },
        Boolean = { fg = M.base_30.green },
        Float = { fg = M.base_30.green },
        Identifier = { fg = M.base_30.white },
        Function = { fg = M.base_30.yellow },
        Statement = { fg = M.base_30.blue },
        Conditional = { fg = M.base_30.blue },
        Repeat = { fg = M.base_30.blue },
        Label = { fg = M.base_30.blue },
        Operator = { fg = M.base_30.orange },
        Keyword = { fg = M.base_30.blue },
        Exception = { fg = M.base_30.blue },
        PreProc = { fg = M.base_30.blue },
        Include = { fg = M.base_30.blue },
        Define = { fg = M.base_30.blue },
        Macro = { fg = M.base_30.white },
        PreCondit = { fg = M.base_30.white },
        Type = { fg = M.base_30.cyan },
        StorageClass = { fg = M.base_30.blue },
        Structure = { fg = M.base_30.cyan },
        Typedef = { fg = M.base_30.cyan },
        Special = { fg = M.base_30.blue },
        SpecialChar = { fg = M.base_30.orange },
        Tag = { fg = M.base_30.blue },
        Delimiter = { fg = "#d8d5db" },
        SpecialComment = { fg = M.base_30.light_grey },
        Debug = { fg = M.base_30.red },
        Underlined = { underline = true },
        Error = { fg = M.base_30.red },
        Todo = { fg = M.base_30.yellow, bold = true },

        -- Traditional vim syntax highlighting for better coverage
        cInclude = { fg = M.base_30.blue },
        cIncluded = { fg = M.base_30.orange },
        cPreProc = { fg = M.base_30.blue },
        cDefine = { fg = M.base_30.blue },
        cppStructure = { fg = M.base_30.blue },
        cppAccess = { fg = M.base_30.blue },
        cppType = { fg = M.base_30.cyan },
        cppStatement = { fg = M.base_30.blue },
        cppOperator = { fg = M.base_30.orange },
        cppNumber = { fg = M.base_30.green },
        cppBoolean = { fg = M.base_30.green },
        cppString = { fg = M.base_30.orange },
        cppRawString = { fg = M.base_30.orange },
        cppStorageClass = { fg = M.base_30.blue },
    },

    lsp = {
        DiagnosticError = { fg = M.base_30.red },
        DiagnosticWarn = { fg = M.base_30.yellow },
        DiagnosticInfo = { fg = M.base_30.blue },
        DiagnosticHint = { fg = "#618399" },
        LspReferenceText = { bg = "#10a793", fg = "#1e2025" },
        LspReferenceRead = { bg = "#10a793", fg = "#1e2025" },
        LspReferenceWrite = { bg = "#64646d" },
    },
}

M.type = "dark"

return M
