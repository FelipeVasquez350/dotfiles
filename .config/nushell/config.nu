source ~/.config/nushell/starship.nu
source ~/.config/nushell/zoxide.nu
source ~/.config/nushell/keybindings.nu

let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}

let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -o 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    $carapace_completer | do $in $spans
}

# Helper function for fzf-based completion (prints result)
# Usage: comp "docker"
def comp [input: string = ""] {
    if ($input | is-empty) {
        print "Usage: comp \"docker\""
        return
    }

    let parts = ($input | split row ' ')
    let cmd = ($parts | get 0)

    let completions = (
        try {
            carapace $cmd nushell $input ""
            | from json
            | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { [] }
        } catch {
            []
        }
    )

    if ($completions | is-empty) {
        print "No completions found"
        return
    }

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

    if not ($selected | is-empty) {
        let value = ($selected | split row ' -- ' | get 0 | str trim)
        print $"($input) ($value)"
    }
}

# Helper function for fzf-based completion that inserts into commandline
# Usage: comp-insert (to be called from keybinding)
def comp-insert [] {
    let input = (commandline | str trim)

    if ($input | is-empty) {
        return
    }

    let parts = ($input | split row ' ')
    let cmd = ($parts | get 0)

    let completions = (
        try {
            carapace $cmd nushell $input ""
            | from json
            | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { [] }
        } catch {
            []
        }
    )

    if ($completions | is-empty) {
        return
    }

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

    if not ($selected | is-empty) {
        let value = ($selected | split row ' -- ' | get 0 | str trim)
        commandline edit -i $" ($value)"
    }
}

$env.config = {
    show_banner: false

    color_config: {
        shape_external: { fg: "green" }
    }

    history: {
        max_size: 5000
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
          if (which direnv | is-empty) {
            return
          }

          direnv export json | from json | default {} | load-env
          if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
            $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
          }
        }]
    }
}

if ('ghostty' in ({} | load-env | echo $env.TERM_PROGRAM)) {
    try {
        print $"(ansi green)❯(ansi reset) (ansi blue)fastfetch(ansi reset)\n"
        fastfetch
    } catch { }
}
