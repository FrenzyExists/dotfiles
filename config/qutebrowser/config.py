

config.load_autoconfig()

config.set('content.notifications.enabled', True, 'https://www.youtube.com')


# Font used in the statusbar.
c.fonts.statusbar = '11pt "Victor Mono Italic"'

# URLS n Stuff
c.url.searchengines = {'DEFAULT': 'https://duckduckgo.com/?q={}', 'am': 'https://www.amazon.com/s?k={}', 'aw': 'https://wiki.archlinux.org/?search={}', 'goog': 'https://www.google.com/search?q={}', 'hoog': 'https://hoogle.haskell.org/?hoogle={}', 're': 'https://www.reddit.com/r/{}', 'ub': 'https://www.urbandictionary.com/define.php?term={}', 'wiki': 'https://en.wikipedia.org/wiki/{}', 'yt': 'https://www.youtube.com/results?search_query={}'}

# Default font size to use. 
c.fonts.default_size = '14pt'

# Font used in the completion widget.
c.fonts.completion.entry = '13pt "Victor Mono Italic"'

# Font used for the debugging console.
c.fonts.debug_console = '13pt "Victor Mono Italic"'

# Font used for prompts.
c.fonts.prompts = 'default_size Victor Mono Italic'

# Aliases for commands.
c.aliases = {'q': 'quit', 'w': 'session-save', 'wq': 'quit --save'}

# Bindings for normal mode
config.bind('M', 'hint links spawn mpv {hint-url}')
config.bind('Z', 'hint links spawn st -e youtube-dl {hint-url}')


# --| Colors n' stuff |--
aquarium = {
    "background_hard": "#1b1b23",
    "background_soft": "#2c2e3e",
    "foreground_hard": "#8791a3",
    "foreground_soft": "#a0a8b6",
    "bright_blue": "#cddbf9",
    "bright_yellow": "#ebe3b9",
    "bright_magenta": "#f6bbe7",
    "bright_red": "#ebb9b9",
    "bright_black": "#3b3b4d",
    "bright_cyan": "#b8dceb",
    "bright_green": "#caf6bb",
    "bright_white": "#c8cedc"
    }

# --|Background color for webpages if unset |--
c.colors.webpage.bg = aquarium["background_hard"]

# Text color of the completion widget. May be a single color to use for
# all columns or a list of three colors, one for each column.
c.colors.completion.fg = aquarium["foreground_hard"]

# Background color of the completion widget for odd rows.
c.colors.completion.odd.bg = aquarium["background_hard"]

# Background color of the completion widget for even rows.
c.colors.completion.even.bg = aquarium["background_hard"]

# Foreground color of completion widget category headers.
c.colors.completion.category.fg = aquarium["bright_green"]

# Background color of the completion widget category headers.
c.colors.completion.category.bg = aquarium["background_hard"]

# Top border color of the completion widget category headers.
c.colors.completion.category.border.top = aquarium["background_hard"]

# Bottom border color of the completion widget category headers.
c.colors.completion.category.border.bottom = aquarium["background_hard"]

# Foreground color of the selected completion item.
c.colors.completion.item.selected.fg = aquarium["foreground_hard"]

# Background color of the selected completion item.
c.colors.completion.item.selected.bg = aquarium["background_soft"]

# Top border color of the selected completion item.
c.colors.completion.item.selected.border.top = aquarium["background_soft"]

# Bottom border color of the selected completion item.
c.colors.completion.item.selected.border.bottom = aquarium["background_soft"]

# Foreground color of the matched text in the selected completion item.
c.colors.completion.item.selected.match.fg = aquarium["bright_green"]

# Foreground color of the matched text in the completion.
c.colors.completion.match.fg = aquarium["bright_green"]

# Color of the scrollbar handle in the completion view.
c.colors.completion.scrollbar.fg = aquarium["foreground_hard"]

# Color of the scrollbar in the completion view.
c.colors.completion.scrollbar.bg = aquarium["background_hard"]

# Background color of disabled items in the context menu.
c.colors.contextmenu.disabled.bg = aquarium["background_hard"]

# Foreground color of disabled items in the context menu.
#c.colors.contextmenu.disabled.fg = base04

# Background color of the context menu. If set to null, the Qt default is used.
c.colors.contextmenu.menu.bg = aquarium["background_hard"]

# Foreground color of the context menu. If set to null, the Qt default is used.
c.colors.contextmenu.menu.fg =  aquarium["foreground_hard"]

# Background color of the context menu’s selected item. If set to null, the Qt default is used.
c.colors.contextmenu.selected.bg = aquarium["background_soft"]

#Foreground color of the context menu’s selected item. If set to null, the Qt default is used.
c.colors.contextmenu.selected.fg = aquarium["foreground_hard"]

# Background color for the download bar.
c.colors.downloads.bar.bg = aquarium["background_hard"]

# Color gradient start for download text.
c.colors.downloads.start.fg = aquarium["background_hard"]

# Color gradient start for download backgrounds.
c.colors.downloads.start.bg = aquarium["bright_blue"]

# Color gradient end for download text.
c.colors.downloads.stop.fg = aquarium["background_hard"]

# Color gradient stop for download backgrounds.
c.colors.downloads.stop.bg = aquarium["bright_blue"]

# Foreground color for downloads with errors.
c.colors.downloads.error.fg = aquarium["bright_red"]

# Font color for hints.
c.colors.hints.fg = aquarium["background_hard"]

# Background color for hints. Note that you can use a `rgba(...)` value
# for transparency.
c.colors.hints.bg = aquarium["bright_green"]

# Font color for the matched part of hints.
c.colors.hints.match.fg = aquarium["foreground_hard"]

# Text color for the keyhint widget.
c.colors.keyhint.fg = aquarium["foreground_hard"]

# Highlight color for keys to complete the current keychain.
c.colors.keyhint.suffix.fg = aquarium["foreground_hard"]

# Background color of the keyhint widget.
c.colors.keyhint.bg = aquarium["background_hard"]

# Foreground color of an error message.
c.colors.messages.error.fg = aquarium["background_hard"]

# Background color of an error message.
c.colors.messages.error.bg = aquarium["bright_red"]

# Border color of an error message.
c.colors.messages.error.border = aquarium["bright_red"]

# Foreground color of a warning message.
c.colors.messages.warning.fg = aquarium["background_hard"]

# Background color of a warning message.
c.colors.messages.warning.bg = aquarium["bright_magenta"]

# Border color of a warning message.
c.colors.messages.warning.border = aquarium["bright_magenta"]

# Foreground color of an info message.
c.colors.messages.info.fg = aquarium["foreground_hard"]

# Background color of an info message.
c.colors.messages.info.bg = aquarium["background_hard"]

# Border color of an info message.
c.colors.messages.info.border = aquarium["background_hard"]

# Foreground color for prompts.
c.colors.prompts.fg = aquarium["foreground_hard"]

# Border used around UI elements in prompts.
c.colors.prompts.border = aquarium["background_hard"]

# Background color for prompts.
c.colors.prompts.bg = aquarium["background_hard"]

# Background color for the selected item in filename prompts.
c.colors.prompts.selected.bg = aquarium["background_soft"]

# Foreground color of the statusbar.
c.colors.statusbar.normal.fg = aquarium["bright_green"]

# Background color of the statusbar.
c.colors.statusbar.normal.bg = aquarium["background_hard"]

# Foreground color of the statusbar in insert mode.
c.colors.statusbar.insert.fg = aquarium["bright_yellow"]

# Background color of the statusbar in insert mode.
c.colors.statusbar.insert.bg = aquarium["background_hard"]

# Foreground color of the statusbar in passthrough mode.
c.colors.statusbar.passthrough.fg = aquarium["background_hard"]

# Background color of the statusbar in passthrough mode.
c.colors.statusbar.passthrough.bg = aquarium["bright_blue"]

# Foreground color of the statusbar in private browsing mode.
c.colors.statusbar.private.fg = aquarium["background_hard"]

# Background color of the statusbar in private browsing mode.
c.colors.statusbar.private.bg = aquarium["background_hard"]

# Foreground color of the statusbar in command mode.
c.colors.statusbar.command.fg = aquarium["foreground_hard"]

# Background color of the statusbar in command mode.
c.colors.statusbar.command.bg = aquarium["background_hard"]

# Foreground color of the statusbar in private browsing + command mode.
c.colors.statusbar.command.private.fg = aquarium["foreground_hard"]

# Background color of the statusbar in private browsing + command mode.
c.colors.statusbar.command.private.bg = aquarium["background_hard"]

# Foreground color of the statusbar in caret mode.
c.colors.statusbar.caret.fg = aquarium["bright_green"]

# Background color of the statusbar in caret mode.
c.colors.statusbar.caret.bg = aquarium["background_hard"]

# Foreground color of the statusbar in caret mode with a selection.
c.colors.statusbar.caret.selection.fg = aquarium["background_hard"]

# Background color of the statusbar in caret mode with a selection.
c.colors.statusbar.caret.selection.bg = aquarium["bright_blue"]

# Background color of the progress bar.
c.colors.statusbar.progress.bg = aquarium["bright_blue"]

# Default foreground color of the URL in the statusbar.
c.colors.statusbar.url.fg = aquarium["foreground_hard"]

# Foreground color of the URL in the statusbar on error.
c.colors.statusbar.url.error.fg = aquarium["bright_red"]

# Foreground color of the URL in the statusbar for hovered links.
c.colors.statusbar.url.hover.fg = aquarium["foreground_hard"]

# Foreground color of the URL in the statusbar on successful load
# (http).
c.colors.statusbar.url.success.http.fg = aquarium["bright_blue"]

# Foreground color of the URL in the statusbar on successful load
# (https).
c.colors.statusbar.url.success.https.fg = aquarium["bright_green"]

# Foreground color of the URL in the statusbar when there's a warning.
c.colors.statusbar.url.warn.fg = aquarium["bright_magenta"]

# Background color of the tab bar.
c.colors.tabs.bar.bg = aquarium["background_hard"]

# Color gradient start for the tab indicator.
c.colors.tabs.indicator.start = aquarium["bright_blue"]

# Color gradient end for the tab indicator.
c.colors.tabs.indicator.stop = aquarium["bright_blue"]

# Color for the tab indicator on errors.
c.colors.tabs.indicator.error = aquarium["bright_red"]

# Foreground color of unselected odd tabs.
c.colors.tabs.odd.fg = aquarium["foreground_hard"]

# Background color of unselected odd tabs.
c.colors.tabs.odd.bg = aquarium["background_hard"]

# Foreground color of unselected even tabs.
c.colors.tabs.even.fg = aquarium["foreground_hard"]

# Background color of unselected even tabs.
c.colors.tabs.even.bg = aquarium["background_hard"]

# Background color of pinned unselected even tabs.
c.colors.tabs.pinned.even.bg = aquarium["bright_blue"]

# Foreground color of pinned unselected even tabs.
c.colors.tabs.pinned.even.fg = aquarium["foreground_soft"]

# Background color of pinned unselected odd tabs.
c.colors.tabs.pinned.odd.bg = aquarium["bright_green"]

# Foreground color of pinned unselected odd tabs.
c.colors.tabs.pinned.odd.fg = aquarium["foreground_soft"]

# Background color of pinned selected even tabs.
c.colors.tabs.pinned.selected.even.bg = aquarium["background_soft"]

# Foreground color of pinned selected even tabs.
c.colors.tabs.pinned.selected.even.fg = aquarium["foreground_hard"]

# Background color of pinned selected odd tabs.
c.colors.tabs.pinned.selected.odd.bg = aquarium["background_soft"]

# Foreground color of pinned selected odd tabs.
c.colors.tabs.pinned.selected.odd.fg = aquarium["foreground_hard"]

# Foreground color of selected odd tabs.
c.colors.tabs.selected.odd.fg = aquarium["foreground_hard"]

# Background color of selected odd tabs.
c.colors.tabs.selected.odd.bg = aquarium["background_soft"]

# Foreground color of selected even tabs.
c.colors.tabs.selected.even.fg = aquarium["foreground_hard"]

# Background color of selected even tabs.
c.colors.tabs.selected.even.bg = aquarium["background_soft"]

config.bind('aq', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/aquarium-style.css ""')
