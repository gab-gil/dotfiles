if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec start-hyprland
    end
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

function launch
    $argv & disown && exit
end

function dup
    docker compose up -d
end

function mgdir
    mkdir $argv[1] && cd $argv[1]
end

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (cat -- $tmp); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        cd -- "$cwd"
    end
    rm -f -- $tmp
end

function starship_transient_prompt_func
    starship module character
end

function fzf_cd
    set dir (zoxide query -l | fzf)
    if test -n "$dir"
        cd "$dir"
        commandline -f repaint
    end
end

starship init fish | source
zoxide init fish | source
enable_transience

pyenv init - | source

bind \cf fzf_cd

# pnpm
set -gx PNPM_HOME "/home/gabgil/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
