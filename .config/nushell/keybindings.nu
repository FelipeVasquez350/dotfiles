$env.config.keybindings ++= [
    {
        name: fzf_completion
        modifier: Control
        keycode: Char_f
        mode: [emacs, vi_insert]
        event: {
            send: executehostcommand
            cmd: "comp-insert"
        }
    }
    {
        name: delete_word_left
        modifier: Control
        keycode: Char_h
        mode: [emacs, vi_insert]
        event: { edit: BackspaceWord }
    }
]
