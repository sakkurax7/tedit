# tedit
Terminal text editor made in C-17.

## Build
Recompile the source with
```
make
```
you can now run this as ./tedit or to install just clone the repository and

```
chmod +x install.sh
./install.sh
```

## Configuration
Main shared state and types live in src/tedit.h, runtime config is in src/config.c. The editor looks for the config in ``$XDG_CONFIG_HOME/tedit/config``, then ``~/.config/tedit/config``, then ``~/.teditrc``. Options include ``tab_stop``, ``quit_confirmations``, ``open_confirmations``, ``show_line_numbers``, ``soft_wrap``, ``soft_indent``, and ``auto_indent``. See ``tedit.conf.example`` for more information.