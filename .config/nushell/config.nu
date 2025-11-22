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

# Fastfetch on startup
if ('ghostty' in ({} | load-env | echo $env.TERM_PROGRAM)) {
    try {
        print $"(ansi green)❯(ansi reset) (ansi blue)fastfetch(ansi reset)\n"
        fastfetch
    } catch { }
}
