#!/usr/bin/env nu

# Get current command line
let line = (commandline)

if ($line | is-empty) {
    exit
}

# Parse command line
let parts = ($line | split row ' ')
let cmd = ($parts | get 0)

if ($cmd | is-empty) {
    exit
}

# Get completions from carapace
let completions = (
    try {
        carapace $cmd nushell $line ""
        | from json
        | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { [] }
    } catch {
        []
    }
)

if ($completions | is-empty) {
    exit
}

# Format completions and show in fzf
let selected = (
    $completions
    | each { |item|
        let value = $item.value
        let desc = ($item.description? | default "")
        if ($desc | is-empty) {
            $value
        } else {
            let padded_value = ($value | fill --width 20 --alignment left)
            $"($padded_value) -- ($desc)"
        }
    }
    | str join "\n"
    | fzf --no-preview --height=50% --layout=reverse --info=inline --no-separator --prompt='> '
)

# Insert selected completion
if not ($selected | is-empty) {
    let value = ($selected | split row ' -- ' | get 0 | str trim)
    commandline edit -i " "
    commandline edit -i $value
}
