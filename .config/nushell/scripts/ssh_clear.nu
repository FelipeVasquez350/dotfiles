def "ssh-clean" [target: string] {
    let hosts_file = ($env.HOME | path join ".ssh" "known_hosts")

    if not ($hosts_file | path exists) {
        print $"Error: ($hosts_file) not found."
        return
    }

    # Backup the file just in case
    cp $hosts_file $"($hosts_file).bak"

    # Filter out the lines matching the IP/Hostname
    let original_content = (open $hosts_file --raw | lines)
    let new_content = ($original_content | where $it !~ $target)

    let removed_count = (($original_content | length) - ($new_content | length))

    if $removed_count > 0 {
        $new_content | save --force $hosts_file
        print $"Success: Removed ($removed_count) entry/entries for '($target)'."
        print $"Backup saved as ($hosts_file).bak"
    } else {
        print $"No entries found for '($target)'."
        rm $"($hosts_file).bak" # Clean up unused backup
    }
}
