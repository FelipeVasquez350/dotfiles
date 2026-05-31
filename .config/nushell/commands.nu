# Diff current remote NixOS system against local flake build

# Usage: nixos-diff user@host control-plane
def nixos-diff [host: string, config: string] {
    let new = (nix build $".#nixosConfigurations.($config).config.system.build.toplevel" --no-link --print-out-paths | str trim)
    print $"Building .#nixosConfigurations.($config)..."

    print $"Fetching current system from ($host)..."
    let current = (ssh $host readlink /run/current-system | str trim)
    nix copy --no-check-sigs --from $"ssh://($host)" $current

    nvd diff $current $new
}
