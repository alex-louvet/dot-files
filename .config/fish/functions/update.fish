function update --wraps='paru && sudo paru -Rs (paru -Qqtd)' --description 'alias update paru && sudo paru -Rs (paru -Qqtd)'
    paru -Syu $argv && sudo paru -Rs (paru -Qqtd); 
    xmonad --recompile
    bash ~/.config/polybar/launch.sh
end
