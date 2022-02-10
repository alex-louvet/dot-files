# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /home/alexandre/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<
#
set -x MANPAGER "nvim -c 'set ft=man' -"

neofetch

export IHP_EDITOR="code --goto"

starship init fish | source
