if status is-interactive
    # Commands to run in interactive sessions can go here
end

function tmux-switch
    set session (tmux list-sessions -F '#S' | fzf --prompt="Select tmux session: " --tmux center)
    if test -n "$session"
        if test -n "$TMUX"
            tmux switch-client -t "$session"
        else
            tmux attach-session -t "$session"
        end
    end
end


function last_history_item
    echo $history[1]
end

function fzf_history
    eval (history | fzf)
end


if status is-login
    if test -z $DISPLAY; and test (tty) = "/dev/tty1"
        exec start-hyprland
    end
end

alias remote="git remote -v | rg 'http\S+' -o | fzf | xargs open"

abbr -a pi sudo pacman -S 
abbr -a ts -f tmux-switch
abbr -a gco git checkout
abbr -a gl git log --oneline
abbr -a gp git push origin
abbr -a sf source ~/.config/fish/config.fish
abbr -a r --function last_history_item
abbr -a hi fzf_history
abbr -a ll eza -l
