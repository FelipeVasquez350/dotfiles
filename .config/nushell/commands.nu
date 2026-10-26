# Diff a remote NixOS system against the local flake build.
#
# Usage:
#   nixos-diff user@host control-plane               # default: .nix + flake.lock + secrets.yaml
#   nixos-diff user@host worker "hosts/*"            # only diff these paths
#   nixos-diff user@host worker "*"                  # diff every changed file
#   nixos-diff user@host worker "*.nix" "hosts/*"    # .nix files, but not under hosts/
def nixos-diff [
    host: string
    config: string
    include: string = "*.nix flake.lock *secrets.yaml"
    exclude: string = ""
] {
    print $"Building .#nixosConfigurations.($config)..."
    let new = (nix build $".#nixosConfigurations.($config).config.system.build.toplevel" --no-link --print-out-paths | str trim)

    print $"Fetching current system from ($host)..."
    let current = (ssh $host readlink /run/current-system | str trim)
    nix copy --no-check-sigs --from $"ssh://($host)" $current
    nvd diff $current $new

    print $"\nFetching applied flake source from ($host)..."
    let remote_src = (ssh $host readlink -f /etc/current-system-flake | str trim)
    let local_src = (nix flake metadata --json . | from json | get path | str trim)
    nix copy --no-check-sigs --from $"ssh://($host)" $remote_src

    if $remote_src == $local_src {
        print $"Flake source unchanged ($remote_src)."
        return
    }

    let include_patterns = ($include | split row " " | where { $in != "" })
    let exclude_patterns = ($exclude | split row " " | where { $in != "" })

    let files = (^git --no-pager diff --no-index --name-status $remote_src $local_src | complete | get stdout | lines | each { |line|
        let parts = ($line | split row "\t")
        if ($parts | length) >= 2 {
            let rel = (($parts | last) | str replace $"($remote_src)/" "" | str replace $"($local_src)/" "")
            { status: ($parts | first), rel: $rel }
        }
    } | where { $in != null })

    let filtered = $files | where { |f|
        let include_match = if ($include_patterns | length) > 0 {
            $include_patterns | any { |pat|
                if ($pat | str starts-with "*") and ($pat | str ends-with "*") {
                    $f.rel | str contains ($pat | str substring 1..-2)
                } else if ($pat | str starts-with "*") {
                    $f.rel | str ends-with ($pat | str substring 1..)
                } else if ($pat | str ends-with "*") {
                    $f.rel | str starts-with ($pat | str substring ..-2)
                } else {
                    $f.rel == $pat
                }
            }
        } else { true }

        let exclude_match = if ($exclude_patterns | length) > 0 {
            $exclude_patterns | any { |pat|
                if ($pat | str starts-with "*") and ($pat | str ends-with "*") {
                    $f.rel | str contains ($pat | str substring 1..-2)
                } else if ($pat | str starts-with "*") {
                    $f.rel | str ends-with ($pat | str substring 1..)
                } else if ($pat | str ends-with "*") {
                    $f.rel | str starts-with ($pat | str substring ..-2)
                } else {
                    $f.rel == $pat
                }
            }
        } else { false }

        $include_match and (not $exclude_match)
    }

    if ($filtered | length) == 0 {
        print "No changed files match the given include/exclude filters."
        return
    }

    print "Changed files:"
    $filtered | each { |f| print $"  ($f.status) ($f.rel)" }

    for entry in $filtered {
        let old_file = if ($remote_src | path join $entry.rel | path exists) { $"($remote_src)/($entry.rel)" } else { "/dev/null" }
        let new_file = if ($local_src | path join $entry.rel | path exists) { $"($local_src)/($entry.rel)" } else { "/dev/null" }
        ^git --no-pager diff --no-index --color=always $old_file $new_file | complete | get stdout | str replace $remote_src "" | str replace $local_src "" | print
    }
}

# Tint the terminal background while connected over ssh, restore it on exit.
# Uses OSC 21 to set fg/bg, and OSC 110/111 to reset them to the theme default.
#def --wrapped ssh [...rest] {
#    print -n $"\u{1b}]21;foreground=#FFFFFF;background=#1b2216;\u{7}"
#    try { ^ssh ...$rest }
#    print -n $"\u{1b}]110\u{7}\u{1b}]111\u{7}"
#}
