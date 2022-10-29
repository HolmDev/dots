# dots

Various dotfiles for my Linux machines

## Install

*Be sure to run these commands from the repo's top dir!*

Install all dotfiles:

```
$ stow -t ~ */
```

Install specific dotfiles:

```
$ stow -t ~ <package>
```

Show what changes are going to be made:

```
$ stow -nv -t ~ */
```

## Dependencies

These dotfiles cover and require the following programs

| Package | Dependencies |
|:--|:--|
| xorg | pywal, picom, nm-applet, udiskie, dunst, lxsession, emacs, xautolock |
| dk | dk, polybar, sxhkd, nitrogen, rofi, kitty, qutebrowser, thunar, emacs, xcolor, xclip, dunstify, pamixer, playerctl |
| zathura | zathura |
| emacs | emacs |
| wal | wal |
| rofi | rofi, wal |
| dunst | dunst |

## Notes

- The icons I use are generated by Oomox to `~/.icons` and then symlinked to `/usr/share/icons`
- I use a swedish layout with some minor mods, so for most people the `.Xmodmap` and parts of `.xprofile` in the `xorg` package should be removed/altered
- The `sxhkdrc` in the `dk` package contains keybinds for people using `blackwidowcontrol` to enable macro keys on Razer keyboards. Certain multimedia keys may malfunction if used on other keyboards
