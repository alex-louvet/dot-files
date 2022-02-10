function update --wraps='paru && sudo paru -Rs (paru -Qqtd)' --description 'alias update paru && sudo paru -Rs (paru -Qqtd)'
  paru && sudo paru -Rs (paru -Qqtd) $argv; 
  paru -Qdtq | paru -Rs -
  xmonad --recompile
end
