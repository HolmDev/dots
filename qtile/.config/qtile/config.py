# vim:fileencoding=utf-8:foldmethod=marker
# {{{ Imports
from typing import List  # noqa: F401

from libqtile import bar, layout, widget, hook, qtile
from libqtile.config import Click, Drag, Group, Match, Screen, Key
from libqtile.lazy import lazy

from os.path import expandvars
import os

from time import sleep
import requests
# }}}

from xrcat import xrcat
xrcat.updateResources()

# {{{ Custom functions
win_list = []
def stick_win(qtile):
    global win_list
    win_list.append(qtile.current_window)
def unstick_win(qtile):
    global win_list
    if qtile.current_window in win_list:
        win_list.remove(qtile.current_window)
@hook.subscribe.setgroup
def move_win():
    for w in win_list:
        w.togroup(qtile.current_group.name)

# {{{ Keybinds
keys = [
    # Move focus
    Key(["mod4"], "h", lazy.layout.left(), desc="Move focus to left"),
    Key(["mod4"], "j", lazy.layout.down(), desc="Move focus down"),
    Key(["mod4"], "k", lazy.layout.up(),  desc="Move focus up"),
    Key(["mod4"], "l", lazy.layout.right(), desc="Move focus to right"),
    # Move window
    Key(["mod4", "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to left"),
    Key(["mod4", "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key(["mod4", "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key(["mod4", "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to right"),
    # Grow window
    Key(["mod4", "control"], "j", lazy.layout.shrink(), desc="Shrink focused window"),
    Key(["mod4", "control"], "k", lazy.layout.grow(), desc="Grow focused window"),
    Key(["mod4"],"n", lazy.layout.normalize(), desc="Reset window sizes"),
    # Launch applications
    Key(["mod4"],"Return", lazy.spawn(xrcat.getResource("apps.terminal")), desc="Launch terminal"),
    Key(["mod4"],"w", lazy.spawn(xrcat.getResource("apps.browser")), desc="Launch browser"),
    Key(["mod4"],"e", lazy.spawn(xrcat.getResource("apps.explorer")), desc="Launch explorer"),
    Key(["mod4"],"p", lazy.spawn("kpmenu"), desc="Launch password manager"),
    Key(["mod4"],"d", lazy.spawn(xrcat.getResource("apps.editor")), desc="Launch emacs"),
    # Misc Qtile stuff
    Key(["mod4"],"Tab", lazy.next_layout(), desc="Switch to next layout"),
    Key(["mod4", "shift"], "c", lazy.window.kill(), desc="Kill current window"),
    Key(["mod4", "control"], "r", lazy.restart(), desc="Restart window manager"),
    Key(["mod4"], "f", lazy.window.toggle_fullscreen(), desc="Toggles fullscreen"),
    Key(["mod4"], "b", lazy.hide_show_bar(), desc="Toggles the bar"),
    Key(["mod4"], "o", lazy.function(stick_win), desc="stick win"),
    Key(["mod4", "shift"], "o", lazy.function(unstick_win), desc="unstick win"),
    Key(["mod4", "shift"], "s", lazy.spawn("sh -c 'xcolor | xclip -sel clip && dunstify \"Copied color: $(xclip -o -sel clip)\"'"), desc="Color picker"),
    # Rofi
    Key(["mod4", "control"],"q", lazy.spawn(expandvars("$HOME/.scripts/goodbye")), desc="Launch goodbye script"),
    Key(["mod4"], "r", lazy.spawn("rofi -show drun"), desc="Spawn rofi with drun"),
    Key(["mod1"], "Tab", lazy.spawn("rofi -show window"), desc="Switch windows with rofi"),
    # Scrot
    Key(["mod4"], "g", lazy.spawn("sh -c 'scrot ~/Pictures/scrot/%Y-%m-%d-%H:%M:%S.png'"), desc="Take screenshot of the whole screen"),
    Key(["mod4", "shift"], "g", lazy.spawn("sh -c 'scrot -f -s ~/Pictures/scrot/%Y-%m-%d-%H:%M:%S.png'"), desc="Take screenshot of a portion of the screen"),
    # Audio control
    Key([], "XF86AudioRaiseVolume", lazy.spawn(expandvars("sh -c 'pamixer -i 2; $HOME/.scripts/display-volume'")), desc="Raise volume"),
    Key([], "XF86AudioLowerVolume", lazy.spawn(expandvars("sh -c 'pamixer -d 2; $HOME/.scripts/display-volume'")), desc="Lower volume"),
    Key([], "XF86AudioMute", lazy.spawn(expandvars("sh -c 'pamixer -t; $HOME/.scripts/display-volume'")), desc="Toggle mute"),
    Key([], "XF86AudioPlay", lazy.spawn("sh -c 'playerctl play-pause'"), desc="Play/pause music"),
    Key([], "XF86AudioPrev", lazy.spawn("sh -c 'playerctl previous'"), desc="Play previous track"),
    Key([], "XF86AudioNext", lazy.spawn("sh -c 'playerctl next'"), desc="Play next track"),
    # Macro Keys
    Key([], "XF86Tools", lazy.spawn("dunstify \"Macro Key #1\""), desc="Test macro key #1"),
    Key([], "XF86Launch5", lazy.spawn("dunstify \"Macro Key #2\""), desc="Test macro key #2"),
    Key([], "XF86Launch6", lazy.spawn("dunstify \"Macro Key #3\""), desc="Test macro key #3"),
    Key([], "XF86Launch7", lazy.spawn("dunstify \"Macro Key #4\""), desc="Test macro key #4"),
    Key([], "XF86Launch8", lazy.spawn("dunstify \"Macro Key #5\""), desc="Test macro key #5"),
]
# }}}

# {{{ Groups
groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend([
    Key(["mod4"], i.name, lazy.group[i.name].toscreen(), desc="Switch to group {}".format(i.name)),
    Key(["mod4", "shift"], i.name, lazy.window.togroup(i.name, switch_group=True), desc="Switch to & move window to group {}".format(i.name)),
    ])
# }}}

# {{{ Layouts
layout_defaults = dict(
 margin = int(xrcat.getResource("qtile.gaps")),
 border_width = int(xrcat.getResource("qtile.border_width")),
 border_focus = xrcat.getResource("qtile.color4"),
 border_focus_stack = xrcat.getResource("qtile.color4"),
 border_normal = xrcat.getResource("qtile.color0")
)

layouts = [
 layout.MonadTall(**layout_defaults)
]
# }}}

# {{{ Widgets and bar
widget_defaults = dict(
    font=xrcat.getResource("qtile.font_type"),
    fontsize=int(xrcat.getResource("qtile.font_size")),
    padding=3,
    background=xrcat.getResource("qtile.background"),
    foreground=xrcat.getResource("qtile.foreground"),
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.TextBox(
                    text="\uf303",
                    fontsize=20,
                    foreground=xrcat.getResource("qtile.color4")
                               ),
                widget.GroupBox(
                    disable_drag=True,
                    rounded=False,
                    highlight_method="line",
                    highlight_color = [xrcat.getResource("qtile.background"),xrcat.getResource("qtile.background")],
                    borderwidth=2,
                    active=xrcat.getResource("qtile.foreground"),
                    this_current_screen_border=xrcat.getResource("qtile.color4"),
                    urgent_border=xrcat.getResource("qtile.color1")
                    ),
                widget.TextBox(
                    text="\ue0b1",
                    fontsize=20,
                    foreground=xrcat.getResource("qtile.color4")
                               ),
                widget.TaskList(
                    rounded=False,
                    highlight_method="block",
                    icon_size=0,
                    border=xrcat.getResource("qtile.background"),
                    markup_focused=("<span>[ {} ]</span>"),
                    markup_floating=("<span foreground=\""+xrcat.getResource("qtile.color2")+"\">\ufab1 {}</span>"),
                    markup_maximized=("<span foreground=\""+xrcat.getResource("qtile.color3")+"\">\ufaae {}</span>"),
                    markup_minimized=("<span foreground=\""+xrcat.getResource("qtile.color5")+"\">\ufaaf {}</span>"),
                    title_width_method="uniform",
                    margin=0,
                    urgent_border=xrcat.getResource("qtile.color1")
                ),
                widget.TextBox(
                    text="\ue0b3",
                    fontsize=20,
                    foreground=xrcat.getResource("qtile.color4")
                               ),
                #widget.GenPollText(
                #    func=torCountry,
                #    update_interval=60
                #),
                widget.Systray(),
                widget.Clock(format='%Y-%m-%d %a %H:%M'),
                #widget.CurrentLayoutIcon()
            ],
            size=24,
            margin=0,
            opacity=1.0
        ),
    ),
]
# }}}

# {{{ Mouse
# Drag floating layouts.
mouse = [
    Drag(["mod4"], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag(["mod4"], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click(["mod4"], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
# }}}

# {{{ Floating rules
floating_layout = layout.Floating(float_rules=[
    *layout.Floating.default_float_rules,
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='pinentry'),  # GPG key password entry
])
# }}}

# {{{ Other rules
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True

wmname = "LG3D"
# }}}

# {{{ Autostart
os.system("nitrogen --restore")
# }}}
