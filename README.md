# My personal dotfiles

A bit janky but it does the job done

## Glossary
> yes i do forget shortcuts very often so i need to have them written somewhere

- `<C-x>` stands for `Ctrl + x` (exit terminal mode)
- `<A-h>` stands for `Alt + h` (toggle horizontal terminal)
- `<leader>` is `Shift + Space` (nvim)
- `<prefix>` is `Ctrl + Space` (tmux) REMINDER: Press <prefix>, lift your fingers, then press the keybind

## TMUX

Default session: `default`

| Move              | Keybind        |
| ----------------- | -------------- |
| Create new client | `<prefix> + c` |
| Delete window     | `<prefix> + &` |
| Navigate windows  | `<prefix> + w` |
| Deatach           | `<prefix> + d` |

## NVIM

### Move between Windows

| Move  | Keybind    |
| ----- | ---------- |
| UP:   | `Ctrl + k` |
| DOWN: | `Ctrl + j` |
| LEFT: | `Ctrl + h` |
| RIGHT | `Ctrl + l` |
so this means that

| H   | J   | K   | L   |
| --- | --- | --- | --- |
| ←   | ↓   | ↑   | →   |

***S SHAPED***

```bash
    k---l
    |
h---j
```

> yes i need this in my head otherwise imma blow up



### Shortcuts
| Move              | Keybind  |
| ----------------- | -------- |
| Start of line     | `<C-a>`  |
| End of line       | `<C-e>`  |
| Enter edit mode   | `i`      |
| Enter cancel mode | `cancel` |
| Enter view mode   | `v`      |

### Normal mode

| Move                       | Keybind        |
| -------------------------- | -------------- |
| View File tree on side     | `<leader> + e` |
| Create horizontal terminal | `<leader> + h` |
| Create vertical terminal   | `<leader> + v` |
| Paste                      | `p`            |
| Undo                       | `u`            |

### View mode

| Move               | Keybind |
| ------------------ | ------- |
| Copy in view mode  | `y`     |
| Cut in view mode   | `c`     |


### Insert mode
| Move                   | Keybind |
| ---------------------- | ------- |
| Scroll up suggestion   | `<C-p>` |
| Scroll down suggestion | `<C-i>` |
