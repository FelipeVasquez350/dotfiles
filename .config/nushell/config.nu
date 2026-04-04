source ~/.config/nushell/starship.nu
source ~/.config/nushell/zoxide.nu
source ~/.config/nushell/keybindings.nu
source ~/.config/nushell/scripts/ssh_clear.nu

let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}

let external_completer = {|spans: list<string>|
    let expanded_alias = scope aliases
        | where name == $spans.0
        | get 0?.expansion

    let spans = if $expanded_alias != null {
        $expanded_alias
        | split row ' '
        | append ($spans | skip 1)
    } else {
        $spans
    }

    $carapace_completer | do $in $spans
}

# fzf-based completion — inserts selected completion into the command line
def comp-insert [] {
    let input = commandline
    if ($input | is-empty) { return }

    let cmd = $input | split row ' ' | first

    let completions = try {
        carapace $cmd nushell $input ""
        | from json
        | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { [] }
    } catch { [] }

    if ($completions | is-empty) { return }

    let selected = $completions
        | each {|item|
            let desc = $item.description? | default ""
            if ($desc | is-empty) {
                $item.value
            } else {
                $"($item.value | fill --width 20 --alignment left) -- ($desc)"
            }
        }
        | str join "\n"
        | fzf --no-preview --height=50% --layout=reverse --info=inline --no-separator --prompt='> '

    if not ($selected | is-empty) {
        let value = $selected | split row ' -- ' | first | str trim
        commandline edit -i $" ($value)"
    }
}

$env.config = {
    show_banner: false
    color_config: {
        shape_external: { fg: "green" }
    }

    history: {
        max_size: 100_000
        sync_on_enter: true
        file_format: "sqlite"
        isolation: true
    }

    completions: {
        external: {
            enable: true
            max_results: 100
            completer: $external_completer
        }
    }

    hooks: {
        pre_prompt: [{ ||
            if (which direnv | is-empty) { return }
            direnv export json | from json | default {} | load-env
            if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
                $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
            }
        }]
    }
}

if ($env.TERM_PROGRAM? == 'ghostty') {
    try { fastfetch }
}
