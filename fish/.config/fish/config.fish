if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec hyprland
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

function starship_transient_prompt_func
    starship module character
end

starship init fish | source
enable_transience

pyenv init - | source

# pnpm
set -gx PNPM_HOME "/home/gabgil/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
