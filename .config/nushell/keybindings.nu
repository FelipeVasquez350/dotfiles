$env.config.keybindings ++= [
    {
        name: delete_word_left
        modifier: Control
        keycode: Char_h
        mode: [emacs, vi_insert]
        event: { edit: BackspaceWord }
    }
]
